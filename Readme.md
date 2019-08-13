# Build AWS AMI including Confluent Kafka

## prerequisite
```packer``` has been installed => [link](https://www.packer.io/intro/getting-started/install.html)

## set some environment variables
to avoid specifying e.g. credentials in the packer json template (and thereby publish them in this repo), we are using environment variables instead.
```
export AWS_ACCESS_KEY_ID=<your-aws-access-key>
export AWS_SECRET_ACCESS_KEY=<your-aws-access-secret>
export SOURCE_AMI=<your-source-ami>
```
Initial version uses ```eu-central-1``` (Frankfurt) as region. TODO: use a variable for the region as well

If you e.g. want to build upon an **Amazon-Linux AMI**, you can find the latest source AMIs [here](https://aws.amazon.com/de/amazon-linux-ami/)
or e.g. an **Amazon Linux 2** AMI: ```ami-0ebe657bc328d4e82```

## build the image
to build your AMI, execute
```
packer build packer-confluent-kafka.json
```
a more verbose build run can be enabled by setting following flag:
```
PACKER_LOG=1 packer build packer-confluent-kafka.json
```

## What does it do?
* This repo aims for source AMI's based on RH-based os (CentOS, RHEL, Amazon Linux,..).  
* OpenJDK 1.8 is installed and set as default
* Confluent Kafka (Community) distribution tar.gz is downloaded and extracted to ```/opt/confluent```.
  initial commit uses Confluent v 5.2.1 , TODO: use variable instead of hardcoding version
* The config directory ```/etc/kafka``` is linked to ```/opt/confluent/etc/kafka```

## Customization
to further config your final operating system, check [setup.sh](./scripts/setup) and adjust
* os packages to be installed
* start services by default
* ...whatever you'd like to be baken into the AMI from OS point of view


# Create some dummy data and check metrics

Kafka metrics are being pushed to Cloudwatch via _dataflow_ :
```
Kafka broker ==> Jolokia JMX exporter (broker local port 7777)  <== Telegraf collects metrics from Jolokia ==> push to AWS Cloudwatch
```
### Create some topics
...and set retention time to a very low value, to ensure that data is purged fast to avoid _disk full_ situations

* topic with replication *1* and partitions *1* : 
  ```/opt/confluent/bin/kafka-topics --bootstrap-server kafka1.scigility.net:9092 --create --topic r1-p1 --partitions 1 --replication-factor 1 --config retention.ms=10000```

* topic with replication *1* and partitions *6* : 
  ```/opt/confluent/bin/kafka-topics --bootstrap-server kafka1.scigility.net:9092 --create --topic r1-p6 --partitions 6 --replication-factor 1 --config retention.ms=10000```

* topic with replication *3* and partitions *3* : 
  ```/opt/confluent/bin/kafka-topics --bootstrap-server kafka1.scigility.net:9092 --create --topic r3-p3 --partitions 3 --replication-factor 3 --config retention.ms=1000```

### Create some dummy data to see the metrics charts _in action_. Login to one of the Kafka broker hosts and execute:
* Write to topic which has only 1 partition (hence only one broker gets data)  
```/opt/confluent/bin/kafka-producer-perf-test --producer-props bootstrap.servers=kafka1.scigility.net:9092 --topic r1-p1 --num-records 10000000 --record-size 1024 --throughput 10000```

* Write to topic with 3 replication&partitions, unlimited throughput, so that all brokers receive data  
```/opt/confluent/bin/kafka-producer-perf-test --producer-props bootstrap.servers=kafka1.scigility.net:9092 --topic r3-p3 --num-records 1000000 --record-size 1024 --throughput -1```

