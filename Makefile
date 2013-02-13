install:
	echo ${PWD}"/scripts.sh" > auto-ssh
	chmod +x auto-ssh
	mv ./auto-ssh ~/.local/bin/
	echo "Install complete!!!"
	echo "Run using: auto-ssh"
	touch config
