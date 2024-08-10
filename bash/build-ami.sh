#!/bin/bash

wget https://raw.githubusercontent.com/tobbie/automation-scripts/main/docker/install_docker.py
chmod a+x install_docker.py
./install_docker.py
rm install_docker.py

wget https://amazoncloudwatch-agent.s3.amazonaws.com/debian/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard

#check agent status
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status


#start agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json

#install collectd if you enable it in the config wizard (https://github.com/awsdocs/amazon-cloudwatch-user-guide/issues/54)
sudo apt install collectd

sudo usermod -aG adm cwagent

# you must have container send logs to journald by add the log-driver flag
docker run -d --name nginx-container \
    --log-driver=journald \
    -p 80:80 \
    nginx


journalctl -u docker -f to see container logs in journald

journalctl -u docker -f | grep <container-id>

####Logs Paths###
/var/log/auth.log
/var/log/syslog
/var/log/dpkg.log


chmod 644 /var/log/syslog

569032579991.dkr.ecr.eu-west-1.amazonaws.com/grm-events-api:75850b160431e996e8916d6a6b9add07a4b47653

##########  Pull image and run from ECR ################

aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 569032579991.dkr.ecr.eu-west-1.amazonaws.com

docker pull 569032579991.dkr.ecr.eu-west-1.amazonaws.com/grm-production:c470780ea6c67fe13164aee38a1ffcc9a83a5b74

docker run  --name grm-event-api --log-driver=journald -d -p 80:3005 --env-file prod.env 569032579991.dkr.ecr.eu-west-1.amazonaws.com/grm-production:c470780ea6c67fe13164aee38a1ffcc9a83a5b74

docker service create  --name grm-event-api --log-driver=journald -d -p 80:3005 --env-file prod.env --replicas 4 569032579991.dkr.ecr.eu-west-1.amazonaws.com/grm-production:c470780ea6c67fe13164aee38a1ffcc9a83a5b74


