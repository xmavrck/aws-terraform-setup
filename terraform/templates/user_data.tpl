#!/bin/bash
yum-config-manager --disable centos-virt-xen
yum install NetworkManager ansible -y
systemctl enable NetworkManager.service
sed -i 's/SELINUX=disabled/SELINUX=permissive/g' /etc/selinux/config
reboot
