#!/bin/sh

current_time=$(date +"%d%m%y-%H%M%S")
kb=K
bucket_name=upgrad-anupamdutta
myname=Anupam

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

if [ $? -eq 0 ]
then 
 echo "**apache2 is enabled**"
else
 echo "**apache2 is not enabled**"
fi


sleep 5
echo "**capturing apache2 logs...**"
tar -zcvf /tmp/$myname-httpd-logs-$current_time.tar /var/log/apache2/*.log
size_of_log=`wc -l /tmp/$myname-httpd-logs-$current_time.tar | awk '{print $1}'`

sleep 5
echo "**copying the logs to s3**"
aws s3 cp /tmp/$myname-httpd-logs-$current_time.tar s3://$bucket_name/$myname-httpd-logs-$current_time.tar



sleep 5
echo "**creating and updating inventory.html**"

FILE=/var/www/html/inventory.html
if [ -f "$FILE" ]; then
	    echo "**$FILE exists.**"
	    echo "<html>
	              <body>
			  <table style="width:40%">
			     <tr>
			       <td>httpd</td>
			       <td>$current_time</td>
			       <td>tar</td>
			       <td>$size_of_log$kb</td>
			     </tr>
			  </table>
                      </body>
		   </html>" >> /var/www/html/inventory.html   
                             
else 
	    echo "**$FILE does not exist.Creating new file..**"
            touch /var/www/html/inventory.html
            echo "<html>
                  <head>
                     <title>
                        Inventory
	             </title>
	          </head>
	          <body>
		    <table style="width:40%">
		       <tr>
		              <th>Log Type</th>
			      <th>Date Created</th>
			      <th>Type</th>
		              <th>Size</th>
			</tr>
		    </table>
	            <table style="width:40%">	    
			<tr>
			      <td>httpd</td>
			      <td>$current_time</td>
			      <td>tar</td>
			      <td>$size_of_log$kb</td>
			</tr>
		    </table>
		  </body>
                  </html>" >> /var/www/html/inventory.html
fi

sleep 5
echo "**copying inventory.html to s3**"
aws s3 cp /var/www/html/inventory.html s3://$bucket_name

sleep 5
echo "**creating cron job..**"
curr_path=$(pwd)
echo $curr_path
cd /etc/cron.d/
FILE=/etc/cron.d/automation
if [ -f "$FILE" ];then
	echo "**cron job schedule already exists**"
else	
	echo "**cron job does not exist, creating a new job..**"
        sudo touch /etc/cron.d/automation
        sudo echo "0 0 * * * root /root/Automation_Project-/automation.sh" > /etc/cron.d/automation
        sudo chmod 644 /etc/cron.d/automation
fi

