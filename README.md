# Live Edge Query

Use this package to calculate the latency of a media playlist from the packager given the following assumptions:
  1. The playlist contains at least one `EXT-X-PROGRAM-DATE-TIME` tag.
  2. The value of `EXT-X-PROGRAM-DATE-TIME` defines the time at which the segment was added to the playlist by the packager.

The usage is as follows:
```
USAGE: swift run live-edge-query <uri>

ARGUMENTS:
  <uri>                   The URI of the live playlist

OPTIONS:
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
