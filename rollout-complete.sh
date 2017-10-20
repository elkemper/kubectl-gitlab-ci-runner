#! /bin/sh
NAMESPACE=$1
DEPLOYMENT=$2

EXPECTED=$(kubectl -n $NAMESPACE get deployment/$DEPLOYMENT --output=json | jq '.spec.replicas')

echo "Namespace=$NAMESPACE, Deployment=$DEPLOYMENT"

echo -e "Expected replicas=$EXPECTED\n"

inc=0

# я знаю, что это плохо, но ...
for i in {1..2400}
do
    # дергаем раз в 2 секунды статус деплоймента
    if [ $(($inc % 4)) -eq 0 ]; 
    then
        WORKING_OUTPUT=$(kubectl -n $NAMESPACE get deployment/$DEPLOYMENT --output=json)
    fi

    AVAILIBLE=$(echo "$WORKING_OUTPUT" | jq '.status.availableReplicas' )
    ACTUAL=$(echo $WORKING_OUTPUT | jq '.status.replicas')
    UPDATED=$(echo $WORKING_OUTPUT | jq '.status.updatedReplicas')
    READY=$(echo $WORKING_OUTPUT | jq '.status.readyReplicas')

    echo -e "\e[1A\rActual=$ACTUAL, Updated=$UPDATED, Ready=$READY, Availible=$AVAILIBLE"

    if [ $AVAILIBLE = $EXPECTED ] && [ $ACTUAL = $EXPECTED ] && [ $UPDATED = $EXPECTED ] && [ $READY =  $EXPECTED ];
    then
        echo -e '\nrollout complete!\n'
        exit 0
    elif [ $(($inc % 2)) -eq 0 ] 
       then 
            echo -ne '\e[0K\rstill waiting...'
        else
            echo -ne '\e[0K\rstill waiting..'
       
    fi
    
    inc=$[$inc+1]
    sleep 0.5
done

echo "Это было слишком долго (больше 20 минут)"
exit 1
