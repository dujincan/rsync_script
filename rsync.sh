#!/bin/bash

# rsync daemon service 
# 2018 11 07
# jason
# v1.0 
  
status1=$(ps -ef | grep "rsync --daemon" | grep -v 'grep' | wc -l) 
pidfile="/var/run/rsyncd.pid" 

function rsyncstart() { 
  
    if [ $status1 -eq 0 ];then 
  
        rm -rf $pidfile

        /usr/bin/rsync --daemon   
  
        status2=$(ps -ef | grep "rsync --daemon" | grep -v 'grep' | wc -l) 
          
        if [ $status2 -eq 1 ];then 
              
            echo "rsync service start.......OK" 
              
        fi 
  

    else 
            
         echo "rsync service is running !"    
  
    fi 
} 
  
function rsyncstop() { 
  
    if [ $status1 -eq 1 ];then 
      
        kill -9 $(cat $pidfile) 
  
        status2=$(ps -ef | egrep "rsync --daemon" | grep -v 'grep' | wc -l) 
  
        if [ $status2 -eq 0 ];then 
              
            echo "rsync service stop.......OK" 
        fi 
    else 
  
        echo "rsync service is not running !"    
  
    fi 
} 
  
  
function rsyncstatus() { 
  
  
    if [ $status1 -eq 1 ];then 
  
        echo "rsync service is running !"   
      
    else 
  
         echo "rsync service is not running !"  
  
    fi 
  
} 
  
function rsyncrestart() { 
  
    if [ $status1 -eq 0 ];then 
  
               echo "rsync service is not running..." 
  
               rsyncstart 
        else 
  
               rsyncstop
               

               rsyncstart
  
        fi       
}  
  
case $1 in 
  
        "start") 
               rsyncstart 
                ;; 
  
        "stop") 
               rsyncstop 
                ;; 
  
        "status") 
               rsyncstatus 
               ;; 
  
        "restart") 
               rsyncrestart 
               ;; 
  
        *) 
          echo 
                echo  "Usage: $0 start|stop|restart|status" 
          echo 
esac
