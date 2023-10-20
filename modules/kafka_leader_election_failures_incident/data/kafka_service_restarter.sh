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