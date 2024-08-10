#!/bin/bash

aws s3 cp s3://grm-solution/join-swarm.sh

chmod a+x join-swarm.sh
./join-swarm.sh

docker service update --force --with-registry-auth --replicas 3 grm-event-api