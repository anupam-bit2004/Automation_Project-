# Automation_Project-

Task Details
This project contains an automation bash script named ‘automation.sh’ which performs the following subtasks. 

(Hint: Running ./automation.sh with root privileges must do the following listed tasks.)

 

The script performs the following tasks:- 

1. Performs an update of the package details and the package list at the start of the script.
sudo apt update -y
 
2. It Installs the apache2 package if it is not already installed. (The dpkg and apt commands are used to check the installation of the packages.)

3. Ensure that the apache2 service is running. 

4. Ensure that the apache2 service is enabled. 

5. Creates a tar archive of apache2 access logs and error logs that are present in the /var/log/apache2/ directory and place the tar into the /tmp/ directory. 
The script runs the AWS CLI command and copy the archive to the s3 bucket. 
#For e.g : use timestamp=$(date '+%d%m%Y-%H%M%S') ) to name  the  tar
aws s3 \
cp /tmp/${myname}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
 
6. Bookkeeping - Ensures that the script checks for the presence of the inventory.html file in /var/www/html/; if not found, creates it. This file will essentially serve as a web page to get the metadata of the archived logs. (Hitting ip/inventory.html will show the bookkeeping data)

7. At any point in time, the first line in the inventory.html file will look like this:
cat /var/www/html/inventory.html
 

Log Type         Time Created         Type        Size


If an inventory file already exists, the content of the file should not be deleted or overwritten. New content should be only appended in a new line.


When the script runs, it should create a new entry in the inventory.html file about the following: 

What log type is archived?
Date when the logs were archived 
The type of archive
The size of the archive
Your inventory file should look like the following after multiple runs:

cat /var/www/html/inventory.html

Log Type               Date Created               Type      Size 
httpd-logs        010120201-100510         tar        10K
httpd-logs        020120201-100510         tar        40K
httpd-logs        030120201-100510        tar        4K
httpd-logs        040120201-100510        tar        6K



8. Cron Job - The script creates a cron job file in /etc/cron.d/ with the name 'automation' that runs the script /root/<git repository name>/automation.sh every day via the root user.
The script should be placed in the /root/<git repository name>/ directory. (Example: If your Git repository is named ‘Automation_Project’, the cron job will then run the script present in /root/Automation_Project/automation.sh)

 



 

