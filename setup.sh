#!/bin/bash

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install zsh, git, and curl
echo "Installing zsh, git, and curl..."
sudo apt install -y zsh git curl

# Install Docker
echo "Installing Docker..."
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "Adding Docker repository to Apt sources..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "Installing Docker packages..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install cloudflared
echo "Installing cloudflared..."
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/cloudflared.list
sudo apt-get update
sudo apt-get install -y cloudflared

# Install Node Version Manager (NVM)
echo "Installing Node Version Manager (NVM)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Install Starship
echo "Installing Starship..."
curl -sS https://starship.rs/install.sh | sh

# Add Starship config
echo "Configuring Starship..."
mkdir -p ~/.config
curl -fsSL https://raw.githubusercontent.com/Dolliwyx/dotfiles/master/starship.toml -o ~/.config/starship.toml

# Setup Git info
echo "Configuring Git..."
git config --global user.name "Dolliwyx"
git config --global user.email "35372554+Dolliwyx@users.noreply.github.com"
git config --global commit.gpgsign true

# Install oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Download zsh-syntax-highlighting
echo "Downloading zsh-syntax-highlighting plugin..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Download zsh-autosuggestions
echo "Downloading zsh-autosuggestions plugin..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Add zsh config to .zshrc
echo "Adding zsh configuration..."
curl -fsSL https://github.com/Dolliwyx/dotfiles/raw/master/.zshrc -o ~/.zshrc

# Change shell to zsh
echo "Changing shell to zsh..."
chsh -s $(which zsh)

echo "Setup completed successfully."

exec zsh
