#!/usr/bin/env bash


param=$1
last_cmd=0

inst_data="some text for the top left"
title="Select Action"

function main(){

    menu_options=()
#    grep '^#func:' workers.stats.sh | sed 's/#func://' > workers.stats.menu
    cat $0 | grep -A1 '^#func:' | grep -v '^-' | sed 's/(){//' | sed 's/^function //' | sed 's/^#func://' | while read l1; do read l2; echo "$l2 $l1"; done > menu.items.txt

    while read -r number text; do
        menu_options+=( ${number//\"} "${text//\"}" )
    done < menu.items.txt

    export inp=$(whiptail --backtitle "`date` $inst_data" --title $title  --cancel-button "Quit" --notags --default-item $last_cmd --menu "Choose an option"  25 78 16 "${menu_options[@]}" 3>&2 2>&1 1>&3-)

    [ ! $inp ] && exit

    last_cmd=$inp

    $inp

}



#func: "action number 1"
function any_func_name(){
  echo "hello world"
}


#func: "action number 2"
function another_func_name(){
  echo "hello world 2"
}


