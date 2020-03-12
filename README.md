## Client-Side Replay Wayback

A test system for access-control WARC record lookup, using OutbackCDX and nginx (pywb used for indexing only).
Designed to test the work in nla/outbackcdx#80


1. Place WARC files in `./data/warcs/`

2. Launch with docker-compose build; docker-compose up -d

3. Lookup url via OutbackCDX on port 8087: `http://localhost:8087/testindex?url=http://archive.rhizome.org:8080/welcome-to-my-homey-page/2003-01-26/f-thumb.jpg&fl=original,timestamp,offset,length,warcurl`

4. Load the WARC record via `curl -r <offset>-<offset+length-1> $warcurl`

The WARC record should only be accessible with the given tokens for a limited amount of time. Range verification is pending nla/outbackcdx#80

