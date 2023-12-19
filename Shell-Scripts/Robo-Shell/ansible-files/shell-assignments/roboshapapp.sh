#!/bin/bash
AMI="ami-03265a0778a880afb"
SG_ID="sg-0170a2c37d33656c2"
ZONE_ID="Z0069445QUE862M2UD65"
INSTANCE=("mongodb" "redis" "catalogue" "shipping" "web" "mysql" "payment" "dispatch" "rabbitmq" "cart")
DOMAIN_NAME="roboshopapp.website"

for i in "${INSTANCE[@]}"; do
    if [ $i == "momngodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]; then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --count 1 --instance-type $INSTANCE_TYPE --security-group-ids sg-0170a2c37d33656c2 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query "Instances[0].PrivateIpAddress" --output text)
    echo "$i: $IP_ADDRESS"

    #create R53 record, make sure you delete existing record
    aws route53 change-resource-record-sets \
        --hosted-zone-id $ZONE_ID \
        --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "CREATE"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
        '

done
