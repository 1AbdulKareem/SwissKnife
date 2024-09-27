# command to backup the db
pg_dump  --format=custom --compress=zstd:9 -d $DBNAME  > $DBNAME.zstd

#command to restore the db
 pg_restore -d  $DBNAME.zstd 

#add crontab or scheduled actions to do daily backup at 00:00 AM
#add crontab or scheduled actions to do weekly backup at 00:00 AM
#add crontab or scheduled actions to do monthly backup at 00:00 AM  

# given a db.zstd path 