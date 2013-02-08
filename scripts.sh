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

config(){
	
	read -p "Connection Name: " connection
	read -p "IP: " ip
	read -p "Username: " user
	read -s -p "Password: " passwd
	if [-z $passwd ]; then
		passwd="null"
	fi
	echo "$connection ssh $user $passwd $ip" >> $AUTO_SSH_CONFIG
	echo "Configured $connection in $AUTO_SSH_CONFIG."
	return
}

init_app(){
	n_args=$#
	s_args=$@
	echo "Total arguments: $n_args"
	echo "Value of args: $s_args"
	if [ $n_args -lt 1 ]; then
		#Print Menu
		menu;
		echo "Arguments: $# and $@"
		#Prompt user for input.
		read -p "Enter your choice[number]: " connect
		#Connect to the specified machine.
		input $connect
	else
		case ${s_args[0]} in
		"config")
			echo "Configure a new connection:\n"
			config
			;;
		"remove")
			echo "Removing setting"
			;;
		esac
		echo "Finished config block"
	fi
}

init_app $@




