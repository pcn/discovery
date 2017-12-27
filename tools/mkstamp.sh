#!/bin/sh
echo BUILD_DATE $(TZ=Etc/UTC date -Iseconds)
# Use describe, if possible, to get most recent tag and offset instead
# of having to construct that kind of info from pieces
echo BUILD_SCM_HASH $(git rev-parse HEAD)
echo BUILD_SCM_VERSION $(git describe)-$USER
echo BUILD_BAZEL_ROOT $PWD
echo BUILD_IP_ADDR $(hostname -I | cut -d' ' -f1)
