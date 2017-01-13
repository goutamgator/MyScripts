LAST_NAME=""
TOTAL_TICKS=0

cat /dev/null > output.txt

while read line
do
	NAME=`echo $line | awk '{ print $1 }'`
	TICK1=`echo $line | awk '{ print $2 }'`
	TICK2=`echo $line | awk '{ print $3 }'`
	CURRENT_TOTAL=`expr $TICK1 + $TICK2`

	if [ "$NAME" == "$LAST_NAME" ]
	then
		TOTAL_TICKS=`expr $TOTAL_TICKS + $CURRENT_TOTAL`
		echo $TOTAL_TICKS
	else
		echo "$LAST_NAME $TOTAL_TICKS" >> output.txt
		LAST_NAME=$NAME
		TOTAL_TICKS=$CURRENT_TOTAL
	fi
done < stats.csv
echo "$LAST_NAME $TOTAL_TICKS" >> output.txt