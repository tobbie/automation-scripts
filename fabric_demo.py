'''
the script below is written for python 2
'''

''''
from fabric.api import *

def greeting(msg):
    print "good %s" % msg


def system_info():
    print "Disk space"
    local("df -h")

    print "RAM size"
    local("free -m")

    print("system uptime.")
    local("uptime")

def remote_exec():
    print "get system info"
    run("hostname")
    print "system uptime"
    run("uptime")
    print "disk space"
    run("df -h")
    print "RAM size"
    run("free -m")

    #sudo("yum install mariadb-server -y")
    #sudo("systemctl start mariadb")
    #sudo("systemctl enable mariadb")

def web_setup(weburl, dirname):
    print "####################################################################"
    local("apt install zip unzip -y")

    print "######################################################################"
    print "Installing dependencies"
    print "######################################################################"
    sudo("yum install httpd wget unzip -y")

    print "#######################################################################"
    print "start and enable service"
    print "#######################################################################"
    sudo("systemctl start httpd")
    sudo("systemctl enable httpd")

    print "##########################################################################"
    print "Downloading and pushing website to webservers."
    print "###########################################################################"
    local(("wget -O website.zip %s") % weburl)
    local("unzip -o website.zip")

    with lcd(dirname):
        local("zip -r tooplate.zip *")
        put("tooplate.zip", "/var/www/html/",use_sudo=True)

    with cd("/var/www/html"):
        sudo("unzip -o tooplate.zip")


    sudo("systemctl restart httpd")
    print("website setup is done")


'''

'''
fab -l : to see methods availble to fabric from the python file
fab -H 192.168.10.13 -u devops remote_exec  (run method on remote machine)
fab -H 192.168.10.13 -u devops web_setup:https://www.tooplate.com/zip-templates/2124_vertex.zip,2124_vertex
'''