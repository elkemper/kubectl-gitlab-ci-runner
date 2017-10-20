#!/bin/bash

PRIVATE_TOKEN='J8Jh5Rzz145D2PxpiKfa'
ARG_COMMAND=$( echo $1 | grep -e "projects\/[0-9]*\/trig" )

if [ -z "$ARG_COMMAND" ];
then
	echo "There is no correct curl hook"
	exit 1
fi

PIPELINE_ID=$( $ARG_COMMAND | jq '.id')
PROJECT_ID=$( echo $ARG_COMMAND | sed -r 's|(.*projects)/(.+)/(trigger.*)|\2|g')

echo "PROJECT_ID = $PROJECT_ID"
echo "PIPELINE_ID = $PIPELINE_ID"

for I in {1..240} 
do 
	sleep 5	
	PIPELINE_STATUS=$(curl -s --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" "https://gitlab.akb-it.ru/api/v4/projects/$PROJECT_ID/pipelines/$PIPELINE_ID" | jq '.status')
	echo $PIPELINE_STATUS 
	if [ $PIPELINE_STATUS = '"success"' ]; 
	then
		exit 0
	fi

	if [ $PIPELINE_STATUS = '"failed"' ]; 
	then
		exit 1
	fi

	if [ $PIPELINE_STATUS = '"canceled"' ]; 
	then
		exit 2
	fi

done

echo "Это было слишком долго (больше 20 минут)"
exit 1

