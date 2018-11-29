PowerDNS with Vagrant
==============

Vagrant box with PowerDNS and PowerDNS-admin on CentOS 7.

Only for testing purpose.

# Requirements

* Vagrant 2.2.0 ;
* Virtualbox 5.2.20 ;

Port mapping :

* DNS 5300:53
* PowerDNS API : 8080:80
* PowerDNS-admin : 8081:1951

# Usage

Launch or restart the Vagrant box :

```
./restart.sh
```

Grab a coffee and wait for the install. After that go to :

* http://localhost:8080 : PowerDNS API ;
* http://localhost:8081 : PowerDNS-admin GUI ;


Configure the API key in PowerDNS-admin. The credentials are stored in `etc/pdns.conf`

Query PowerDNS on your host :

```
dig -p5300 +short www.example.com @localhost
192.0.2.10
```
