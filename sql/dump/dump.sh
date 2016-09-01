PROJECTNAME='myproject'
PASSWORDROOT='12345678'
DATE=$(date +"%Y%m%d%H%M")

mysqldump -uroot -p$PASSWORDROOT $PROJECTNAME > /var/sql/dump/$DATE-dump.sql
