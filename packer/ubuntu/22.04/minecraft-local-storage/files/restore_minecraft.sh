setfacl -R -m u:ubuntu:rX /home/mcserver/minecraft_bedrock

TARBALL="$1"
TARGET_DIR="/home/mcserver/minecraft_bedrock/worlds"

rm -rf "$TARGET_DIR"/*

TEMP_DIR=$(mktemp -d)

tar -xzf "$TARBALL" -C "$TEMP_DIR"

cp -r "$TEMP_DIR/worlds"/* "$TARGET_DIR"

rm -rf "$TEMP_DIR"