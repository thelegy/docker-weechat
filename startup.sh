#!/bin/sh
su -c /usr/bin/tor tor &

/usr/sbin/sshd -D
