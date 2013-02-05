# Script to connec to ssh clients.

# ./config is the file which contains all the connection setting values for all machines.
menu(){
	echo "Following machines are available for connection:";
	
	# Create an array settings using each line from config file.
	mapfile -t settings < "./config"
	
	# Store the total number of configurations given in the file.
	connections=${#settings[@]};
	echo ${settings[2]};
	
	# Display all the setting values from the config file.
	grep -ine ".*" ./config | cut -d " " -f 1;
}

input(){
	settingsArr=(${settings[$(($1 - 1))]});
	echo $settingsArr;
	user=${settingsArr[2]};
	passwd=${settingsArr[3]};
	ip=${settingsArr[4]};
	echo "Connecting to $ip using USER: $user ...";

	# Call the expect script to do the auto login using the username, password and ip from the file for the given machine.
	./enterPass.sh $ip $user $passwd
}

#Print Menu
menu;

#Prompt user for input.
read -p "Enter your choice[number]: " connect
#Connect to the specified machine.
input $connect

