#!/bin/sh
set -eu
bin=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)/bin/normalmapai-url-tools
out=$("$bin" map height)
[ "$out" = "https://normalmapai.com/height-map-generator" ]
out=$("$bin" canonical /height-map-generator/)
[ "$out" = "https://normalmapai.com/height-map-generator" ]
out=$("$bin" canonical "https://normalmapai.com/app?ref=1#editor")
[ "$out" = "https://normalmapai.com/app" ]
out=$("$bin" canonical "http://normalmapai.com//guides/directx-vs-opengl-normal-maps/")
[ "$out" = "https://normalmapai.com/guides/directx-vs-opengl-normal-maps" ]
out=$("$bin" canonical "https://NORMALMAPAI.com/Pricing")
[ "$out" = "https://normalmapai.com/pricing" ]
out=$("$bin" guide directx-vs-opengl-normal-maps)
[ "$out" = "https://normalmapai.com/guides/directx-vs-opengl-normal-maps" ]
out=$("$bin" page pricing)
[ "$out" = "https://normalmapai.com/pricing" ]
out=$("$bin" home)
[ "$out" = "https://normalmapai.com/" ]
if "$bin" canonical /../app >/dev/null 2>&1; then
  echo "traversal should fail" >&2
  exit 1
fi
if "$bin" canonical "https://evil.example/app" >/dev/null 2>&1; then
  echo "foreign host should fail" >&2
  exit 1
fi
if "$bin" map unknown >/dev/null 2>&1; then
  echo "unknown map should fail" >&2
  exit 1
fi
echo ok
