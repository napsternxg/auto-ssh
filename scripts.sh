# Script to connec to ssh clients.
DIRNAME=$(dirname $0)
AUTO_SSH_CONFIG=$DIRNAME"/config"
EXPECT_SCRIPT=$DIRNAME"/enterPass.sh"
echo "Path of config file: "$AUTO_SSH_CONFIG
# ./config is the file which contains all the connection setting values for all machines.
menu(){
	echo "Following machines are available for connection:";
	
	# Create an array settings using each line from config file.
	mapfile -t settings < $AUTO_SSH_CONFIG
	
	if [ $#{settings[@]} == 0 ]; then
		echo "Error reading config file."
		exit 1
	fi
	
	# Store the total number of configurations given in the file.
	connections=${#settings[@]};
	echo ${settings[2]};
	
	# Display all the setting values from the config file.
	grep -ine ".*" $AUTO_SSH_CONFIG | cut -d " " -f 1;
}

input(){
	settingsArr=(${settings[$(($1 - 1))]});
	echo $settingsArr;
	user=${settingsArr[2]};
	passwd=${settingsArr[3]};
	ip=${settingsArr[4]};
	echo "Connecting to $ip using USER: $user ...";

	# Call the expect script to do the auto login using the username, password and ip from the file for the given machine.
	$EXPECT_SCRIPT $ip $user $passwd
}

#Print Menu
menu;
echo "Arguments: $# and $@"
#Prompt user for input.
read -p "Enter your choice[number]: " connect
#Connect to the specified machine.
input $connect

