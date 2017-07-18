#!/bin/bash
# This needs to be placed in the /boot/post_launch/ directory and marked as executable - chmod +x
echo "remove the dansand-mongo-svr1 entry in the /etc/hosts file"
sed -i '/dansand-mongo-svr1/d' /etc/hosts

# Delete the existing PM2 environment and recreate 
