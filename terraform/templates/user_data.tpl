#!/bin/bash
systemctl enable NetworkManager.service
systemctl start NetworkManager.service
mkdir -p /home/centos/.aws/
chown -R centos:centos /home/centos/.aws/
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDj8LvqIZC6N2yc8LbOkDalBN9M2hmq0udMn7mMT8Q1rA9LlC5TL6FqlRWj+r8H2CynqqKmRTTTfoANZ8b9Kc1GYvJPsxqd4cGQVkqCK+hpw86M//b6vKClVBmmzf5Z7Knwlla8Q4OeOMDhkuDxlifrKrdrNt/80Og7TzibupT8rZk7bFgOGHP+ez3v9Bq5fv/qem9MoRWVwRzEZ9XbXVgrmUIyN2FxroWaEww1NWlJcE+tES1LnFFsRy45ttN/OtG8y0J3lwjVsKnq3q4TpRYuPno8zMNBS7virQiltqPjO8vlEnfZLjjuc68QG1NgrZamFlKsLQN7vCUzfBgLAxPx okd-cluster" > /root/.ssh/authorized_keys
git clone https://github.com/openshift/openshift-ansible
cd openshift-ansible
git checkout release-3.11
