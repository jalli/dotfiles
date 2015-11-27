reate ~/.pulse/mute if not exists
ls ~/.pulse/mute &> /dev/null
if [[ $? != 0 ]]
then
    echo "false" > ~/.pulse/mute
fi

####Create ~/.pulse/volume if not exists
ls ~/.pulse/volume &> /dev/null
if [[ $? != 0 ]]
then
    echo "65536" > ~/.pulse/volume
fi

CURVOL=`cat ~/.pulse/volume`     #Reads in the current volume
MUTE=`cat ~/.pulse/mute`          #Reads mute state

if [[ $1 == "increase" ]]
then
    CURVOL=$(($CURVOL + 1024)) #3277 is 5% of the total volume, you can change this to suit your needs.
    if [[ $CURVOL -ge 65536 ]]
    then
        CURVOL=65536
    fi
elif [[ $1 == "decrease" ]]
then
    CURVOL=$(($CURVOL - 1024))
    if [[ $CURVOL -le 0 ]]
    then
        CURVOL=0
    fi
elif [[ $1 == "mute" ]]
then
    if [[ $MUTE == "false" ]]
    then
        pactl set-sink-mute 1 1
        echo "true" > ~/.pulse/mute
    exit
    else
        pactl set-sink-mute 1 0
        echo "false" > ~/.pulse/mute
    exit
    fi
fi

pactl set-sink-volume 1 $CURVOL
echo $CURVOL > ~/.pulse/volume # Write the new volume to disk to be read the next time the script is run.
