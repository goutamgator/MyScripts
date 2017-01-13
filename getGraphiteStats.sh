function format_csv_file() {
	csvfile=$1
	queue=$2
	includeTime=$3

	if [ $includeTime -gt 0 ]
	then
		echo "time,$queue" > ${csvfile}.tmp
	else
		echo "$queue" > ${csvfile}.tmp
	fi

	while read line
	do
		VALUE=`echo $line | tr ',' ' ' | awk '{ print $1 }'`

		if [ $includeTime -gt 0 ]
		then
			SECONDS=`echo $line | tr ',' ' ' | awk '{ print $2 }'`
			TIME=`date -r $SECONDS +%Y-%m-%dT%H:%M:%S`
			echo "$TIME,$VALUE" >> ${csvfile}.tmp
		else
			echo "$VALUE" >> ${csvfile}.tmp
		fi
	done < $csvfile
	mv ${csvfile}.tmp $csvfile
}

URL="http://carbon-dn2.dc1.eharmony.com/render/?from=-24hours&until=-1minute&format=json&target=hdp.yarn.scheduler"
QUEUES="default prod_dag prod_matching prod_platform prod_singles"
STATS="memoryPercentage applications vcores memory"
for stat in $STATS
do
	ALL_FILE=all-${stat}.csv
	for queue in $QUEUES
	do
		curl "${URL}.${queue}.${stat}" | grep -o "\[\[.*" | sed 's/\[//g' | sed 's/\],/:/g' \
		| sed 's/\]\]\}\]//g' | tr ':' '\n' | sed 's/ //g' > ${queue}.${stat}.csv
	done
done

for stat in $STATS
do
	ALL_FILE=all-${stat}.csv
	for queue in $QUEUES
	do
		QUEUE_STAT_FILE=${queue}.${stat}.csv

		if [ "$queue" == "default" ]
		then
			format_csv_file $QUEUE_STAT_FILE $queue 1
			cat $QUEUE_STAT_FILE > $ALL_FILE
		else
			format_csv_file $QUEUE_STAT_FILE $queue 0
			paste -d "," $ALL_FILE $QUEUE_STAT_FILE > ${ALL_FILE}.tmp
			mv ${ALL_FILE}.tmp $ALL_FILE
		fi
	done
done