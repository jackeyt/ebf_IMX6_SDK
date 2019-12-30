#!/bin/bash
range=4095  
max_vol=3.3



while true
do
    echo "Press Ctrl+C for quit"
    Conversion_Value=$(cat /sys/bus/iio/devices/iio\:device0/in_voltage3_raw)
    echo The Conversion Value is : $Conversion_Value
    vol=$(echo "scale=4;$Conversion_Value*$max_vol/$range" | bc)
    echo The current AD value = $vol V
    sleep 1s
done
