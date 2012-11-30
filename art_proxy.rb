#! /usr/local/bin/ruby
# encoding: utf-8

require "webrick"
require "webrick/httpproxy"
require 'find'
include WEBrick

$STORE_BAG_XML = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Document xmlns="http://www.apple.com/itms/">
	<Protocol>
		<plist version="1.0">
			<dict>
				<key>jingleDocType</key><string>initiateSessionSuccess</string>
				<key>jingleAction</key><string>mzInitiateSession</string>
				<key>urlBag</key>
				<dict>
					<key>storeFront</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/storeFront</string>
					<key>newUserStoreFront</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/storeFront</string>
					<key>newIPodUserStoreFront</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/newIPodUser?newIPodUser=true</string>
					<key>newPhoneUser</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/phoneLandingPage</string>									 
					<key>search</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZSearch.woa/wa/DirectAction/search</string>
					<key>advancedSearch</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZSearch.woa/wa/DirectAction/advancedSearch</string>
					<key>parentalAdvisory</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/parentalAdvisory</string>
					<key>songMetaData</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/songMetaData</string>
					<key>browse</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/browse</string>
					<key>browseStore</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/browseStore</string>
					<key>browseGenre</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/browseGenre</string>
					<key>browseArtist</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/browseArtist</string>
					<key>browseAlbum</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/browseAlbum</string>
					<key>viewAlbum</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/viewAlbum</string>
					<key>viewArtist</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/viewArtist</string>
					<key>viewComposer</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/viewComposer</string>
					<key>viewGenre</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/viewGenre</string>
					<key>viewPodcast</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/viewPodcast</string>
					<key>viewPublishedPlaylist</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/viewPublishedPlaylist</string>
					<key>viewVideo</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/viewVideo</string>
					<key>podcasts</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/viewPodcastDirectory</string>
					<key>externalURLSearchKey</key><string>ax.phobos.apple.com.edgesuite.net</string>
					<key>externalURLReplaceKey</key><string>phobos.apple.com</string>
					<key>libraryLink</key><string>http://phobos.apple.com/WebObjects/MZSearch.woa/wa/DirectAction/libraryLink</string>
					<key>selectedItemsPage</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/selectedItemsPage</string>
					<key>ministore</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/ministoreV2</string>
					<key>ministore-fields</key><string>a,kind,p</string>
					<key>ministore-match</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZSearch.woa/wa/ministoreMatchV2</string>
					<key>ministore-match-fields</key><string>an,gn,kind,pn</string>
					<key>mini-store-welcome</key><string>http://phobos.apple.com/WebObjects/MZStore.woa/wa/ministoreClientOptIn</string>
					<key>mini-store</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wa/ministoreV2</string>
					<key>mini-store-fields</key><string>a,kind,p</string>
					<key>mini-store-match</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZSearch.woa/wa/ministoreMatchV2</string>
					<key>mini-store-match-fields</key><string>an,gn,kind,pn</string>
					<key>cover-art</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZSearch.woa/wa/coverArtMatch</string>
					<key>cover-art-fields</key><string>a,p</string>
					<key>cover-art-match</key><string>http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZSearch.woa/wa/coverArtMatch</string>
					<key>cover-art-match-fields</key><string>cddb,an,pn</string>
					<key>maxComputers</key><string>5</string>
					<key>maxPublishedPlaylistItems</key><integer>250</integer>
					<key>trustedDomains</key>
					<array>
						<string>.apple.com</string>
						<string>.apple.com.edgesuite.net</string>
						<string>support.mac.com</string>
						<string>.itunes.com</string>
						<string>itunes.com</string>
						<string>click.linksynergy.com</string>
					</array>
				</dict>
			</dict>
		</plist>
	</Protocol>
</Document>'

$COVER_INFO_XML = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Document xmlns="http://www.apple.com/itms/" disableHistory="true" disableNavigation="true">
	<Protocol>
		<plist version="1.0">
			<dict>
				<key>status</key><integer>0</integer>
				<key>cover-art-url</key><string>http://ax.itunes.apple.com/serveArtwork?key=%s</string>
				<key>request-delay-seconds</key><string>.1</string>
				<key>artistName</key><string>%artist</string>
				<key>playlistName</key><string>%playlist</string>
				<key>artistId</key><string>0</string>
				<key>playlistId</key><string>0</string>
				<key>matchType</key><string>2</string>
			</dict>
		</plist>
	</Protocol>
</Document>'

$NO_COVER_FOUND_XML = '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<Document xmlns="http://www.apple.com/itms/" disableHistory="true" disableNavigation="true">
	<Protocol>
		<plist version="1.0">
			<dict>
				<key>status</key><integer>3004</integer>
				<key>cover-art-url</key><string></string>
				<key>request-delay-seconds</key><string>.1</string>
			</dict>
		</plist>
	</Protocol>
