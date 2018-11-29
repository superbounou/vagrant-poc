#!/bin/bash

# set database name for powerdns backend
DATABASE=pdns
# become root
sudo -i
# desactivate selinux
setenforce 0
# configure hostnames
echo "
192.168.0.10 powerdns01
192.168.0.11 client01" >> /etc/hosts
# desactivate firewall
systemctl disable firewalld
# install tools 
yum install -y vim net-tools bind-utils epel-release yum-plugin-priorities git -y &&
curl -o /etc/yum.repos.d/powerdns-auth-41.repo https://repo.powerdns.com/repo-files/centos-auth-41.repo
yum update -y

if [[ $HOSTNAME =~ powerdns[0-9]+ ]]; then
	# install mariadb backend
	yum -y install mariadb-server mariadb 
	systemctl enable mariadb.service
	systemctl start mariadb.service
	mysql -e "CREATE DATABASE ${DATABASE}";
	mysql -D ${DATABASE} < /vagrant/scripts/pdns.sql
	#mysql_secure_installation
	yum -y install pdns pdns-backend-mysql
	cp /vagrant/etc/pdns.conf /etc/pdns/pdns.conf
	systemctl enable pdns.service
	systemctl start pdns.service

	# install webgui
	yum install https://centos7.iuscommunity.org/ius-release.rpm -y
	yum install python36u python36u-devel python36u-pip nginx -y
	pip3.6 install -U pip
 	pip install -U virtualenv
	rm -f /usr/bin/python3 && ln -s /usr/bin/python3.6 /usr/bin/python3
	yum install gcc mariadb-devel MariaDB-shared openldap-devel xmlsec1-devel xmlsec1-openssl libtool-ltdl-devel -y
	curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo
	yum install yarn -y
	git clone https://github.com/ngoduykhanh/PowerDNS-Admin.git /opt/web/powerdns-admin
        cd /opt/web/powerdns-admin
	virtualenv -p python3 flask
	. ./flask/bin/activate
	pip install python-dotenv
	pip install -r requirements.txt
	cp /vagrant/etc/config.py /opt/web/powerdns-admin
	export FLASK_APP=app/__init__.py
	flask db upgrade
	yarn install --pure-lockfile
	flask assets build
	. ./flask/bin/activate
	./run.py &
	exit
fi

if [[ $HOSTNAME =~ client[0-9]+ ]]; then

fi
