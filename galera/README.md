Galera cluster and HAproxy
==============

Vagrant boxes with Galera cluster and HAproxy.

Only for testing purpose.

# Requirements

* Vagrant 2.2.0 ;
* Virtualbox 5.2.20 ;

Port mapping :

* HAproxy stats : 9000:9000
* Mysql : 3307:3306

# Install

Launch or restart the Vagrant box :

```
./restart.sh
```

Grab a coffee and wait for the install. After that go on haproxy01 stats page :

* http://localhost:9000 : HAproxy stats ;

All the backends are down, let's configure it :

## On galera01 :

```
ssh -pPORT vagrant@localhost
sudo -i
vim /etc/my.cnf.d/server.conf
```

Set IP and server name :

```
wsrep_node_address="192.168.0.10"
wsrep_node_name="galera01"
```

```
/vagrant/scripts/start_cluster.sh
```

On the others boxes, all the same commands except for the last one :

```
/vagrant/scripts/start_node.sh
```

Allright, check if our cluster is up and running. You can execute this script on any boxes :

```
/vagrant/scripts/check_cluster.sh
```

Expected output :

```
+--------------------+-------+
| Variable_name      | Value |
+--------------------+-------+
| wsrep_cluster_size | 3     |
+--------------------+-------+
```


Perfect. Now we can create dummy data for testing  :

```
sudo -i
/vagrant/scripts/db_test.sh
```

Finally we can secure our cluster :

```
mysql_secure_installation
```

You can check the replication, the database "test" is deleted on all node's cluster and we a have database "mydbtest".

The cluster is up and running now, but on HAproxy the backends are still red. Yes because HAproxy had not a proper user on the cluster to connect on it. Let's fix it :

```
/vagrant/scripts/haproxy_user.sh
```

Everything is green now :)

# Usage

On your host :

mysql -P3307 -umydbtestuser -p -h127.0.0.1 mydbtest

* mysql://localhost:3307 : Galera cluster with HA ;
