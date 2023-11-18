#!/bin/bash


process1="process1.sh"
#process2="process2.sh"


nohup ./$process1 &>/dev/null &


#nice -n 15 ./$process2 &


pid1=$!
#pid2=$!


echo "se"
restart_process() {
  local pid=$1
  local process=$2
  echo "Restarting $process (PID $pid)..."
  kill -TERM $pid
  sleep 1
  nohup ./$process &>/dev/null &
  eval "$pid=$!"
  echo "$(date): $process (PID $pid) restarted." >> restart.log
}

# Monitor the memory and CPU usage of both processes
while true; do

  mem1=$(ps -p $pid1 -o %mem | awk 'NR==2')
 # mem2=$(ps -p $pid2 -o %mem | awk 'NR==2')
  if (( $(echo "$mem1 > 80.0" | bc -l) )); then
    restart_process $pid1 $process1
    echo "2"
  fi
 # if (( $(echo "$mem2 > 80.0" | bc -l) )); then
  #  restart_process $pid2 $process2
   # echo "3"
 # fi


  cpu1=$(ps -p $pid1 -o %cpu | awk 'NR==2')
  #cpu2=$(ps -p $pid2 -o %cpu | awk 'NR==2')
  if (( $(echo "$cpu1 > 50.0" | bc -l) )); then
    sleep 60
    if (( $(echo "$cpu1 > 50.0" | bc -l) )); then
      restart_process $pid1 $process1
    fi
  fi
 # if (( $(echo "$cpu2 > 50.0" | bc -l) )); then
  #  sleep 60
   # if (( $(echo "$cpu2 > 50.0" | bc -l) )); then
    #      restart_process $pid2 $process2
   # fi
 # fi

done

