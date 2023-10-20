#bin!/bin/bash
source "`dirname \"$0\"`"/../utils.sh

sudo apt install -y git xclip

# Source: https://docs.gitlab.com/ee/ssh/

warn "Insert your email address:"
read USER_EMAIL
warn "Press enter 3 times to set default options"
ssh-keygen -t rsa -b 2048 -C $USER_EMAIL

xclip -sel clip < ~/.ssh/id_rsa.pub

echo "Your id_rsa.pub key has been copied, go to: https://gitlab.iit.it/-/profile/keys and paste it"
