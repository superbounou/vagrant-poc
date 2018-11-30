#!/bin/bash
sudo -i
# desactivate selinux
setenforce 0
# configure hostnames
echo "
192.168.0.100 haproxy01
192.168.0.10 galera01
192.168.0.11 galera02
192.168.0.12 galera03" >> /etc/hosts
# desactivate firewall
systemctl disable firewalld
# update repo
yum update -y
yum install -y vim net-tools
if [[ $HOSTNAME =~ haproxy[0-9]+ ]]; then
	yum -y install haproxy
	cp /vagrant/etc/haproxy.conf  /etc/haproxy/haproxy.cfg
	systemctl enable haproxy.service
	systemctl start haproxy.service
	exit
fi

if [[ $HOSTNAME =~ galera[0-9]+ ]]; then
	# desactivate hugepage
	echo never > /sys/kernel/mm/transparent_hugepage/enabled
	echo never > /sys/kernel/mm/transparent_hugepage/defrag
	# install mariadb and galera
	curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | bash
	yum -y install galera MariaDB-server
	# configure mariadb
	cp /vagrant/etc/server.cnf  /etc/my.cnf.d/server.cnf
fi
