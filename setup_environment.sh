#!/usr/bin/env bash

# ==============================================================================
# Setup Script for Ubuntu 24.04 LTS
# Installs and configures development tools and utilities.
# ==============================================================================

set -euo pipefail

log_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

# 1. Update system packages
updateSystem() {
    log_info "Updating system package list..."
    sudo apt update -y
}

# 2. Install curl
installCurl() {
    log_info "Installing curl..."
    sudo apt install -y curl
    curl --version
    log_success "curl installed successfully."
}

# 3. Install Git and configure
installGit() {
    log_info "Installing Git & Git Flow..."
    sudo apt install -y git git-flow
    git config --global user.name "tutul"
    git config --global user.email "tutulnahid@gmail.com"
    git --version
    git config --list
    log_success "Git configured successfully."
}

# 4. Install NVM & Node.js (v24.15.0)
installNvmNode() {
    log_info "Installing NVM & Node.js..."
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    fi

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    nvm install 24.15.0
    nvm use 24.15.0
    nvm alias default 24.15.0
    node -v
    npm -v
    log_success "NVM & Node.js installed successfully."
}

# 5. Install PostgreSQL
installPostgres() {
    log_info "Installing PostgreSQL..."
    sudo apt install -y postgresql postgresql-contrib
    sudo systemctl enable postgresql
    sudo systemctl start postgresql
    log_success "PostgreSQL installed and service started."
}

# 6. Install pgAdmin 4 Web
installPgAdminWeb() {
    log_info "Installing pgAdmin 4 (Web)..."
    sudo apt install -y curl gnupg
    curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg --yes
    sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'
    sudo apt update -y
    sudo apt install -y pgadmin4-web
    log_info "pgAdmin 4 installed. Note: Run 'sudo /usr/pgadmin4/bin/setup-web.sh' to finalize web credentials."
    log_success "pgAdmin 4 installation completed."
}

# 7. Install Redis Server
installRedis() {
    log_info "Installing Redis Server..."
    sudo apt install -y redis-server
    sudo sed -i 's/^daemonize no/daemonize yes/' /etc/redis/redis.conf
    sudo sed -i 's/^supervised .*/supervised no/' /etc/redis/redis.conf
    sudo systemctl reset-failed redis-server || true
    sudo systemctl enable redis-server
    sudo systemctl restart redis-server
    log_success "Redis installed and service started."
}

# 8. Install Docker Engine
installDocker() {
    log_info "Installing Docker..."
    sudo apt install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$UBUNTU_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose

    sudo usermod -aG docker "$USER"
    docker compose version
    docker-compose --version
    log_success "Docker installed. User added to 'docker' group."
}

# 9. Install GParted
installGparted() {
    log_info "Installing GParted..."
    sudo apt install -y gparted
    log_success "GParted installed successfully."
}

# 10. Install Claude Code CLI
installClaudeCode() {
    log_info "Installing Claude Code CLI..."
    curl -fsSL https://claude.ai/install.sh | bash
    log_success "Claude Code CLI installed successfully."
}

# 11. Install Claude Desktop (beta on Linux)
installClaudeDesktop() {
    log_info "Installing Claude Desktop..."
    sudo apt install -y curl gnupg
    sudo curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc https://downloads.claude.ai/claude-desktop/key.asc
    echo "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" | \
        sudo tee /etc/apt/sources.list.d/claude-desktop.list > /dev/null
    sudo apt update -y
    sudo apt install -y claude-desktop
    # Cowork runs tasks in a KVM-backed VM and needs kvm group access
    sudo usermod -aG kvm "$USER"
    log_success "Claude Desktop installed. Launch 'Claude' from the app menu and sign in."
}

# 12. Install Command Code CLI
installCommandCodeCli() {
    log_info "Installing Command Code CLI..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm install --global command-code
    log_success "Command Code CLI installed successfully. Run 'cmd' in a project to start."
}

# 13. Install Command Code Desktop (Ubuntu/Debian x64 only)
installCommandCodeDesktop() {
    log_info "Installing Command Code Desktop..."
    curl -fsSL https://raw.githubusercontent.com/CommandCodeAI/desktop/main/install.sh | bash
    log_success "Command Code Desktop installed successfully."
}

# 14. Install OpenCode CLI
installOpencode() {
    log_info "Installing OpenCode CLI..."
    curl -fsSL https://opencode.ai/install | bash
    log_success "OpenCode CLI installed successfully."
}

# 15. Install CPU-X
installCpuX() {
    log_info "Installing CPU-X..."
    sudo apt install -y cpu-x
    log_success "CPU-X installed successfully."
}

# 16. Install Gnumeric
installGnumeric() {
    log_info "Installing Gnumeric..."
    sudo apt install -y gnumeric
    log_success "Gnumeric installed successfully."
}

