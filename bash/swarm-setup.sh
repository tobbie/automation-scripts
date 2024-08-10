#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`

curl http://169.254.169.254/latest/meta-data/profile -H "X-aws-ec2-metadata-token: $TOKEN"

ec2_private_ip = $(curl http://169.254.169.254/latest/meta-data/local-ipv4  -H "X-aws-ec2-metadata-token: $TOKEN")
docker swarm init --advertise-addr $ec2_private_ip

echo "\#\!/bin/bash"  >  join-swarm.sh  &&  sed -i 's/\\//g' join-swarm.sh

docker swarm join-token manager | tee -a join-swarm.sh 
sed -i 's/To add a manager to this swarm, run the following command://g' join-swarm.sh  

aws s3 cp join-swarm.sh s3://grm-solution/event-api/dev

aws s3 cp s3://grm-solution/event-api/prod/prod.env .



