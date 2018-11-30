# as root
mysql -e "create database mydbtest"
mysql -e "GRANT ALL PRIVILEGES ON mydbtest.* TO 'mydbtestuser'@'haproxy01' identified by 'munster'"

