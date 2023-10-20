

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