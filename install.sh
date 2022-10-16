#!/bin/sh

export INSTALL_ZSH=true

## update and install required packages
sudo apt-get update
sudo apt-get -y install --no-install-recommends apt-utils dialog 2>&1
sudo apt-get install -y \
  curl \
  git \
  gnupg2 \
  jq \
  sudo \
  openssh-client \
  less \
  iproute2 \
  procps \
  wget \
  unzip \
  apt-transport-https \
  lsb-release \
  powerline \
  fonts-powerline

zshrc() {
    echo "==========================================================="
    echo "             cloning zsh-autosuggestions                   "
    echo "-----------------------------------------------------------"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo "==========================================================="
    echo "             cloning zsh-syntax-highlighting               "
    echo "-----------------------------------------------------------"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "==========================================================="
    echo "             import zshrc                                  "
    echo "-----------------------------------------------------------"
    cat .zshrc > $HOME/.zshrc
}

# change time zone
sudo ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Install & Configure Zsh
if [ "$INSTALL_ZSH" = "true" ]
then
    zshrc

    # change shell to zsh by default
    if [ "$CODESPACES" = "true" ]
    then
      echo 'chsh'
      FILE=/etc/pam.d/chsh
      if test -f "$FILE"; then
        sudo sed -i 's/auth       required   pam_shells.so/auth       sufficient   pam_shells.so/'  /etc/pam.d/chsh
        chsh -s $(which zsh)
        sudo sed -i 's/auth       sufficient   pam_shells.so/auth       required   pam_shells.so/'  /etc/pam.d/chsh    
      else 
        sudo bash -c "echo 'auth       sufficient   pam_shells.so' > /etc/pam.d/chsh"
      fi
    fi
fi

# make directly highlighting readable - needs to be after zshrc line
echo "" >> ~/.zshrc
echo "# remove ls and directory completion highlight color" >> ~/.zshrc
echo "_ls_colors=':ow=01;33'" >> ~/.zshrc
echo 'zstyle ":completion:*:default" list-colors "${(s.:.)_ls_colors}"' >> ~/.zshrc
echo 'LS_COLORS+=$_ls_colors' >> ~/.zshrc