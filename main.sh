#!/usr/bin/env bash

updateSystem() {
    echo "Updating system..."
    sudo dnf update -y
}

installPackages() {
    echo "Installing packages..."

    # --- Install HashiCorp repo if needed (for Terraform) ---
    if ! command -v terraform &>/dev/null; then
        echo "Adding HashiCorp repository..."
        sudo dnf install -y dnf-plugins-core
        wget -O- https://rpm.releases.hashicorp.com/fedora/hashicorp.repo | sudo tee /etc/yum.repos.d/hashicorp.repo
    else
        echo "Terraform is already installed."
    fi

    # --- Install packages ---
    packageList=(
        alacritty
        fastfetch
        flatpak
        fzf
        git
        gnome-tweaks
        golang
        jetbrains-mono-fonts
        libwebp-tools
        lua
        make
        neovim
        nodejs
        pandoc
        pipx
        podman
        ripgrep
        solaar
        sqlite
        terraform
        tmux
        ulauncher
        unzip
        webkit2gtk3
        zip
    )

    for package in "${packageList[@]}"; do
        if ! rpm -q "$package" &>/dev/null; then
            echo "Installing $package..."
            sudo dnf install -y "$package"
        else
            echo "$package is already installed."
        fi
    done

    # --- Install starship ---
    if command -v starship &>/dev/null; then
        echo "Starship is already installed."
    else
        echo "Installing starship..."
        curl -sS https://starship.rs/install.sh | sh
    fi

    # --- Install AWS CLI ---
    echo "Installing AWS CLI..."
    if ! command -v aws &>/dev/null; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install
        rm awscliv2.zip
        rm -rf aws
    else
        echo "AWS CLI is already installed."
    fi

    # --- Install pre-commit ---
    echo "Installing pre-commit..."
    if ! command -v pre-commit &>/dev/null; then
        pipx install pre-commit
    else
        echo "pre-commit is already installed."
    fi
}

installNpmPackages() {
    echo "Installing npm packages..."
    npmPackages=(
        sass
        @github/copilot
    )

    for package in "${npmPackages[@]}"; do
        if ! npm list -g --depth=0 | grep -q "$package"; then
            echo "Installing $package..."
            sudo npm install -g "$package"
        else
            echo "$package is already installed."
        fi
    done
}

installFlatpakApps() {
    echo "Installing Flatpak apps..."

    if ! flatpak remotes | grep -q flathub; then
        echo "Adding Flathub remote..."
        sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    flatpakApps=(
        com.google.Chrome
        com.valvesoftware.Steam
        org.mozilla.Thunderbird
    )

    for app in "${flatpakApps[@]}"; do
        if ! flatpak list | grep -q "$app"; then
            echo "Installing $app..."
            flatpak install -y flathub "$app"
        else
            echo "$app is already installed."
        fi
    done
}

gnomeShellExtensions() {
    echo "Installing GNOME Shell extensions..."

    if pipx list | grep -q gnome-extensions-cli; then
        echo "gnome-extensions-cli is already installed."
    else
        echo "Installing gnome-extensions-cli..."
        pipx install gnome-extensions-cli --system-site-packages
    fi

    gnomeExtensions=(
        "just-perfection-desktop@just-perfection"
        "space-bar@luchrioh"
        "useless-gaps@pimsnel.com"
        "blur-my-shell@aunetx"
        "rounded-window-corners@fxgn"
    )

    for extension in "${gnomeExtensions[@]}"; do
        if gext list | grep -q "$extension"; then
            echo "Extension $extension is already installed."
        else
            echo "Installing extension $extension..."
            gext install "$extension"
        fi
    done

    dconf load /org/gnome/shell/extensions/ < gnome/gnomeSettings.dconf
}

gnomeSettings() {
    echo "Applying GNOME settings..."
    
    # --- Workspace Settings ---
    echo "Setting up workspaces..."
    gsettings set org.gnome.mutter dynamic-workspaces false
    gsettings set org.gnome.desktop.wm.preferences num-workspaces 4

    for i in {1..4}; do
        gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-$i "['<Shift><Super>$i']"
        gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-$i "['<Super>$i']"
    done

    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control>Left']"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control>Right']"

    # --- Disable Default Application Shortcuts ---
    echo "Disabling default application shortcuts..."
    for i in {1..9}; do
        gsettings set org.gnome.shell.keybindings switch-to-application-$i "[]"
    done

    # --- Window Management and Screenshots---
    echo "Setting window management shortcuts..."
    gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"
    gsettings set org.gnome.shell.keybindings screenshot "['<Super>s']"
    gsettings set org.gnome.desktop.input-sources xkb-options "['caps:ctrl_modifier']"


    # --- Appearance Settings ---
    echo "Setting appearance..."
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

    gsettings set org.gnome.desktop.interface clock-show-date false

    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://${SCRIPT_DIR}/gnome/wallpaper.png"

    # --- Ensure that useless-gaps extension works properly ---
    gsettings set org.gnome.mutter auto-maximize "false"

    # --- Ulauncher Custom Shortcut ---
    echo "Setting up Ulauncher custom shortcut..."

    # Register one custom shortcut (custom0)
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
        "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"

    # Configure the shortcut
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Ulauncher Toggle'"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'ulauncher-toggle'"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'<Super>space'"

    echo "GNOME settings applied successfully."
}

