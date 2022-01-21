# Live Edge Query

Use this package to calculate the latency of a media playlist from the packager given the following assumptions:
  1. The playlist contains at least one `EXT-X-PROGRAM-DATE-TIME` tag.
  2. The value of `EXT-X-PROGRAM-DATE-TIME` defines the time at which the segment was added to the playlist by the packager.

The usage is as follows:
```
USAGE: live-edge-query <uri> [--write-last-segment]

ARGUMENTS:
  <uri>                   The URI of the live playlist

OPTIONS:
  --write-last-segment    Download the last segment and save to local file
  -h, --help              Show help information.
```

Example:
```
% swift run live-edge-query "https://example.com/path/01.m3u8"

[0/0] Build complete!
===
Last segment: 2022-01-21 01:26:23 +0000
Now:          2022-01-21 01:26:44 +0000
===
Packager latency: 21.24189603328705
===
```
```
% swift run live-edge-query "https://example.com/path/01.m3u8" --write-last-segment

[0/0] Build complete!
===
Info: Last segment written to file file:///Users/me/path-to-repo/downloaded-segments/2022.01.21T10-20-13.001+0000.mp4.
===
Last segment: 2022-01-21 10:19:51 +0000
Now:          2022-01-21 10:20:13 +0000
===
Packager latency: 21.685057997703552
===
```

Alternatively, if the release binary has been compiled, then you can run the executable in the build directory.
```
% swift build -c release
% .build/release/live-edge-query "https://example.com/path/01.m3u8"

===
Last segment: 2022-01-21 01:47:51 +0000
Now:          2022-01-21 01:48:12 +0000
===
Packager latency: 21.111752033233643
===
```
