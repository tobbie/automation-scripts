#!/usr/bin/python3
import os

def ubuntu_install():
    if os.system("sudo docker images") != 0:
        print("starting docker install")
        print("#####################################")
        print("add docker official GPG key")
        os.system("sudo apt-get update")
        os.system("sudo apt-get install ca-certificates curl")
        os.system("sudo install -m 0755 -d /etc/apt/keyrings")
        os.system("sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc")
        os.system("sudo chmod a+r /etc/apt/keyrings/docker.asc")
    
        print("add repository to apt sources")
        os.system("echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable\" |  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null")
        os.system("sudo apt-get update")

        print("now installing docker")
        os.system("sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y")

        print("verify docker installation was successful")
        os.system("sudo docker run hello-world")
    else:
        print("docker already installed...skipping")


def adduser_to_docker_group():
    user = os.getlogin()
    print(user)
    os.system(f"sudo usermod -aG docker {user}")

def main():
    ubuntu_install()
    adduser_to_docker_group()


main()