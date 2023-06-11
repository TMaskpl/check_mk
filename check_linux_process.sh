#!/bin/bash

now=$(date)

# Check service on linux

FIRMA=JUSTMAR
MAIL=biuro@tmask.pl
SEM=services.sem
SLACK=
SLACKCH=firma
SERVICE_LIST=/usr/lib/check_mk_agent/services


for s in $(cat $SERVICE_LIST);
do
    systemctl status $s --no-pager 2>&1 1>/dev/null
    ret=$?
    if [ $ret -ne 0 ]; then
        systemctl start $s --no-pager 2>&1 1>/dev/null
        ret2=$?
        if [ $ret2 -ne 0 ]; then
            if [ -f "$SEM" ]; then
                echo " "
            else 
                echo "2 \"Check_Production_Service\" - Service ${s} is ERROR"
                curl -X POST --data-urlencode "payload={\"channel\": \"#$SLACKCH\", \"username\": \"$FIRMA \", \"text\": \"ERROR service - $s \", \"icon_emoji\": \":red_circle:\"}" $SLACK
                echo "$now - service ${s} - ERROR" >> /var/log/syslog
                touch $SEM
                exit 1
            fi
        else
            echo "0 \"Check_Production_Service\" - Service ${s} is OK"
            if [ -f "$SEM" ]; then
                rm $SEM
            fi
            echo "$now - service ${s} - OK" >> /var/log/syslog
            curl -X POST --data-urlencode "payload={\"channel\": \"#$SLACKCH\", \"username\": \"$FIRMA \", \"text\": \"OK service- $s \", \"icon_emoji\": \":white_check_mark:\"}" $SLACK
        fi
    else
        echo "0 \"Check_Production_Service\" - Service ${s} is OK"
    fi
done
