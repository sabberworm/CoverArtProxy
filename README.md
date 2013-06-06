# CoverArtProxy

Serve arbitrary artworks to iTunes’ “Get Album Artwork” command.

Putting artwork directly into the audio files blows them up unnecessarily. Loading artworks from iTunes alleviates this issue but is only available to albums actually in the iTunes store and the artwork is limited to 600x600 pixels. CoverArtProxy aims to resolve these problems by passing as the iTunes cover server and allows you to use your own artwork files.

## Prerequisites

Have [`mitmproxy`](http://mitmproxy.org/) or `mitmdump` installed. Have a directory (or symlink) ready named “Artworks” containing the following structure: `Artist/Album/image`. Images may be either in JPEG, GIF or PNG formats. You also need to have two Network locations ready, “Automatic” and “CoverArtProxy”, with CoverArtProxy having configured HTTP and HTTPS proxies to localhost, port 8080.

## Installation

* Run the included `run.sh` script once and end it with `ctrl+c`.
* The script should have run `mitmdump`, which should have generated a fake root-ca. Import this into your keychain to have the system trust it.
* Run `run.sh` again with a `$CWD` that contains your `Artworks` dir.
* Have iTunes download cover artwork and enjoy.

## Configuration

You can choose to use `mitmproxy` instead of `mitmdump` by exporting its path to `$MITM_CMD`.

## License

CoverArtProxy is freely distributable under the terms of an MIT-style license.

Copyright (c) 2012 Raphael Schweikert, http://ra-phi.ch/

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
