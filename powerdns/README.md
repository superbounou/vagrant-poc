PowerDNS with Vagrant
==============

Vagrant box with PowerDNS and PowerDNS-admin on CentOS 7.

Only for testing purpose.

# Requirements

* Vagrant 2.2.0 ;
* Virtualbox 5.2.20 ;

# Usage

Launch or restart the Vagrant box :

```
./restart.sh
```

Grab a coffee and wait for the install. After that go to :

* http://localhost:8080 : PowerDNS API ;
* http://localhost:8081 : PowerDNS-admin GUI ;


Configure the API key in PowerDNS-admin. The credentials are stored in `etc/`
