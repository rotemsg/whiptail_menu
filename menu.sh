#!/usr/bin/env bash


param=$1
last_cmd=0

inst_data="some text for the top left"
title="Select Action"

function main(){

    menu_options=()
    cat $0 | grep -A1 '^#func:' | grep -v '^-' | sed 's/(){//' | sed 's/^function //' | sed 's/^#func://' | while read l1; do read l2; echo "$l2 $l1"; done > menu.items.txt

    while read -r number text; do
        menu_options+=( ${number//\"} "${text//\"}" )
    done < menu.items.txt

    export inp=$(whiptail --backtitle "`date` $inst_data" --title "$title"  --cancel-button "Quit" --notags --default-item $last_cmd --menu "Choose an option"  25 78 16 "${menu_options[@]}" 3>&2 2>&1 1>&3-)

    [ ! $inp ] && exit

    last_cmd=$inp

    $inp

}



#func: "run top"
function run_top(){
  top
}

#func: "hellow world"
function hellow_world(){
  echo "hello world" | less
}


#func: "hellow world 2"
function hellow_world2(){
  echo "hello world 2"
  another_service_function
}

function another_service_function(){
    echo "this is a function not in the menu"
}


#func: "du in paralle"
function paralle_process(){
    paralle_process_job | sort -k1 | less -Si
}

function paralle_process_job(){

    ftemplate=/tmp/updater_s3_flie_times
    rm $ftemplate.*

    for k in /var/ /etc/ /usr/;
    do
        du -hs $k > $ftemplate.$name &
        echo $! >> $ftemplate.pids
    done

    while kill -0  $(cat $ftemplate.pids) 2> /dev/null; do sleep .1; done;
    rm $ftemplate.pids

    cat $ftemplate.*
}


#func: "Quit"
function quit(){
    exit 0
}

while :; do main;sleep 0.2; done

