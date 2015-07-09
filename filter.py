#coding=utf-8
from subprocess import Popen
from subprocess import check_output
from libmproxy.protocol.http import decoded
import os
import re
import glob
import sys

SET_PATTERN = re.compile(r'([a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12})\s*\((.*)\)', re.IGNORECASE)
MY_ALBUM_ART_FOLDER = os.path.abspath("./")
EXTENSIONS = {'jpg': 'image/jpeg', 'jpeg': 'image/jpeg', 'png': 'image/png', 'gif': 'image/gif'}

artwork_mapping = {}
request_mapping = {}
previous_location = None

def start(context, argv):
    global previous_location
    out = check_output("scselect", universal_newlines=True)
    sets = out.splitlines()[1:]
    for network_set in sets:
        network_set = network_set.strip()
        is_selected = network_set.startswith('*')
        if not is_selected:
            continue
        network_set = SET_PATTERN.search(network_set)
        if not network_set:
            continue
        previous_location = network_set.group(1)
        break
    Popen(("scselect", "CoverArtProxy"))

def done(context):
    if previous_location is not None:
        Popen(("scselect", previous_location))


def request(context, flow):
    if flow.request.path.startswith("/WebObjects/MZStoreServices.woa/wa/coverArtMatch"):
        return artwork_query_request(context, flow)


def artwork_query_request(context, flow):
    query = flow.request.get_query()
    if not ("an" in query):
        # This is for an album downloaded from iTunes, we’ve only got an id for artist and album.
        # Make sure it comes back with an error so iTunes tries again with names for both.
        query['a'] = ['B8jOURYtHxYv',]
        query['p'] = ['Qpfz0SDV4Xgr',]
    else:
        artist = query["aan"][0] if ("aan" in query) else query["an"][0]
        album = query["pn"][0]
        request_mapping[flow.request] = (artist, album)
        # We can’t intercept the response to this request as there’s some kind of checksum in it.
        # But we can intercept the response to the image being served for this request.
        # So we need to use something we’re sure will yield a correct response.
        query["aan"] = query["an"] = ["Britney Spears",]
        query["pn"] = ["Britney",]
        query["dummy"] = [artist, album]
    flow.request.set_query(query)


def response(context, flow):
    if flow.request.path.startswith("/WebObjects/MZStoreServices.woa/wa/coverArtMatch"):
        return artwork_query_response(context, flow)
    if flow.request.url in artwork_mapping:
        return artwork_serve_response(context, artwork_mapping[flow.request.url], flow)


def artwork_query_response(context, flow):
    response = flow.response
    with decoded(response):
        artwork_url = response.content.partition('<dict>')[2]
        artwork_url = artwork_url.partition('http')[2]
        artwork_url = artwork_url.partition('</string>')[0]
        artwork_url = 'http' + artwork_url.strip()
        artwork_mapping[artwork_url] = request_mapping[flow.request]
        print artwork_url, 'for', request_mapping[flow.request]

def artwork_folder(artist, album):
    path = os.path.join(MY_ALBUM_ART_FOLDER, artist, album)
    if os.path.exists(path):
        return path
    path = os.path.join(MY_ALBUM_ART_FOLDER, artist.replace('/', '_'), album.replace('/', '_'))
    if os.path.exists(path):
        return path
    path = os.path.join(MY_ALBUM_ART_FOLDER, artist.replace('/', '_').replace(':', '_'), album.replace('/', '_').replace(':', '_'))
    return path

def serve_artwork_in_folder(folder, flow):
    files = glob.glob(os.path.join(folder, '*.*'))
    for file in files:
        extension = file.rpartition('.')[2].lower()
        if not extension in EXTENSIONS:
            continue
        print "Outputting file " + file
        response = flow.response
        with decoded(response):
            with open(file) as fptr:
                response.headers["Content-Type"] = [EXTENSIONS[extension],]
                response.content = fptr.read()
                response.code = 200
                return True
    return False


def artwork_serve_response(context, artwork_info, flow):
    print "Trying to get artwork for", artwork_info[0], "–", artwork_info[1]
    if serve_artwork_in_folder(artwork_folder(artwork_info[0], artwork_info[1]), flow):
        print "Found exact match"
        return
    if serve_artwork_in_folder(artwork_folder("Compilation", artwork_info[1]), flow):
        print "Found compilation match"
        return
    print "No match found"
    response = flow.response
    with decoded(response):
        response.content = ''
        response.code = 404
