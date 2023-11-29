#! /bin/zsh

set -eo pipefail

swift build -c release
cp ./.build/release/xcr2c /opt/homebrew/bin/xcr2c
