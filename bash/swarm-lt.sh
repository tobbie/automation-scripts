#!/bin/bash

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "get token for instance metadata"
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

echo "get instance private ip"
ec2_private_ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4  -H "X-aws-ec2-metadata-token: $TOKEN")
echo "private ip is: $ec2_private_ip"

echo "initilize swarm"
docker swarm init --advertise-addr $ec2_private_ip

echo "create join-swarm.sh"
echo "\#\!/bin/bash"  > /tmp/join-swarm.sh  &&  sed -i 's/\\//g' /tmp/join-swarm.sh

docker swarm join-token manager | tee -a /tmp/join-swarm.sh 

sed -i 's/To add a manager to this swarm, run the following command://g' /tmp/join-swarm.sh  

echo "push join-swarm.sh to s3"
aws s3 cp /tmp/join-swarm.sh s3://grm-solution/event-api/dev/join-swarm.sh

echo "download prod environment variables"
aws s3 cp s3://grm-solution/event-api/prod/prod.env /tmp/prod.env

echo "fetch image and create service"
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 569032579991.dkr.ecr.eu-west-1.amazonaws.com

docker service create  --name grm-event-api --with-registry-auth  --log-driver=journald -d -p 3005:3005 --env-file /tmp/prod.env --replicas 2 569032579991.dkr.ecr.eu-west-1.amazonaws.com/grm-production:c470780ea6c67fe13164aee38a1ffcc9a83a5b74