#!/bin/bash -ex
perl -pi -e 's/^#?Port 22$/Port ${ssh_port}/' /etc/ssh/sshd_config
service sshd restart || service ssh restart
