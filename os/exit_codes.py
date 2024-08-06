# run shell commands on current os

import os

def list_directory():
  ec1 =  os.system("ls")
  ec2 =  os.system("pwd")
  print(ec1)
  print(ec2)
    



list_directory()