#!/bin/bash

function ask() {
  printf "$* (Y/n)"
  local answer
  read answer

  case $answer in
    [yN] | [yN]es | "YES" ) return 0 ;;
    * ) return 1 ;;
  esac
}

if [ ! -e '~/github' ]; then
  mkdir ~/github
fi

if [ ! $(which brew) ]; then
  if ask "Hombrew install?"; then
    if [ `uname` = "Linux" ]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
      test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
      test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
      echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.bashrc
      exec $SHELL -l
    else
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    
    brew update
  fi
fi

if [ $(which brew) ]; then
  if ask "Homebrew packages install?"; then
    brew install $(cat brew/package-list.txt)
    # rictyフォントインストール
    brew tap sanemat/font
    brew install sanemat/font/ricty
  fi
fi

if [ ! -f "~/.zplug/init.zsh" ]; then
  if ask "zplug isntall?"; then
    if [ `uname` = "Linux" ]; then
      brew install zplug
    else
      curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    fi
  fi
fi

# VSCode
if [ -e ~/Library/Application\ Support/Code/User ]; then
  cd ~/Library/Application\ Support/Code/User

  ln -sf ~/github/dotfiles/vscode/settings.json

  for ext in `cat ~/github/dotfiles/vscode/extensions.txt`; do
    code --install-extension $ext
  done

  cd
fi

if [ ! -e '~/.config/nvim' ]; then
  mkdir -p ~/.config/nvim
fi

ln -sf ~/github/dotfiles/zsh/.zshrc ~/.zshrc
ln -sf ~/github/dotfiles/nvim/init.vim ~/.config/nvim/init.vim
ln -sf ~/github/dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/github/dotfiles/git/.gitignore_global ~/.gitignore_global
