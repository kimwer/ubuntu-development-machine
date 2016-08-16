#!/bin/sh
#http://stackoverflow.com/questions/30130934/how-to-install-intellij-idea-on-ubuntu

echo "[INFO ]Install IntelliJ IDEA"

# We need root to install
# propably not...
#[ $(id -u) != "0" ] && exec sudo "$0" "$@"

# Fetch the most recent version
VERSION=$(wget "https://www.jetbrains.com/intellij-repository/releases" -qO- | grep -P -o -m 1 "(?<=https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/idea/BUILD/)[^/]+(?=/)")

# Prepend base URL for download
URL="https://download.jetbrains.com/idea/ideaIU-$VERSION.tar.gz"
https://download.jetbrains.com/idea/ideaIU-162.1628.17.tar.gz
echo $URL

# Truncate filename
FILE=$(basename ${URL})

# Set download directory
DEST=/home/vagrant/$FILE

echo "Downloading idea-IU-$VERSION to $DEST..."

# Download binary
wget -cqO ${DEST} ${URL} --read-timeout=5 --tries=0

echo "[INFO] Download complete!"

# Set directory name
DIR="/opt/idea-IU-$VERSION"

echo "Installing to $DIR"

# Untar file
if mkdir ${DIR}; then
    sudo tar -xzf ${DEST} -C ${DIR} --strip-components=1
fi

# Grab executable folder
BIN="$DIR/bin"

# Add permissions to install directory
sudo chmod -R +rwx ${DIR}

# Set desktop shortcut path
DESK=/usr/share/applications/IDEA.desktop

# Add desktop shortcut
echo "[Desktop Entry]\nEncoding=UTF-8\nName=IntelliJ IDEA\nComment=IntelliJ IDEA\nExec=${BIN}/idea.sh\nIcon=${BIN}/idea.png\nTerminal=false\nStartupNotify=true\nType=Application" -e > ${DESK}

# Create symlink entry
sudo ln -s ${BIN}/idea.sh /usr/local/bin/idea

echo "[INFO] IntelliJ install complete."  