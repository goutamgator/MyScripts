function send_alert_email {
  COUNT=$1
  THRESHOLD=$2
  HOST=`hostname`
  SUBJECT="Event Resender failed repeatedly for ${COUNT} events on ${HOST}"
  ALERT_EMAIL=gpetroski@eharmony.com
  MESSAGE=/tmp/alert-message.txt
  echo "The event resender `pwd`/resend-nightly.sh on ${HOST} failed repeatedly for ${COUNT} events. This exceeds the threshold of ${THRESHOLD}. Please investigate." > $MESSAGE
  mail -s "$SUBJECT" "$ALERT_EMAIL" < $MESSAGE
}

send_alert_email 10 1