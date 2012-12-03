#coding=utf-8
from subprocess import Popen
from libmproxy.flow import decoded
import os
import glob
import sys

my_album_art_folder = "/Users/rafi/Music/Artworks"

extensions = {'jpg': 'image/jpeg', 'jpeg': 'image/jpeg', 'png': 'image/png', 'gif': 'image/gif'}

artwork_mapping = {}
request_mapping = {}

def start(context):
    Popen(("scselect", "CoverArtProxy"))


def done(context):
    Popen(("scselect", "Automatic"))


def request(context, flow):
    if flow.request.path.startswith("/WebObjects/MZStoreServices.woa/wa/coverArtMatch"):
        return artwork_query_request(context, flow)


def artwork_query_request(context, flow):
    query = flow.request.get_query()
    if not ("an" in query):
        return
    artist = query["aan"][0] if ("aan" in query) else query["an"][0]
    album = query["pn"][0]
    request_mapping[flow.request] = (artist, album)
    # Use something we’re sure will yield a correct response
    query["aan"] = query["an"] = ("Britney Spears",)
    query["pn"] = ("Britney",)
    query["dummy"] = (artist, album)
    flow.request.set_query(query)


def response(context, flow):
    if flow.request.path.startswith("/WebObjects/MZStoreServices.woa/wa/coverArtMatch"):
        return artwork_query_response(context, flow)
    if flow.request.get_url() in artwork_mapping:
        return artwork_serve_response(context, artwork_mapping[flow.request.get_url()], flow)


def artwork_query_response(context, flow):
    response = flow.response
    with decoded(response):
        artwork_url = response.content.partition('<dict>')[2]
        artwork_url = artwork_url.partition('http')[2]
        artwork_url = artwork_url.partition('</string>')[0]
        artwork_url = 'http' + artwork_url.strip()
        artwork_mapping[artwork_url] = request_mapping[flow.request]
        print artwork_url, 'for', request_mapping[flow.request]


def serve_artwork_in_folder(folder, flow):
    files = glob.glob(os.path.join(folder, '*.*'))
    for file in files:
        extension = file.rpartition('.')[2]
        if not extension in extensions:
            continue
        print "Outputting file " + file
        response = flow.response
        with decoded(response):
            with open(file) as fptr:
                response.headers["Content-Type"] = (extensions[extension],)
                response.content = fptr.read()
                response.code = 200
                return True
    return False


def artwork_serve_response(context, artwork_info, flow):
    print "Trying to get artwork for", artwork_info
    if serve_artwork_in_folder(os.path.join(my_album_art_folder, artwork_info[0], artwork_info[1]), flow):
        print "Found exact match"
        return
    if serve_artwork_in_folder(os.path.join(my_album_art_folder, "Compilations", artwork_info[1]), flow):
        print "Found compilation match"
        return
    print "No match found"
    response = flow.response
    with decoded(response):
        response.content = ''
        response.code = 404