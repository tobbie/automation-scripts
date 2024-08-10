#!/bin/bash

##########  Pull image and run from ECR ################

aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 569032579991.dkr.ecr.eu-west-1.amazonaws.com

docker pull 569032579991.dkr.ecr.eu-west-1.amazonaws.com/grm-production:c470780ea6c67fe13164aee38a1ffcc9a83a5b74

#docker run  --name grm-event-api --log-driver=journald -d -p 80:3005 --env-file prod.env 569032579991.dkr.ecr.eu-west-1.amazonaws.com/grm-production:c470780ea6c67fe13164aee38a1ffcc9a83a5b74

docker service create  --name grm-event-api --with-registry-auth  --log-driver=journald -d -p 3005:3005 --env-file prod.env --replicas 2 569032579991.dkr.ecr.eu-west-1.amazonaws.com/grm-production:c470780ea6c67fe13164aee38a1ffcc9a83a5b74

docker service update --force --with-registry-auth --replicas 3 grm-event-api
