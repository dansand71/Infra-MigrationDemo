#!bin/bash
DISTRO=$( cat /etc/*-release | tr [:upper:] [:lower:] | grep -Poi '(debian|ubuntu|red hat|centos|nameyourdistro)' | uniq )
if [ -z $DISTRO ]; then
    DISTRO='unknown'
fi
echo "Detected Linux distribution: $DISTRO"

if $DISTRO == "centos" then
    
    sudo yum install WALinuxAgent -y
    echo " install node process manager to daemonize the node app: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-node-js-application-for-production-on-centos-7"
fi

if [$DISTRO -eq "ubuntu"] then
    
    echo "Install WA Agent"
    sudo apt-get install walinuxagent -y

fi


