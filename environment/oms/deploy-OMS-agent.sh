#!/bin/bash
rgList=(
    "ossdemo-infra-migrate"
    "CloudEndure-eastus"
)

for rg in "${rgList[@]}"
do
    echo -e "\e[33mWorking on rg:$rg"
    echo -e "reconfiguring oms agents"
    #~/bin/az vm list -g $rg -o tsv | for i in $(awk -F$'\t' '{print $8}'); do ansible-playbook deploy-OMSAgent-playbook.yml -i $i, & done
    ~/bin/az vm list -g $rg -o tsv | for i in $(awk -F$'\t' '{print $8}'); do az vm extension set --publisher Microsoft.EnterpriseCloud.Monitoring --resource-group $rg --vm-name $i --name OmsAgentForLinux --version 1.3 --settings OMS-public.json --protected-settings OMS-protected.json & done
    
done

echo "Complete."