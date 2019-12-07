#!/bin/bash

#### 
#
# Change the backup location as required. Variable named - BACKUP_LOCATION
# The backup for static files and mosquitto log is directlt inside BACKUP_LOCATION. So this would get daily updated.
# Since log and static files wouldn't get corrupted we retain this idea of having only a single copy of the data.
# For all other, the backup creation would create a foler inside the backup folder for that day.
#
####
echo "Enter Path for Backup folder"
read BACKUP_LOCATION
#BACKUP_LOCATION="/home/varsha/Documents/iotm/scripts/backup" #PLEASE NOTE NOT TO PUT / AT END
DATE=`date +%Y-%m-%d`
BACKUP=$BACKUP_LOCATION"/"$DATE

### Fetching the docker ids required ###
SQLID=`sudo docker ps -aqf "name=mysql"`
DJANGOID=`sudo docker ps -aqf "name=iotm_django_1"`

### The file names of the logs ###
SQL_FILE=$BACKUP"/"$DATE"_mysql.sql"
SERV_FILE=$BACKUP"/"$DATE"_django.json"
STATIC_FLD=$BACKUP_LOCATION"/static"
LOG_FILE=$BACKUP_LOCATION"/_mosquitto.log"

########################### SQL DUMP ######################

sql=$(ls -dt -- backup/*/ | head -n1)
sql=${sql:7:-1}
restoreSQL=$BACKUP_LOCATION"/"$sql"/"$sql"_mysql.sql"

if [ ! -f $restoreSQL ]; then
    echo "$0: SQL Dump not present"
else
	sudo docker exec -i $SQLID /usr/bin/mysql -u anrg_iotm --password=AnRg@UsC iotm2 < $restoreSQL
	#cat $restoreSQL | sudo docker exec -i $SQLID /usr/bin/mysql -u anrg_iotm root --password=AnRg@UsC iotm2 
	echo "SQL Dump Restored"
fi

######################## STATIC IMAGE COPY ###############

if [ ! -d $STATIC_FLD ]; then
    echo "Static files do not exist"
else
	sudo docker cp $STATIC_FLD $DJANGOID:/code/frontend/static_cdn/protected/
	sudo docker cp $STATIC_FLD $DJANGOID:/code/frontend/static_cdn/media/
	sudo docker exec -it $DJANGOID sh -c "test -d /code/frontend/static_cdn/media/ && echo 'Media Files Exist'"
	sudo docker exec -it $DJANGOID sh -c "test -d /code/frontend/static_cdn/protected/ && echo 'Protected Files Exist'"

	echo "Static files restored"
fi

echo "Like a Boss"

