#!/bin/bash

#RUN THIS FROM YOUR DESKTOP CLIENT to change the Azure backend servers
#if this fails it is likely you have not updated the /etc/hosts with the correct IP addresses

echo "SSH into MONGO backend and export data into cosmosdb"
ssh -i ~/Desktop/msready-demo/aws-linux-vms.pem ubuntu@dansand-az-nodetodo-db.eastus.cloudapp.azure.com bash <<EOF

mongoexport --db todo \
    --collection todos \
    --out todos.json

mongoimport --host nodejs-todo.documents.azure.com:10255 \
    -u nodejs-todo \
    -p VbtkysT46KJx2FcTECQFVCVtOK4EWCTWTM9zwcEA55V3sgF1onpeQrUqPwXTfD1ufwLGrkNTmxLtMA75wyMVmg== \
    --db todo \
    --collection todos \
    --ssl --sslAllowInvalidCertificates \
    --type json --file todos.json \
    --drop

EOF

