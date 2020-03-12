## Client-Side Replay Wayback

A test system for access-control WARC record lookup, using OutbackCDX and nginx (pywb used for indexing only).
Designed to test the work in nla/outbackcdx#80


1. Place WARC files in `./data/warcs/`

2. Launch with `docker-compose build; docker-compose up -d`. (The WARCs are automatically indexed via cdx-indexer from pywb and POSTed to OutbackCDX)

3. Access replay via wabac.js at `http://localhost:8086/wayback/archive/<URL>`


## Notes

The replay for each url involves a:

- A CDX lookup via OutbackCDX via `http://localhost:8086/cdx/testindex?url=<URL>&fl=original,timestamp,range,warcurl`.

- An authorized WARC record range to a WARC, served by nginx at: `http://localhost:8086/warcs/$FILENAME?st=...&ts=...&e=...`


The exact WARC url includes an HMAC token that is used to verify the range. The request is made via:

`fetch("$warcurl", headers: {'Range': '$range'})` where `$range` and `$warcurl` are the 3rd and 4th column of the CDX result.

Only the WARC record at the specified will be accessible with the given token, and only for a limited amount (currently set to 300 seconds).

