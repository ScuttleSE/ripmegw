#!/bin/sh

RIPPID=`ps -ef|grep "rip_authors.pl"|grep -v grep|awk '{print $2}'`
JAVAPID=`ps -ef|grep java|grep -v "sh -c"|grep -v grep|awk '{print $2}'`
AUTHORFILE=`find /var/www/authors/ -mmin +15 -type f`

if [ -z "$RIPPID" ]
then
#  echo "No rip running, starting rip"
  cd /var/www
  nohup perl rip_authors.pl &
  exit
fi

if [ -n "$AUTHORFILE" ]
then
#  echo "Authorfile is old, restarting rip"
  kill -9 $RIPPID
  sleep 2
  kill -9 $JAVAPID
  sleep 2
  cd /var/www
  nohup perl rip_authors.pl &
  exit
fi

#echo "Rip is running, authorfile is new enough, everything OK"