</Document>'

$COVERS = Array.new

$CONTENT_TYPES = {"jpeg" => "image/jpeg", "jpg" => "image/jpeg", "png" => "image/png", "gif" => "image/gif"}

def search_direcory(dir, subdir_name)
	return File.new(File.join(dir.path, subdir_name)) if(File.exist?(File.join(dir.path, subdir_name)))
	return File.new(File.join(dir.path, subdir_name.gsub(":", " ").gsub("/", ":"))) if(File.exist?(File.join(dir.path, subdir_name.gsub(":", " ").gsub("/", ":"))))
	return File.new(File.join(dir.path, subdir_name.gsub(":", "_").gsub("/", ":"))) if(File.exist?(File.join(dir.path, subdir_name.gsub(":", "_").gsub("/", ":"))))
	return nil
end

def first_image(dir)
	found = nil
	Find.find(dir) do |path|
		Find.prune if found != nil
		found = path if(path =~ (/\.(gif|jpg|jpeg|png)$/i))
	end
	return found
end

def put_xml(req, resp, xml)
	resp["content-type"] = "text/xml; charset=UTF-8"
	resp.status = 200
	resp.body = xml
end

def search_album_artwork(artist, album)
	path = "/"+File.join("Users", "rafi", "Music", "Artworks")
	artwork_dir = File.new(path)
	
	puts "Searching for #{artist} - #{album}"
	
	artist_dir = search_direcory(artwork_dir, artist)
	return nil if artist_dir == nil
	
	album_dir = search_direcory(artist_dir, album)
	return nil if album_dir == nil
	
	album_dir = album_dir.path
	album_dir.force_encoding('utf-8-mac')
	image_file = first_image(album_dir)
	return nil if image_file == nil
	
	return image_file
end

def set_proxy_conf
	`scselect CoverArtProxy`
end

def reset_proxy_conf
	`scselect Automatic`
end

@serve_proc = lambda do |req, resp|
	key = req.query["key"].to_i
	cover = $COVERS[key]
	cover =~ (/\.(gif|jpg|jpeg|png)$/i)
	suffix = $1
	resp["content-type"] = $CONTENT_TYPES[suffix.downcase]
	resp.body = File.new(cover).read
end

@store_bag_proc = lambda do |req, resp|
	put_xml(req, resp, $STORE_BAG_XML)
end

@cover_art_match_proc = lambda do |req, resp|
	artist = req.query["an"]
	album = req.query["pn"]

	begin
		image_file = search_album_artwork(artist, album)
	rescue
		image_file = nil
	end
	if image_file == nil
		begin
			image_file = search_album_artwork("Compilation", album)
		rescue
			image_file = nil
		end
		artist = "Compilation"
	end
	
	return put_xml(req, resp, $NO_COVER_FOUND_XML)	if (image_file == nil)

	$COVERS<<image_file if !($COVERS.include?(image_file))
	index = $COVERS.index(image_file)
	put_xml(req, resp, $COVER_INFO_XML.gsub("%s", index.to_s).gsub("%artist", artist.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")).gsub("%playlist", album.gsub("&", "&amp;").gsub("<", "&lt;").gsub(">", "&gt;")))
end

set_proxy_conf


def configure_proxy(opts = {})
	proxy = WEBrick::HTTPProxyServer.new(
		:Port => 4001,
		:RequestCallback => Proc.new{|req, res|
			puts "Host: "+req['host']
			if !req.path.nil?
				puts "Location: "+req.path
			end
			servlet, options, script_name, path_info = proxy.search_servlet(req.path)
			puts "Servlet Found: "+(!servlet.nil?).to_s
			if !servlet.nil?
				servlet = servlet.get_instance(proxy, *options)
				servlet.service(req, res)
				raise HTTPStatus[200]
			end
			puts '-'*88
		}
	)

	serve = HTTPServlet::ProcHandler.new(@serve_proc)
	store_bag = HTTPServlet::ProcHandler.new(@store_bag_proc)
	cover_art_match = HTTPServlet::ProcHandler.new(@cover_art_match_proc)

	proxy.mount("/serveArtwork", serve)
	proxy.mount("/WebObjects/MZSearch.woa/wa/coverArtMatch", cover_art_match)
	proxy.mount("/WebObjects/MZStoreServices.woa/wa/coverArtMatch", cover_art_match)
	proxy.mount("/storeBag.xml.gz", store_bag)

	trap("INT") do
		proxy.shutdown
	end

	proxy.start

end

configure_proxy

trap("INT") do
	reset_proxy_conf
end