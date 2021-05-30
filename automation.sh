#!/bin/sh

current_time=$(date +"%d%m%y-%H%M%S")

sudo apt update -y

dpkg -l | grep -i 'apache2'  &> /dev/null

if [ $? -eq 0 ]; then
  echo "**apache2  is installed!**"
else
  echo "**apache2 is not installed.Installing the same.....**"
  sudo apt install apache2 -y
fi

sleep 5

ps cax | grep -i 'apache2' &> /dev/null
if [ $? -eq 0 ]
then
 echo "**apache2 is running**"
else 
 echo "**apache2 is not running**"
fi

sleep 5

sudo systemctl enable apache2

service apache2 status &> /dev/null
if [$? -eq 0]
then 
 echo "**apache2 is enabled**"
else
 echo "**apache2 is not enabled**"
fi

sleep 5

echo "**capturing apache2 logs...**"
tar -zcvf /tmp/Anupam-httpd-logs-$current_time.tar /var/log/apache2/*.log

sleep 5
echo "**copying the logs to s3**"
aws s3 cp /tmp/Anupam-httpd-logs-$current_time.tar s3://upgrad-anupamdutta/Anupam-httpd-logs-$current_time.tar

