#!/bin/sh
echo "Channel Actions Bot - Installer."
echo "This script will install the bot and all its dependencies, and use pm2 to create a process to run the bot."

echo "Updating system.."
apt-get update
apt-get upgrade -y 

echo "Installing dependencies.."
apt install unzip npm -y
curl -fsSL https://deno.land/x/install/install.sh | sh

echo "Cloning the repository.."
git clone https://github.com/harshil8981/ChannelActionsHPBot
cd ChannelActionsBot

echo "Making a .env file.."
read -p "Enter your telegram bot token: " token
read -p "Enter telegram user IDs to be owners. (separate by space): " owners
read -p "Enter your MongoDB.com database URL: " dburl

# https://stackoverflow.com/a/13633682/15249128
cat > .env << EOF
BOT_TOKEN=$token
OWNERS=$owners
MONGO_URL=$dburl
EOF

echo "Installing pm2.."
npm install pm2 --location=global

echo "Starting the bot.."
if [ "$EUID" -ne 0 ]
then
  path="/home/$(whoami)/.deno/bin/deno"
else
    path="/root/.deno/bin/deno"
fi

pm2 start main.ts --interpreter=$path --interpreter-args="run --allow-env --allow-net --allow-read --no-prompt" --name "ChannelActions" -- --polling

echo "Bot has started. View logs using 'pm2 logs ChannelActions'"
echo ""
echo "Join @Hpbot <https://t.me/Hpbot_update> for more bots."
echo "Know more: https://github.com/harshil8981"
echo "Thanks for using Channel Actions Bot!"