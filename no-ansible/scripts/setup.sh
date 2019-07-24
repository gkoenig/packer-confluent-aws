#! /bin/bash
sudo yum update -y
sudo yum install -y java-1.8.0-openjdk wget curl python unzip iproute selinux-policy-targeted policycoreutils-python netcat net-tools ca-certificates nmap-ncat figlet telnet lsof 

# Java Open JDK 8
sudo java -version

# Add file limits configs - allow to open 100,000 file descriptors
echo "* hard nofile 100000
* soft nofile 100000" | sudo tee --append /etc/security/limits.conf

sudo useradd confluent

# get Confluent distribution and configure target for /opt/confluent
cd /opt && curl http://packages.confluent.io/archive/5.2/confluent-community-5.2.1-2.12.tar.gz | sudo tar xzf -
sudo mv /opt/confluent-5.2.1 /opt/confluent
sudo chmod 755 /opt/confluent
sudo chown -R confluent /opt/confluent

sudo ln -s /opt/confluent/etc/kafka /etc/kafka

############################################
# Install Zookeeper boot scripts
############################################
echo "[Unit]
Description=Apache Zookeeper server 
Documentation=http://zookeeper.apache.org
Requires=network.target remote-fs.target 
After=network.target remote-fs.target
[Service]
Type=simple
User=zookeeper
SyslogIdentifier=zookeeper
Restart=always
RestartSec=0s
Group=zookeeper
ExecStart=/opt/confluent/bin/zookeeper-server-start /etc/kafka/zookeeper.properties
ExecStop=/opt/confluent/bin/zookeeper-server-stop
ExecReload=/opt/confluent/bin/zookeeper-server-stop && /opt/confluent/bin/zookeeper-server-start /etc/kafka/zookeeper.properties
WorkingDirectory=/zookeeper
[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/zookeeper.service

############################################
# Install Kafka boot scripts
############################################
echo "
[Unit]
Description=Apache Kafka server (broker)
Documentation=http://kafka.apache.org/documentation.html
Requires=network.target remote-fs.target 
After=network.target remote-fs.target zookeeper.service
[Service]
Type=simple
User=kafka
Group=kafka
Environment=JAVA_HOME=/etc/alternatives/jre
ExecStart=/opt/confluent/bin/kafka-server-start /etc/kafka/server.properties
ExecStop=/opt/confluent/bin/kafka-server-stop
[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/kafka.service


sudo rm -rf /var/cache/yum