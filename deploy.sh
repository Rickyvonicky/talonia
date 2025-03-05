#!/bin/bash
set -e  # Exit on error

# Project Metadata (Modify these)
APP_NAME=$(basename "$PWD")  # Use project directory name
VERSION="1.0.0"
ARCH="amd64"
MAINTAINER="Your Name <you@example.com>"
DESCRIPTION="A Rust-based application."

# Build Paths
BUILD_DIR="deploy"
PKG_DIR="${BUILD_DIR}/${APP_NAME}_${VERSION}_${ARCH}"
BIN_DIR="${PKG_DIR}/usr/bin"
CONF_DIR="${PKG_DIR}/etc/${APP_NAME}"
DEBIAN_DIR="${PKG_DIR}/DEBIAN"

echo "🔨 Building Rust project..."
cargo build --release
#upx "$BIN_DIR/${APP_NAME}"

echo "📁 Creating package structure..."
rm -rf "$BUILD_DIR"
mkdir -p "$BIN_DIR" "$CONF_DIR" "$DEBIAN_DIR"

echo "🚀 Copying files..."
cp "target/release/${APP_NAME}" "$BIN_DIR/${APP_NAME}"


echo "Making man pages..."

# Loop through all man section files in the 'man/' directory
for manpage in man/*.[1-9]; do
    # Extract section number (last character after the dot)
    section="${manpage##*.}"

    # Create the corresponding directory inside the package
    mkdir -p "${PKG_DIR}/usr/share/man/man${section}"

    # Copy the man page to the correct section directory
    cp "$manpage" "${PKG_DIR}/usr/share/man/man${section}/"

    # Compress the man page
    gzip -f "${PKG_DIR}/usr/share/man/man${section}/$(basename "$manpage")"

    echo "Installed $(basename "$manpage") into man${section}/"
done

echo "Man pages installation complete."

echo "Copying application data..."
mkdir -p "${PKG_DIR}/usr/share/${APP_NAME}"
cp -r data/* "${PKG_DIR}/usr/share/${APP_NAME}/"

#cp "config/default.toml" "$CONF_DIR/config.toml"  # Example config file

# Create DEBIAN control file
cat <<EOF > "${DEBIAN_DIR}/control"
Package: $APP_NAME
Version: $VERSION
Architecture: $ARCH
Maintainer: $MAINTAINER
Description: $DESCRIPTION
Depends: libc6 (>= 2.28),man-db
Priority: optional
Section: utils
EOF

echo "compressing exe"
upx "$BIN_DIR/${APP_NAME}"


echo "📦 Building .deb package..."
dpkg-deb --build "$PKG_DIR"

echo "✅ Package created: ${BUILD_DIR}/${APP_NAME}_${VERSION}_${ARCH}.deb"
echo "📥 Install with: sudo dpkg -i ${BUILD_DIR}/${APP_NAME}_${VERSION}_${ARCH}.deb"

echo "putting deb on desktop:"
#echo $PWD
#echo $HOME
#whoami
mv "./deploy/${APP_NAME}_${VERSION}_${ARCH}.deb" "${HOME}/Desktop/${APP_NAME}_${VERSION}_${ARCH}.deb"

