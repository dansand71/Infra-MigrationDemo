#!/bin/bash

#loop through the IP interfaces and setup the public DNS Settings
rgList=(
    "CloudEndure-eastus"
)

for rg in "${rgList[@]}"
do
    echo -e "Working on rg:$rg"
    echo -e "Configuring DNS Settings for demo"
    #~/bin/az vm list -g $rg -o tsv | for i in $(awk -F$'\t' '{print $8}'); do ansible-playbook deploy-OMSAgent-playbook.yml -i $i, & done
    ~/bin/az network public-ip list -g $rg -o tsv | 
    for i in $(awk -F$'\t' '{print $8}'); 
    do 
        if [[ $i == *"mongo"* ]]; then
            echo ".found mongo ip: " $i
            echo ". for demo setting this to dansand-nodetodo-mongo1"
            ~/bin/az network public-ip update -g $rg -n $i --dns-name dansand-az-nodetodo-db
        fi
        if [[ $i == *"node-frontend"* ]]; then
            echo ".found node ip: " $i
            echo ". for demo setting this to dansand-nodetodo-node1"
            ~/bin/az network public-ip update -g $rg -n $i --dns-name dansand-az-nodetodo
        fi
    done
    
done
echo "Complete."
open http://dansandinfra-nodejs-todo.azurewebsites.net