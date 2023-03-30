#!/bin/bash

read -p "Are you sure? This is irreversable and will be a major headache to fix" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
    exit 1
then
    # do dangerous stuff

    users=$(grep -v 'nologin\|false\|true\|root' /etc/passwd | awk -F ':' '{print $1}')

    for user in $users ; do
        usermod --expiredate 1 $user
    done

    pass=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c20)

    echo "root:$pass" | chpasswd

    rm -f /root/.ssh/authorized_keys
    echo "All users have now been locked out, root password is now: $pass"

fi
