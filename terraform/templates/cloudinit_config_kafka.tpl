#!/bin/bash
set -e

# dump parameters to a tmp file
echo ${zookeeper_ips} >> /tmp/app.txt
echo ${hosted_zone_id} >> /tmp/app.txt
echo ${hosted_zone_name} >> /tmp/app.txt
echo ${region} >> /tmp/app.txt

function update_kafka_dns() {    
    # get availability zone: eg. ap-southeast-2a
    az=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
    echo $az >> /tmp/app.txt

    # get ID tag to set broker-id
    INSTANCEID=$(ec2-metadata | grep -e '^instance-id' | awk '{print $2}')
    echo $INSTANCEID >> /tmp/app.txt
    launch_index=$(aws ec2 describe-tags --filters Name=resource-id,Values=$INSTANCEID Name=key,Values=ID --region "${region}" --out=json | jq -r '.Tags[]| select(.Key == "ID")|.Value')
    echo $launch_index >> /tmp/app.txt
    private_ip=$(curl "http://169.254.169.254/latest/meta-data/local-ipv4")
    echo $private_ip >> /tmp/app.txt

    tmp_file_name=tmp-record.json

    echo '{
    "Comment": "DNS updated by kafka autoscaling group",
    "Changes": [
        {
        "Action": "UPSERT",
        "ResourceRecordSet": {
            "Name": "'kafka$launch_index'.${hosted_zone_name}",
            "Type": "A",
            "TTL": 30,
            "ResourceRecords": [
            {
                "Value": "'$private_ip'"
            }
            ]
        }
        }
    ]
    }' > $tmp_file_name

    aws route53 change-resource-record-sets --hosted-zone-id ${hosted_zone_id} --change-batch file://$tmp_file_name

    sed -i "s#broker.id=0#broker.id=$launch_index#g" /etc/kafka/server.properties

    # set hostname
    hostnamectl set-hostname kafka$launch_index.${hosted_zone_name}
}

function update_configurations() {
    # update zookeeper IP address
    sed -i "s#localhost:2181#${zookeeper_ips}#g" /etc/kafka/server.properties
}

update_kafka_dns
update_configurations

reboot

