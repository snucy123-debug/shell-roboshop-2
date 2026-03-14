#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
SG_ID="sg-0cb7bc58080de4d99" # replace with your SG ID
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
ZONE_ID="Z01604136BDJ5YNPI3XX" # replace with your ZONE ID
DOMAIN_NAME="vkdevin.online" # replace with your domain

#for instance in ${INSTANCES[@]} # If we run this it will install all instance 
for instance in $@
#ABOVE COMMAND  instance in $@  ►so here it help ful for install instance what ever u need like we need to give inastance name in linux server.

do
    INSTANCE_ID=$(aws ec2 run-instances --image-id ami-0220d79f3f480ecf5 --instance-type t3.micro --security-group-ids sg-0cb7bc58080de4d99 --tag-specifications "ResourceType=instance,Tags=[{Key=Name, Value=$instance}]" --query "Instances[0].InstanceId" --output text)
    if [ $instance != "frontend" ]
    then
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
        RECORD_NAME="$instance.$DOMAIN_NAME"
    else
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
        RECORD_NAME="$DOMAIN_NAME"
    fi
    echo "$instance IP address: $IP"

    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating or Updating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "UPSERT" 
        ,"ResourceRecordSet"  : {
            "Name"              : "'$RECORD_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP'"
            }]
        }
        }]
    }'
done

# ABOVE "UPSERT" COMMAND IS USEFUL FOR CREATE CREATE IF ITS NOT YET EXIST OR ELSE IF ITS CREATE SKIP IT
# #---------------------------------------------------------------------------------------------NOTES

# Internet
#    |
# frontend.daws84s.site
#    |
# ---------------------------
# |  user  | cart | payment |
# | redis  | mysql | mongo |
# ---------------------------

# ⭐ In simple words (what you must remember)

# Before running script:

# ✔ AWS CLI installed
# ✔ IAM permissions
# ✔ Correct AMI ID
# ✔ Correct Security Group
# ✔ Correct Hosted Zone ID
# ✔ Execute permission for script

# Just remember the 3 AWS CLI commands used:
# aws ec2 run-instances

# aws ec2 describe-instances

# aws route53 change-resource-record-sets

#--------------------------------------------------OUTPUT--------------------------------------------------------

#INSTANCES AND RECORDS CREATED SUCESSFULLY 

# mongodb IP address: 172.31.68.156
# {
#     "ChangeInfo": {
#         "Id": "/change/C04251703AQETIMCS1MXI",
#         "Status": "PENDING",
#         "SubmittedAt": "2026-03-08T06:40:48.887000+00:00",
#         "Comment": "Creating or Updating a record set for cognito endpoint"
#     }
# }
# redis IP address: 172.31.67.246
# {
#     "ChangeInfo": {
#         "Id": "/change/C09499153KBWPZKA478IZ",
#         "Status": "PENDING",
#         "SubmittedAt": "2026-03-08T06:40:52.770000+00:00",
#         "Comment": "Creating or Updating a record set for cognito endpoint"
#     }
# }
# mysql IP address: 172.31.72.228
# {
#     "ChangeInfo": {
#         "Id": "/change/C0042599UOL59ODIKJR2",
#         "Status": "PENDING",
#         "SubmittedAt": "2026-03-08T06:40:56.686000+00:00",
#         "Comment": "Creating or Updating a record set for cognito endpoint"
#     }
# }
# rabbitmq IP address: 172.31.65.8
# {
#     "ChangeInfo": {
#         "Id": "/change/C047803923KBY102TGQJ2",
#         "Status": "PENDING",
#         "SubmittedAt": "2026-03-08T06:41:00.666000+00:00",
#         "Comment": "Creating or Updating a record set for cognito endpoint"
#     }
# }
# catalogue IP address: 172.31.75.221
# {
#     "ChangeInfo": {
#         "Id": "/change/C00432193XQ9N6AHV8SB",
#         "Status": "PENDING",
#         "SubmittedAt": "2026-03-08T06:41:05.534000+00:00",
#         "Comment": "Creating or Updating a record set for cognito endpoint"
#     }
# }
# user IP address: 172.31.70.72
# {
#     "ChangeInfo": {
#         "Id": "/change/C04832883FUAED9BW386P",
#         "Status": "PENDING",
#         "SubmittedAt": "2026-03-08T06:41:09.535000+00:00",
#         "Comment": "Creating or Updating a record set for cognito endpoint"
#     }
# }
# cart IP address: 172.31.78.82
# {
#     "ChangeInfo": {
#         "Id": "/change/C0476719RV3545U31OWB",
#         "Status": "PENDING",
#         "SubmittedAt": "2026-03-08T06:41:13.539000+00:00",
#         "Comment": "Creating or Updating a record set for cognito endpoint"
#     }
# }
# shipping IP address: 172.31.68.75
# {
#     "ChangeInfo": {
#         "Id": "/change/C04754973P6GOCZ3LKDAQ",
#         "Status": "PENDING",
#         "SubmittedAt": "2026-03-08T06:41:17.371000+00:00",
#         "Comment": "Creating or Updating a record set for cognito endpoint"
#     }
# }
# payment IP address: 172.31.68.73
# {
#     "ChangeInfo": {
#         "Id": "/change/C05412072ZF2BWIQNI9EP",
#         "Status": "PENDING",
#         "SubmittedAt": "2026-03-08T06:41:21.236000+00:00",
#         "Comment": "Creating or Updating a record set for cognito endpoint"
#     }
# }
# dispatch IP address: 172.31.70.230
# {
#     "ChangeInfo": {
#         "Id": "/change/C05013041RWPH2KW6IMGZ",
#         "Status": "PENDING",
#         "SubmittedAt": "2026-03-08T06:41:25.101000+00:00",
#         "Comment": "Creating or Updating a record set for cognito endpoint"
#     }
# }
# frontend IP address: 98.92.248.138
# {
#     "ChangeInfo": {
#         "Id": "/change/C00354502B5IDBUHJCX8P",
#         "Status": "PENDING",
#         "SubmittedAt": "2026-03-08T06:41:29.284000+00:00",
#         "Comment": "Creating or Updating a record set for cognito endpoint"
#     }
# }

