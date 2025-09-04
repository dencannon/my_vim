#!/usr/bin/env bash
set -e

echo "==> Detecting OS..."
OS="$(uname -s)"

install_vim_plug() {
  if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "==> Installing vim-plug..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  else
    echo "==> vim-plug already installed."
  fi
}

install_mac() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Please install Homebrew from https://brew.sh and re-run."
    exit 1
  fi
  echo "==> Installing dependencies via Homebrew..."
  brew install ripgrep fzf
  # Optional but recommended for ctags jumps
  if ! brew list --versions universal-ctags >/dev/null 2>&1; then
    brew install --HEAD universal-ctags/universal-ctags/universal-ctags || true
  fi
  # fzf extra key-bindings (optional)
  if [ -x "$(brew --prefix)/opt/fzf/install" ]; then
    yes | "$(brew --prefix)/opt/fzf/install" || true
  fi
}

install_linux() {
  echo "==> Installing dependencies via apt (requires sudo)..."
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y ripgrep fzf curl
    # universal-ctags package name may vary; try to install if available
    if apt-cache show universal-ctags >/dev/null 2>&1; then
      sudo apt-get install -y universal-ctags || true
    else
      echo "universal-ctags package not found in apt. Skipping."
    fi
  else
    echo "APT not found. Please install ripgrep/fzf manually via your distro's package manager."
  fi
}

echo "==> Installing prerequisites (ripgrep, fzf)..."
case "$OS" in
  Darwin) install_mac ;;
  Linux)  install_linux ;;
  *)      echo "Unsupported OS: $OS. Please install ripgrep and fzf manually." ;;
esac

install_vim_plug

# Place .vimrc if not exists or overwrite with backup
TARGET="$HOME/.vimrc"
if [ -f "$TARGET" ]; then
  cp "$TARGET" "$TARGET.bak.$(date +%Y%m%d%H%M%S)"
  echo "==> Backed up existing .vimrc to $TARGET.bak.*"
fi

# Copy provided .vimrc from current dir if present; otherwise, create minimal one
if [ -f "./.vimrc" ]; then
  cp "./.vimrc" "$TARGET"
  echo "==> Installed .vimrc to $TARGET"
else
  echo "==> No local .vimrc file found in current directory."
  exit 1
fi

echo "==> Running PlugInstall..."
# Run PlugInstall non-interactively
vim +':silent! PlugInstall --sync' +':qall' || true

echo "==> Done. Open Vim and try:"
echo "   - <Space>ff to find files"
echo "   - <Space>fg to grep across files (ripgrep)"
echo "   - Use Ctrl-Shift-C to copy selection/line to system clipboard"
echo "   - GitGutter signs will show changes vs HEAD"
