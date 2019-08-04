#!/bin/bash
set -e

# dump parameters to a tmp file
echo ${zookeeper_ips} >> /tmp/app.txt
echo ${hosted_zone_id} >> /tmp/app.txt
echo ${hosted_zone_name} >> /tmp/app.txt


function update_kafka_dns() {    
    # get availability zone: eg. ap-southeast-2a
    az=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
    echo $az >> /tmp/app.txt

    # get number from az tail value. ap-southeast-2a => a => 1
    launch_index=$(echo -n $az | tail -c 1 | tr abcdef 123456)
    
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
}

function update_configurations() {
    # update zookeeper IP address
    sed -i "s#localhost:2181#${zookeeper_ips}#g" /etc/kafka/server.properties
}

update_kafka_dns
update_configurations
systemctl restart kafka
sleep 10
/opt/confluent/bin/kafka-topics --bootstrap-server localhost:9092 --create --topic test-r2p1 --partitions 1 --replication-factor 2 --config retention.ms=1000000
/opt/confluent/bin/kafka-topics --bootstrap-server localhost:9092 --create --topic test-r2p6 --partitions 6 --replication-factor 2 --config retention.ms=1000000
/opt/confluent/bin/kafka-topics --bootstrap-server localhost:9092 --create --topic test-r3p3 --partitions 3 --replication-factor 3 --config retention.ms=1000000

