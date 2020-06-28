#!/bin/bash
set -eu -o pipefail
set -x

cd() {
    mkdir -p "$1" && command cd "$1"
}

SRC="$(mktemp -d)"
NPROC="$(nproc)"
export PKG_CONFIG_LIBDIR="$INSTALL_DIR"/lib/pkgconfig/:"$PKG_CONFIG_LIBDIR"
export PKG_CONFIG_PATH="$PKG_CONFIG_PATH":"$INSTALL_DIR"/share/pkgconfig/
export ACLOCAL_PATH="$INSTALL_DIR"/share/aclocal
export LD_LIBRARY_PATH="$INSTALL_DIR"/lib

# Setup default unix root folders
mkdir -vp "$INSTALL_DIR"
[ "$INSTALL_DIR" == "/usr/local" ] || cp -rv /usr/local/* "$INSTALL_DIR"

cd "$SRC"/xcb-util-xrm
git clone --recursive https://github.com/Airblader/xcb-util-xrm.git .
git checkout "$XCB_UTIL_XRM_TAG"
./autogen.sh --prefix="$INSTALL_DIR"
make -j "$NPROC" && make install

cd "$SRC"/i3-gaps
git clone -b "$VERSION" https://github.com/Airblader/i3.git .
autoreconf -fi
rm -rf .git  # Using git v1.x, cannot git -C to get version

cd build
../configure --prefix="$INSTALL_DIR"
make -j "$NPROC" && make install

cd "$SRC"/i3-status
git clone --recursive https://github.com/i3/i3status.git .
git checkout "$I3_STATUS_TAG"
make -j "$NPROC" && PREFIX="$INSTALL_DIR" make install

find "$INSTALL_DIR" -type d -empty -ls -delete
chown "$UID" "$INSTALL_DIR"/bin/*  # Fixes docker cp issues
