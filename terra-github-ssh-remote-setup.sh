#!/bin/bash

user_email=""
user_name=""
repo_name= ""
repo_url="git@github.com:$user_name/$repo_name.git"

cd /home/rstudio

ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "$user_email" -N ""

eval "$(ssh-agent -s)"

cat <<EOL >> ~/.ssh/config
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
EOL

ssh-add ~/.ssh/id_ed25519

echo "printing SSH public for you to copy and add to your GitHub SSH keys"
cat ~/.ssh/id_ed25519.pub

while true; do
    read -p "Have you added your public key to your GitHub SSH keys? (yes/no): " answer
    case $answer in
        [Yy]* ) 
            echo "Great! Proceeding with the script."
            break
            ;;
        [Nn]* ) 
            echo "Please add your SSH public key to GitHub before proceeding."
            echo "You can find the public key above."
            exit 1
            ;;
        * ) 
            echo "Please answer yes or no."
            ;;
    esac
done

# Continue with the rest of your script
echo "Continuing with the rest of the script..."

git config --global user.email "$user_email"
git config --global user.name  "$user_name"

git clone "$repo_url"

git remote -v