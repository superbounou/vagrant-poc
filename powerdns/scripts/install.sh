#!/bin/bash

# set database name for powerdns backend
DATABASE=pdns
# become root
sudo -i
# desactivate selinux
setenforce 0
# configure hostnames
echo "192.168.0.10 powerdns01" >> /etc/hosts
# desactivate firewall
systemctl disable firewalld
# install repositories
yum install -y \
		epel-release \
		yum-plugin-priorities \
		https://centos7.iuscommunity.org/ius-release.rpm \
		&& curl -o /etc/yum.repos.d/powerdns-auth-41.repo https://repo.powerdns.com/repo-files/centos-auth-41.repo \
		&& curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo
# update the system
yum update -y
# install softwares
yum install -y \
		vim \
		net-tools \
		bind-utils \
		git \
		pdns \
		pdns-backend-mysql \
		mariadb-server \
		mariadb \
		python36u \
		python36u-devel \
		python36u-pip nginx \
		gcc \
		mariadb-devel \
		mariadb-shared \
		openldap-devel \
		xmlsec1-devel \
		xmlsec1-openssl \
		libtool-ltdl-devel \
		yarn \
		-y

# launch database
systemctl enable mariadb.service
systemctl start mariadb.service
mysql -e "CREATE DATABASE ${DATABASE}";
mysql -D ${DATABASE} < /vagrant/scripts/pdns.sql
#mysql_secure_installation <= mandatory for production use

# launch DNS server
cp /vagrant/etc/pdns.conf /etc/pdns/pdns.conf
systemctl enable pdns.service
systemctl start pdns.service

# install webgui
pip3.6 install -U pip
pip install -U virtualenv
rm -f /usr/bin/python3 && ln -s /usr/bin/python3.6 /usr/bin/python3
curl -sL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo
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
# configure systemd
cp /vagrant/etc/powerdns-admin.service /lib/systemd/system/
systemctl enable powerdns-admin.service
# launch GUI
systemctl start powerdns-admin.service
