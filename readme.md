# Ubuntu Setup Guide

## 1. Cursor IDE

Save the below code in a **.sh** file and run that file via terminal.

```sh
#!/bin/bash

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
        sudo apt-get update
        sudo apt-get install -y curl
    fi

    # Download Cursor AppImage
    echo "Downloading Cursor AppImage..."
    sudo curl -L $CURSOR_URL -o $APPIMAGE_PATH
    sudo chmod +x $APPIMAGE_PATH

    # Download Cursor icon
    echo "Downloading Cursor icon..."
    sudo curl -L $ICON_URL -o $ICON_PATH

    # Create a .desktop entry for Cursor
    echo "Creating .desktop entry for Cursor..."
    sudo bash -c "cat > $DESKTOP_ENTRY_PATH" <<EOL

[Desktop Entry]
Name=Cursor AI IDE
Exec=$APPIMAGE_PATH --no-sandbox
Icon=$ICON_PATH
Type=Application
Categories=Development;
EOL

    echo "Cursor AI IDE installation complete. You can find it in your application menu."
else
    echo "Cursor AI IDE is already installed."
fi

}

installCursor
```

## 2. VS Code

Visit [VS Code](https://code.visualstudio.com/download) and download the **.deb** file. Install it with App Center. Try to avoid installing with Snap.

## 3. Git

```sh
sudo apt update &&
sudo apt install git &&
git --version
```

```sh
# git flow
git config --global user.name "tutul"
git config --global user.email "tutulnahid@gmail.com"
git config --list
```

```sh
sudo apt-get install git-flow
```

## 4. Google Chrome

Visit [Chrome](https://www.google.com/intl/en_pk/chrome/) and download the **.deb** file. Install it with App Center.

## 5. Brave

```sh
curl -fsS https://dl.brave.com/install.sh | sh
```

## 6. Skype

```sh
sudo snap install skype
```

## 7. gnome shell extensions

```sh
sudo apt install chrome-gnome-shell
```

## 8. Nodejs with NVM

Visit [here](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-22-04#option-3-installing-node-using-the-node-version-manager) for more.

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

source ~/.bashrc

nvm list-remote

nvm install v20.18.0

nvm list

node -v
npm -v
```

## 9. Yarn

```sh
npm install --global yarn

yarn --version
```

## 10. Redis

Follow [this link](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-22-04).

Or

```sh
# install
sudo apt install redis-server

# check
sudo systemctl status redis
redis-cli
```

## 11. Postgresql & pgAdmin

Follow [this](https://dev.to/johndotowl/postgresql-17-installation-on-ubuntu-2404-5bfi) for Postgresql.

Follow [this](https://www.pgadmin.org/download/pgadmin-4-apt/) for pgAdmin.

## 12. VLC

```sh
sudo snap install vlc
```

## 13. Cascadia Code font

```sh
sudo apt-get install "fonts-cascadia-code"
```

## 14. SSH Key

```sh
ssh-keygen
```

## 15. Remove unnecessary apps

```sh
sudo apt remove --purge thunderbird libreoffice* remmina -y
sudo apt autoremove -y && sudo apt clean
```

## 16. Edge Browser

Go to [Edge](https://www.microsoft.com/en-us/edge/business/download?form=MA13FJ), download the .deb file and run it with App Center.


## 17. Set Monday as the first day of the week

1. Open `sudo nano /usr/share/i18n/locales/en_US` for editing.
2. Add the line `first_weekday 2` right before the line `END LC_TIME` and Save.
3. Generate the modified locale: `sudo locale-gen en_US.UTF-8`
4. Run `sudo update-locale LC_TIME=en_US.UTF-8`
5. Reboot