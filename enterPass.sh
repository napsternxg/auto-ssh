#!/usr/bin/expect

set ip [lindex $argv 0]
set user [lindex $argv 1]
set password [lindex $argv 2]

#Create the ssh session using the username, password and ip of the machine selected.

spawn /usr/bin/ssh -l $user $ip
expect {
	-re ".*assword:" {
		send $password
		send "\n"
		interact
	}
}

#Exit expect script.