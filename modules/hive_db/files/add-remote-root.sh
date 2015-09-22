#!/bin/bash
mysql -u root -pvagrant << EOF
DELETE FROM mysql.user WHERE user = 'root' and host = '%';
flush privileges;
create user 'root'@'%' identified by 'vagrant';
grant all privileges on *.* to 'root'@'%' with grant option;
flush privileges;
EOF
