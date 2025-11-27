#!/bin/bash

USERNAME=""
PASSWORD=""
PORT="3923"

# Verify if python3 is installed
if ! command -v python3 &> /dev/null
then
	echo "python3 could not be found. Please install python3 and rerun the script
."
	exit 1
fi

# Verify if curl is installed
if ! command -v curl &> /dev/null
then
	echo "curl could not be found. Please install curl and rerun the script."
	exit 1
fi

# download copyparty https://github.com/9001/copyparty/releases/latest/download/copyparty-sfx.py

curl -L -o copyparty-sfx.py https://github.com/9001/copyparty/releases/latest/download/copyparty-sfx.py

# ask user what should be the username and password for the file server
# and sabe them in variables
read -p "Enter the username for the file server: " USERNAME
read -p "Enter the password for the file server: " PASSWORD
read -p "Enter the port for the file server [default: 3923]: " PORT
echo

CONFIG_FILE=$(cat << EOF
[global]
  p: $PORT        # port to listen on
# create users:
[accounts]
  $USERNAME: $PASSWORD   # username: password
# create volumes:
[/]         # create a volume at "/" (the webroot), which will
  .         # share the contents of "." (the current directory)
  accs:
    rw: $USERNAME  # the user gets read-write access
EOF
)

# save config file
echo "$CONFIG_FILE" > copyparty.conf
echo "Configuration file 'copyparty.conf' created."

pwd=$(pwd)

START_SCRIPT_COMMAND=$(cat << EOF
#!/bin/bash
cd "$pwd"
python3 copyparty-sfx.py -c copyparty.conf
EOF
)

# Create systemd user service
mkdir -p ~/.config/systemd/user

cat > ~/.config/systemd/user/fileserver.service << SYSTEMD
[Unit]
Description=Copyparty File Server
After=network.target

[Service]
Type=simple
WorkingDirectory=$pwd
ExecStart=/usr/bin/python3 $pwd/copyparty-sfx.py -c $pwd/copyparty.conf
Restart=on-failure

[Install]
WantedBy=default.target
SYSTEMD

# Reload systemd daemon, enable and start the service
systemctl --user daemon-reload
systemctl --user enable fileserver.service
systemctl --user restart fileserver.service

echo "Systemd service 'fileserver.service' created and started."
echo "The file server will now start automatically on system boot."