# 17. Install Cursor AI IDE
installCursor() {
    log_info "Installing Cursor AI IDE..."
    if [ -f /opt/cursor.appimage ]; then
        log_info "Cursor AI IDE is already installed."
        return
    fi

    local cursor_url="https://downloader.cursor.sh/linux/appImage/x64"
    local icon_url="https://raw.githubusercontent.com/rahuljangirwork/copmany-logos/refs/heads/main/cursor.png"
    local appimage_path="/opt/cursor.appimage"
    local icon_path="/opt/cursor.png"
    local desktop_entry_path="/usr/share/applications/cursor.desktop"

    sudo curl -L "$cursor_url" -o "$appimage_path"
    sudo chmod +x "$appimage_path"
    sudo curl -L "$icon_url" -o "$icon_path"

    echo "[Desktop Entry]
Name=Cursor AI IDE
Exec=$appimage_path --no-sandbox
Icon=$icon_path
Type=Application
Categories=Development;" | sudo tee "$desktop_entry_path" > /dev/null

    log_success "Cursor AI IDE installed successfully."
}

# 18. Install VS Code
installVSCode() {
    log_info "Installing VS Code..."
    wget -O /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    sudo dpkg -i /tmp/vscode.deb || sudo apt-get install -f -y
    rm -f /tmp/vscode.deb
    log_success "VS Code installed successfully."
}

# 19. Install Google Chrome
installChrome() {
    log_info "Installing Google Chrome..."
    wget -O /tmp/chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    sudo dpkg -i /tmp/chrome.deb || sudo apt-get install -f -y
    rm -f /tmp/chrome.deb
    log_success "Google Chrome installed successfully."
}

# 20. Install Brave Browser
installBrave() {
    log_info "Installing Brave Browser..."
    curl -fsS https://dl.brave.com/install.sh | sh
    log_success "Brave Browser installed successfully."
}

# 21. Install Microsoft Edge
installMsEdge() {
    log_info "Installing Microsoft Edge..."
    sudo apt install -y curl gnupg
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft-edge.gpg --yes
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
    sudo apt update -y
    sudo apt install -y microsoft-edge-stable
    log_success "Microsoft Edge installed successfully."
}

# 22. Install GNOME Shell Extensions support
installGNOMEExtensions() {
    log_info "Installing GNOME Shell Extensions support..."
    sudo apt install -y chrome-gnome-shell
    log_success "GNOME Shell Extensions support installed successfully."
}

# 23. Install Yarn
installYarn() {
    log_info "Installing Yarn..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm install --global yarn
    yarn --version
    log_success "Yarn installed successfully."
}

# 24. Install pnpm
installPnpm() {
    log_info "Installing pnpm..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    npm install --global pnpm
    pnpm --version
    log_success "pnpm installed successfully."
}

# 25. Install VLC
installVLC() {
    log_info "Installing VLC..."
    sudo apt install -y vlc
    log_success "VLC installed successfully."
}

# 26. Install Cascadia Code Font
installFont() {
    log_info "Installing Cascadia Code font..."
    sudo apt-get install -y fonts-cascadia-code
    log_success "Cascadia Code font installed successfully."
}

# 27. Generate SSH Key
generateSSHKey() {
    log_info "Generating SSH key..."
    if [ -f "$HOME/.ssh/id_ed25519" ]; then
        log_info "SSH key already exists at ~/.ssh/id_ed25519, skipping."
        return
    fi
    ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N "" -C "$(whoami)@$(hostname)"
    log_success "SSH key generated at ~/.ssh/id_ed25519."
}

# 28. Remove unnecessary apps
removeUnnecessaryApps() {
    log_info "Removing unnecessary apps..."
    sudo apt remove --purge -y thunderbird libreoffice* remmina || true
    sudo apt autoremove -y
    sudo apt clean
    log_success "Unnecessary apps removed successfully."
}

# 29. Set Monday as the first day of the week
setMondayFirstWeekday() {
    log_info "Setting Monday as the first day of the week..."
    local locale_file="/usr/share/i18n/locales/en_US"
    if grep -q "^first_weekday 2" "$locale_file" 2>/dev/null; then
        log_info "Monday is already set as the first day of the week."
        return
    fi
    sudo sed -i '/^END LC_TIME/i first_weekday 2' "$locale_file"
    sudo locale-gen en_US.UTF-8
    sudo update-locale LC_TIME=en_US.UTF-8
    log_success "Monday set as the first day of the week. Reboot to apply."
}

# 30. Node.js heap limit fix
setNodeHeapLimit() {
    log_info "Setting Node.js heap limit..."
    local export_line='export NODE_OPTIONS="--max-old-space-size=8192"'
    if ! grep -qF "$export_line" "$HOME/.bashrc" 2>/dev/null; then
        echo "$export_line" >> "$HOME/.bashrc"
    fi
    export NODE_OPTIONS="--max-old-space-size=8192"
    log_success "Node.js heap limit set to 8192MB (added to ~/.bashrc)."
}

# Master execution function
main() {
    log_info "Starting environment setup..."
    
    updateSystem
    installCurl
    installGit
    installNvmNode
    installPostgres
    installPgAdminWeb
    installRedis
    installDocker
    installGparted
    installClaudeCode
    installClaudeDesktop
    # installCommandCodeCli
    # installCommandCodeDesktop
    # installOpencode
    installCpuX
    installGnumeric
    # installCursor
    installVSCode
    installChrome
    installBrave
    installMsEdge
    installGNOMEExtensions
    installYarn
    installPnpm
    installVLC
    installFont
    generateSSHKey
    removeUnnecessaryApps
    setMondayFirstWeekday
    setNodeHeapLimit

    log_success "All software and tools installed successfully!"
    log_info "Please log out and log back in for Docker group permissions to take effect."
}

main