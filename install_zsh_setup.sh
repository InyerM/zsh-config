#!/bin/bash
set -e

echo "🚀 Installing ZSH and custom environment..."

# 1. Install ZSH if missing
if ! command -v zsh &> /dev/null; then
    echo "🔵 Installing ZSH..."
    if [ -f /etc/debian_version ]; then
        sudo apt update && sudo apt install zsh -y
    elif [ -f /etc/redhat-release ]; then
        sudo yum install zsh -y
    else
        echo "Unsupported OS for auto-installing ZSH."
        exit 1
    fi
else
    echo "✅ ZSH already installed."
fi

# 2. Install Oh-My-Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🔵 Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 3. Powerlevel10k theme
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "🔵 Installing Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $HOME/.oh-my-zsh/custom/themes/powerlevel10k
fi

# 4. Plugins
PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $PLUGINS_DIR/zsh-autosuggestions || true
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting $PLUGINS_DIR/zsh-syntax-highlighting || true
git clone --depth=1 https://github.com/Aloxaf/fzf-tab $PLUGINS_DIR/fzf-tab || true

# 5. Copy .zshrc and .p10k.zsh from current folder
if [ -f "./.zshrc" ]; then
    cp ./.zshrc ~/.zshrc
    echo "✅ Copied .zshrc to home directory."
else
    echo "⚠️  .zshrc not found in the current directory!"
fi

if [ -f "./.p10k.zsh" ]; then
    cp ./.p10k.zsh ~/.p10k.zsh
    echo "✅ Copied .p10k.zsh to home directory."
else
    echo "⚠️  .p10k.zsh not found in the current directory!"
fi

# 6. Set ZSH as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🔵 Changing default shell to ZSH..."
    chsh -s $(which zsh)
fi

echo "✅ All done! Start a new SSH session or run 'zsh' now."
