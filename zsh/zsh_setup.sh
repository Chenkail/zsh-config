#! /bin/zsh

# Home directory
cd ~

# Prereqs
sudo apt install curl

# Repository folder for zsh config files
DOTFILES='https://raw.githubusercontent.com/circumspect/dotfiles/main/zsh'

# Install prezto
if [ ! -d ".zprezto" ]; then
  echo "Installing prezto:"
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
  setopt EXTENDED_GLOB
  for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
    ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
  done
  echo
fi

# zplug
if [ ! -d ".zplug" ]; then
  echo "Installing zplug:"
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# Config files
echo "Copying config files:"
curl ${DOTFILES}/.zpretzorc > zpretzorc.new
curl ${DOTFILES}/.zshrc > zshrc.new

mv zpretzorc.new "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zpretzorc
mv zshrc.new "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/zshrc
echo

# Set up thefuck
sudo apt update
sudo apt install python3-dev python3-pip python3-setuptools
sudo pip3 install thefuck

if read -q '?Configure thefuck? (y/n) '
then
  echo
  fuck
  fuck
else
  echo
fi

# # Run p10k setup - DOESN'T WORK BECAUSE ZSH NEEDS TO RESTART
# if read -q '?Configure p10k? (y/n) '
# then
#   echo
#   p10k configure
# else
#   echo
# fi

# Reload zsh to save changes
echo "Reloading zsh!"
exec zsh
