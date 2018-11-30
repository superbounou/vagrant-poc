#!/bin/ash

sudo -i
mysql -u root  -e "SHOW STATUS LIKE 'wsrep_cluster_size';"

