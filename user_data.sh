#!/bin/bash
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids "$(wget -q -O - http://169.254.169.254/latest/meta-data/instance-id)" --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
mount -t efs -o tls fs-...:/ /mnt/efs
cd /mnt/efs/
sed -i "11s/.*/\t\t\t\t\t\t\"Value\": \"$PUBLIC_IP\"/" ./change-resource-record-sets.json
aws route53 change-resource-record-sets --hosted-zone-id ... --change-batch file://change-resource-record-sets.json
cd /mnt/efs/minecraft_server
screen -dmS mc java -Xms7G -Xmx7G -jar paper.jar nogui
