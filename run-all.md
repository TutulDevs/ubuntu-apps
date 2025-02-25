# Run All Apps

## Helped via ChatGPT

```bash
#!/bin/bash

# Update package list
sudo apt update && sudo apt upgrade -y

# Function to install Cursor IDE
installCursor() {
    if ! [ -f /opt/cursor.appimage ]; then
        echo "Installing Cursor AI IDE..."

        # URLs for Cursor AppImage and Icon
        CURSOR_URL="https://downloader.cursor.sh/linux/appImage/x64"
        ICON_URL="https://raw.githubusercontent.com/rahuljangirwork/copmany-logos/refs/heads/main/cursor.png"

        # Paths for installation
        APPIMAGE_PATH="/opt/cursor.appimage"
        ICON_PATH="/opt/cursor.png"
        DESKTOP_ENTRY_PATH="/usr/share/applications/cursor.desktop"

        # Install curl if not installed
        if ! command -v curl &> /dev/null; then
            echo "curl is not installed. Installing..."
            sudo apt install -y curl
        fi

        # Download Cursor AppImage and Icon
        sudo curl -L $CURSOR_URL -o $APPIMAGE_PATH
        sudo chmod +x $APPIMAGE_PATH
        sudo curl -L $ICON_URL -o $ICON_PATH

        # Create a .desktop entry
        echo "[Desktop Entry]
        Name=Cursor AI IDE
        Exec=$APPIMAGE_PATH --no-sandbox
        Icon=$ICON_PATH
        Type=Application
        Categories=Development;" | sudo tee $DESKTOP_ENTRY_PATH > /dev/null
    else
        echo "Cursor AI IDE is already installed."
    fi
}

# Install Git and configure
installGit() {
    sudo apt install -y git git-flow
    git config --global user.name "tutul"
    git config --global user.email "tutulnahid@gmail.com"
    git --version
    git config --list
}

# Install VS Code
installVSCode() {
    echo "Installing VS Code..."
    wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    sudo dpkg -i vscode.deb
    sudo apt-get install -f -y
    rm vscode.deb
}

# Install Google Chrome
installChrome() {
    echo "Installing Google Chrome..."
    wget -O chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    sudo dpkg -i chrome.deb
    sudo apt-get install -f -y
    rm chrome.deb
}

# Install Brave Browser
installBrave() {
    curl -fsS https://dl.brave.com/install.sh | sh
}

# Install Skype
installSkype() {
    sudo snap install skype
}

# Install GNOME Shell Extensions
installGNOMEExtensions() {
    sudo apt install -y chrome-gnome-shell
}

# Install Node.js using NVM
installNode() {
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    source ~/.bashrc
    nvm install v20.18.0
    nvm list
    node -v
    npm -v
}

# Install Yarn
installYarn() {
    npm install --global yarn
    yarn --version
}

# Install VLC
installVLC() {
    sudo snap install vlc
}

# Install Cascadia Code Font
installFont() {
    sudo apt-get install -y fonts-cascadia-code
}

# Generate SSH Key
generateSSHKey() {
    ssh-keygen
}

# Run installation functions
installCursor
installGit
installVSCode
installChrome
installBrave
installSkype
installGNOMEExtensions
installNode
installYarn
installVLC
installFont
generateSSHKey

echo "Installation process completed!"

```