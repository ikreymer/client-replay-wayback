## Client-Side Replay Wayback

A test system for access-control WARC record lookup, using OutbackCDX and nginx (pywb used for indexing only).
Designed to test the work in nla/outbackcdx#80


1. Place WARC files in `./data/warcs/`

2. Launch with docker-compose build; docker-compose up -d

3. Lookup a `<URL>` via OutbackCDX on port 8087: `http://localhost:8087/testindex?url=<URL>&fl=original,timestamp,range,warcurl`

4. Load the WARC record via `curl -r $range $warcurl` where `$range` and `$warcurl` are the 3rd and 4th column of the result


Only the WARC record at the specified will be acccessible with the given token, and only for a limited amount (currently set to 300 seconds).

