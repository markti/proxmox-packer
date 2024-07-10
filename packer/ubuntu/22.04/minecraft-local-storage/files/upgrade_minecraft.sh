now=`date +"%Y-%m-%d"`

DOWNLOAD_URL=$(curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -s -L -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)" https://minecraft.net/en-us/download/server/bedrock/ |  grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*')

CURRENT_VERSION=$(echo "$DOWNLOAD_URL" | grep -oP 'bin-linux/\K[^/]+')
VERSION_FILE="current_version.txt"
TEMP_DIR=$(mktemp -d)
SERVER_DIR=/home/mcserver/minecraft_bedrock

if [ -f "$VERSION_FILE" ]; then
  LAST_VERSION=$(cat "$VERSION_FILE")
else
  LAST_VERSION=""
fi

if [ "$CURRENT_VERSION" != "$LAST_VERSION" ]; then
  
  echo "New version available: $CURRENT_VERSION. Downloading and installing..."

  sudo wget $DOWNLOAD_URL -O bedrock-server.zip

  # stop minecraft server
  sudo systemctl stop mcbedrock

  sudo cp "$SERVER_DIR/server.properties" "$TEMP_DIR"
  sudo cp "$SERVER_DIR/allowlist.json" "$TEMP_DIR"
  sudo cp "$SERVER_DIR/permissions.json" "$TEMP_DIR"

  sudo unzip -oq ./bedrock-server.zip -d "$SERVER_DIR"

  sudo mv "$TEMP_DIR/server.properties" "$SERVER_DIR/server.properties"
  sudo mv "$TEMP_DIR/allowlist.json" "$SERVER_DIR/allowlist.json"
  sudo mv "$TEMP_DIR/permissions.json" "$SERVER_DIR/permissions.json"

  sudo chown -R mcserver: /home/mcserver

  sudo systemctl start mcbedrock

  echo "$CURRENT_VERSION" > "$VERSION_FILE"

  echo "Minecraft server updated to version $CURRENT_VERSION."

else
  echo "Minecraft server is already up to date (version $CURRENT_VERSION)."
fi