setDotfiles() {
    echo "Setting up dotfiles..."

    # --- Add aliases to bashrc ---
    if ! grep -Fq '. ~/.config/aliases/aliases' ~/.bashrc; then
        {
            echo '# --- Add aliases to bashrc ---'
            echo 'if [ -f ~/.config/aliases/aliases ]; then'
            echo '    . ~/.config/aliases/aliases'
            echo 'fi'
        } >> ~/.bashrc
        echo "Added aliases block to ~/.bashrc"
    else
        echo "Aliases block already exists in ~/.bashrc"
    fi

    # --- Create required directories ---
    mkdir -p ~/.config/{aliases,alacritty,nvim,tmux}

    # --- List of dotfiles to purge ---
    dotfilesToRemove=(
        ~/.config/alacritty/alacritty.toml
        ~/.config/aliases/aliases
        ~/.config/autostart
        ~/.config/nvim/init.vim
        ~/.config/nvim/lua
        ~/.config/starship.toml
        ~/.config/tmux/tmux.conf
        ~/.config/ulauncher
    )

    echo "Purging existing dotfiles..."
    for file in "${dotfilesToRemove[@]}"; do
        rm -rf "$file"
    done

    # --- Copy new dotfiles ---
    echo "Copying new dotfiles..."
    cp -r ./dotfiles/config/autostart/ ~/.config/
    cp -r ./dotfiles/config/nvim/ ~/.config/
    cp -r ./dotfiles/config/ulauncher/ ~/.config/
    cp ./dotfiles/config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
    cp ./dotfiles/config/aliases/bash ~/.config/aliases/aliases
    cp ./dotfiles/config/starship/starship.toml ~/.config/starship.toml
    cp ./dotfiles/config/tmux/tmux.conf ~/.config/tmux/tmux.conf

    echo "Dotfiles setup complete."
}

setScripts() {
    echo "Setting up scripts..."

    # --- Create required directories ---
    mkdir -p ~/.local/bin

    # --- List of scripts to purge ---
    scriptsToRemove=(
        ~/.local/bin/tmux-sessioniser
    )

    echo "Purging existing scripts..."
    for script in "${scriptsToRemove[@]}"; do
        rm -rf "$script"
    done

    # --- Copy new scripts ---
    echo "Copying new scripts..."
    cp -r ./dotfiles/config/tmux/tmux-sessioniser ~/.local/bin/tmux-sessioniser
}

configureGit() {
    echo "Configuring git..."

    if git config --global user.name &>/dev/null && git config --global user.email &>/dev/null; then
        echo "Git is already configured."
        return
    else
        read -p "Enter your git email: " email
        read -p "Enter your git name: " username
        git config --global user.name "$username"
        git config --global user.email "$email"
        git config --global core.editor "nvim"
    fi
}

installPlaydateSdk() {
    echo "Installing Playdate SDK..."

    SDK_PATH="$HOME/Developer/PlaydateSDK"
    SHELL_CONFIG="$HOME/.bashrc"

    # Remove existing SDK if it exists
    if [ -d "$SDK_PATH" ]; then
        echo "Existing Playdate SDK found at $SDK_PATH, removing..."
        rm -rf "$SDK_PATH"
    fi

    # Download and extract
    curl -L -o PlaydateSDK-latest.tar.gz https://download.panic.com/playdate_sdk/Linux/PlaydateSDK-latest.tar.gz
    mkdir -p playdate-sdk
    tar -xzf PlaydateSDK-latest.tar.gz --strip-components=1 -C playdate-sdk

    # Move to final destination
    mkdir -p "$(dirname "$SDK_PATH")"
    mv playdate-sdk "$SDK_PATH"

    # Set environment variables in shell config if not already present
    if ! grep -q "export PLAYDATE_SDK_PATH=" "$SHELL_CONFIG"; then
        echo "export PLAYDATE_SDK_PATH=\"$SDK_PATH\"" >> "$SHELL_CONFIG"
        echo "Added PLAYDATE_SDK_PATH to $SHELL_CONFIG"
    else
        echo "PLAYDATE_SDK_PATH already set in $SHELL_CONFIG"
    fi

    if ! grep -q "\$PLAYDATE_SDK_PATH/bin" "$SHELL_CONFIG"; then
        echo 'export PATH="$PATH:$PLAYDATE_SDK_PATH/bin"' >> "$SHELL_CONFIG"
        echo "Added Playdate SDK bin directory to PATH in $SHELL_CONFIG"
    else
        echo "PATH already includes Playdate SDK bin directory"
    fi

    # Clean up
    rm PlaydateSDK-latest.tar.gz

    # Setup playdate sdk
    sudo bash "$SDK_PATH/setup.sh"

    echo "Playdate SDK installed at $SDK_PATH"
}

# --- Main Script Execution ---
clear
cat << "EOF"
========================================
 berryora - Fedora System Crafting Tool
         by: nathan berry
========================================
EOF

# --- Ask for sudo privileges at the start ---
echo "Requesting sudo privileges..."
sudo -v

set -e
echo "Starting installation..."

updateSystem
installPackages
installFlatpakApps
installNpmPackages
gnomeShellExtensions
gnomeSettings
git clone https://github.com/nathanberry97/dotfiles.git
setDotfiles
setScripts
rm -rf ./dotfiles
configureGit
installPlaydateSdk

echo "Setup complete! Please reboot to apply all settings."
