while read line
do
	echo "========================================"
	echo "$line"
	echo "========================================"
#	CURRENT_GROUP=`curl -s "http://matching-user-service.prod.vip.dc1.eharmony.com/user-service/3.0/user/$line" | grep -o group.:.*\" | sed 's/\"/ /g' | awk '{ print $3 }'`
#	echo "Current group: $CURRENT_GROUP"
	curl -s -X PUT "http://matching-user-service.prod.vip.dc1.eharmony.com/user-service/3.0/user/$line/update/matchingtest"
	
#	AFTER_GROUP=`curl -s "http://matching-user-service.prod.vip.dc1.eharmony.com/user-service/3.0/user/$line" | grep -o group.:.*\" | sed 's/\"/ /g' | awk '{ print $3 }'`
#	echo "After group: $AFTER_GROUP"

#	if [ "$CURRENT_GROUP" != "$AFTER_GROUP" ]
#	then
#		echo "$CURRENT_GROUP != $AFTER_GROUP EXITING"
#		exit 1
#	fi
	echo ""	
done < $1
