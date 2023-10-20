
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka Leader Election Failures Incident.
---

This incident type refers to a problem with the leader election process in Apache Kafka, which is a distributed streaming platform. Leader election is a critical component of Kafka, as it determines which broker node is responsible for handling read and write requests for a specific partition of data. If leader election fails, it can result in data inconsistencies, message loss, and service disruptions. This type of incident requires immediate attention and resolution to ensure the stability and reliability of the Kafka cluster.

### Parameters
```shell
export ZOOKEEPER_HOST="PLACEHOLDER"

export PORT="PLACEHOLDER"

export TOPIC_NAME="PLACEHOLDER"

export ZOOKEEPER_PORT="PLACEHOLDER"

export ZOOKEEPER_HOSTNAME="PLACEHOLDER"

export KAFKA_SERVICE_NAME="PLACEHOLDER"
```

## Debug

### Check Zookeeper status
```shell
systemctl status zookeeper.service
```

### Check Kafka broker status
```shell
systemctl status kafka.service
```

### Check Kafka logs for any errors
```shell
journalctl -u kafka.service | grep ERROR
```

### Check Zookeeper logs for any errors
```shell
journalctl -u zookeeper.service | grep ERROR
```

### Check the Kafka topic for any issues
```shell
kafka-topics --describe --zookeeper ${ZOOKEEPER_HOST}:${PORT} --topic ${TOPIC_NAME}
```

### Check the Kafka broker configuration
```shell
cat /etc/kafka/server.properties
```

### Check the Zookeeper configuration
```shell
cat /etc/zookeeper/conf/zoo.cfg
```

### Check the Kafka broker leader election status
```shell
kafka-topics --describe --zookeeper ${ZOOKEEPER_HOST}:${PORT} --topic ${TOPIC_NAME} | grep "Leader:"
```

### Check the Zookeeper node status
```shell
echo stat | nc ${ZOOKEEPER_HOST} ${PORT}
```

### Check the Zookeeper node children
```shell
echo ls /brokers/ids | nc ${ZOOKEEPER_HOST} ${PORT}
```

## Repair

### Check if the issue is with the Zookeeper ensemble and fix any issues.
```shell


#!/bin/bash



# Check if ZooKeeper is running

zk_status=$(systemctl status zookeeper.service | grep Active | awk '{print $2}')



if [ "$zk_status" != "active" ]; then

  echo "ZooKeeper is not running. Starting ZooKeeper..."

  systemctl start zookeeper.service

fi



# Check if the ZooKeeper ensemble is healthy

zk_ok=$(echo ruok | nc ${ZOOKEEPER_HOSTNAME} ${ZOOKEEPER_PORT})



if [ "$zk_ok" != "imok" ]; then

  echo "ZooKeeper ensemble is unhealthy. Restarting ZooKeeper..."

  systemctl restart zookeeper.service

fi



echo "ZooKeeper is running and healthy."


```

### Restart the affected brokers to ensure that they are communicating properly with the Zookeeper.
```shell
bash

#!/bin/bash



# Stop the Kafka service on the affected brokers

sudo systemctl stop kafka.service



# Wait for a few seconds to allow the service to stop

sleep 10



# Start the Kafka service on the affected brokers

sudo systemctl start kafka.service



# Wait for a few seconds to allow the service to start

sleep 10



# Verify that the service has started successfully

sudo systemctl status kafka.service


```