import os

userList = ['alpha', 'beta', 'gamma']

def add_users():
    print("Adding users to the system")
    print("############################################################################")

    for user in userList:
        exitCode = os.system(f"id {user}")
        if exitCode != 0:
            print(f"user {user} does not exist. adding it......")
            print("##################################################")
            print()
            os.system(f"useradd {user}")
        else:
            print("user already exists, therefore, I'm skipping it")
            print("################################################")
            print()

def add_group(group):
    exitcode = os.system(f"cat /etc/group | grep {group}")
    if exitcode != 0:
        print(f"group {group} does not exist. adding it")
        print("#################################################")
        print()
        os.system(f"groupadd {group}")
    else:
        print(f"{group} already exist, skipping it")
        print("#######################################")
        print()

def add_users_to_group(group):
    for user in userList:
        print(f"adding user {user} to {group} group")
        print("#######################################")
        print()
        os.system(f"usermod -G {group} {user}")

def add_directory(dir, group):
    print("adding directory")
    print("#####################################")
    print()

    if os.path.isdir(f"/opt/{dir}"):
        print("directory exists, skipping it")
    else:
        os.mkdir(f"/opt/{dir}")

    print("assigning permission and ownership to directory")
    print("###############################################")
    print()
    os.system(f"chown :{group} /opt/{dir}")
    os.system(f"chmod 770 /opt/{dir}")

add_users()
groupName = input('enter group name to add ' )
add_group(groupName)
add_users_to_group(groupName)

dir = input('enter directory to create ')
add_directory(dir, groupName)

