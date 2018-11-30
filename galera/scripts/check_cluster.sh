#!/bin/bash

mysql -u root  -e "SHOW STATUS LIKE 'wsrep_cluster_size';"
