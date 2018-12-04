#!/bin/bash
sudo -i
# desactivate selinux
setenforce 0
# configure hostnames
echo "
192.168.0.10 mariadb01" >> /etc/hosts
# desactivate firewall
systemctl disable firewalld
# update repo
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
# install mariadb
yum -y install \
  MariaDB-server \
  vim \
  net-tools
# configure mariadb
cp /vagrant/etc/server.cnf  /etc/my.cnf.d/server.cnf
# start mariadb
systemctl enable mariadb.service
systemctl start mariadb.service
