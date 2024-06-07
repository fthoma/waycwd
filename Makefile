VERSION = $(shell git describe --tags --match "v?*.*.*" --always | awk -F '[-]' '{sub(/^v/, ""); split($$1, ver, "."); ver[3]++; print ($$2)? ver[1]"."ver[2]"."ver[3]"-dev"$$2"+"substr($$3, 2) : ($$1~/\./) ? $$1 : "0.1.0-dev+"$$1}')

.PHONY: build test release clean

build:
	zig build -Dversion=$(VERSION)

test:
	zig build test

release:
	zig build --release=small -Dversion=$(VERSION)

clean:
	rm -rf zig-cache zig-out
