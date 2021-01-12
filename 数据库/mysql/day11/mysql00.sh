
cd /usr/local/mysql
echo 'export PATH=/usr/local/mysql/bin:$PATH' >> /etc/profile
source /etc/profile
pkill mysqld
rm -rf /data/330* 
[ -f /etc/my.cnf ] && \
mv /etc/my.cnf /etc/my.cnf.bak

mkdir /data/33{07..10}/data -p

for i in 07 08 09 10 
do 
mysqld --initialize-insecure  --user=mysql --datadir=/data/33$i/data --basedir=/usr/local/mysql
cat >/data/33$i/my.cnf <<EOF
[mysqld]
basedir=/usr/local/mysql
datadir=/data/33$i/data
socket=/data/33$i/mysql.sock
port=33$i
log-error=/data/33$i/mysql.log
log_bin=/data/33$i/mysql-bin
binlog_format=row
skip-name-resolve
server-id=$i
gtid-mode=on
enforce-gtid-consistency=true
log-slave-updates=1
EOF
cat >/etc/systemd/system/mysqld33$i.service <<EOF
[Unit]
Description=MySQL Server
Documentation=man:mysqld(8)
Documentation=http://dev.mysql.com/doc/refman/en/using-systemd.html
After=network.target
After=syslog.target

[Install]
WantedBy=multi-user.target
[Service]
User=mysql
Group=mysql
ExecStart=/usr/local/mysql/bin/mysqld --defaults-file=/data/33$i/my.cnf
LimitNOFILE = 5000
EOF
done

chown -R mysql.mysql /data/*
for i in 07 08 09 10
do
systemctl start mysqld33$i
done


