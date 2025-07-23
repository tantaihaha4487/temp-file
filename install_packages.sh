
#!/bin/bash

# ASCII Art
echo "
 ▄▄       ▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄
▐░░▌     ▐░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
▐░▌░▌   ▐░▐░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀ ▐░▌       ▐░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌
▐░▌▐░▌ ▐░▌▐░▌▐░▌       ▐░▌▐░▌          ▐░▌       ▐░▌     ▐░▌     ▐░▌       ▐░▌▐░▌       ▐░▌
▐░▌ ▐░▐░▌ ▐░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌
▐░▌  ▐░▌  ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌
▐░▌   ▀   ▐░▌▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀█░█▀▀ ▐░▌       ▐░▌
▐░▌       ▐░▌▐░▌       ▐░▌          ▐░▌▐░▌       ▐░▌     ▐░▌     ▐░▌     ▐░▌  ▐░▌       ▐░▌
▐░▌       ▐░▌▐░▌       ▐░▌ ▄▄▄▄▄▄▄▄▄█░▌▐░▌       ▐░▌ ▄▄▄▄█░█▄▄▄▄ ▐░▌      ▐░▌ ▐░█▄▄▄▄▄▄▄█░▌
▐░▌       ▐░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌
 ▀         ▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀

"
echo "Welcome to the EndeavourOS Package Installer!"
echo "This script will install essential packages and set up services."
echo ""

# Check for yay and install if not found
if ! command -v yay &> /dev/null
then
    echo "yay is not installed. Please install it manually first:"
    echo "  sudo pacman -S --needed git base-devel"
    echo "  git clone https://aur.archlinux.org/yay.git"
    echo "  cd yay"
    echo "  makepkg -si"
    echo "Then run this script again."
    exit 1
fi

# Update system before installing new packages
echo "Updating system..."
pacman -Syu --noconfirm

# Install Pacman/AUR packages
echo "Installing core packages..."
pacman -S --noconfirm jdk21-openjdk nodejs npm htop btop fastfetch flatpak timeshift syncthing tailscale vim neovim intellij-idea-community-edition discord nvidia-lts nvidia-settings nvidia-utils obs-studio ethtool

# Add Flathub remote and install Flatpak applications
echo "Adding Flathub remote and installing Flatpak applications..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub app.zen_browser.zen
flatpak install -y flathub org.prismlauncher.PrismLauncher
flatpak install -y flathub org.kde.kdenlive
flatpak install -y flathub com.rustdesk.RustDesk

# WOL Service Setup
echo "Setting up Wake-on-LAN (WOL) service..."
echo "
[Unit]
Description=Enable Wake-on-LAN for %I
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/ethtool -s %I wol g
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/wol@.service > /dev/null

echo "WOL service file created at /etc/systemd/system/wol@.service"
echo "To enable WOL for your network interface (e.g., 'enp0s3'), run:"
echo "  sudo systemctl enable wol@enp0s3.service"
echo "  sudo systemctl start wol@enp0s3.service"
echo "Replace 'enp0s3' with your actual network interface name (e.g., 'ip a' to find it)."
echo "You may also need to enable WOL in your BIOS/UEFI settings."

# NPM global install - Clarification needed
echo ""
echo "Regarding the npm global install, the path you provided:"
echo "  ~/.config/configstore/update-notifier-@google/gemini-cli.json"
echo "appears to be a configuration file, not an npm package."
echo "Please clarify which npm package you intended to install globally."
echo "Skipping this step for now."

echo ""
echo "Installation and setup complete!"
echo "Remember to reboot if prompted by any package installations, especially for kernel modules like nvidia-lts."
