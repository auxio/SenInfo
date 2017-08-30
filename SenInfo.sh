#!/bin/bash
###########################################################
# SenInfo > Information about your Sentora install        #
# Copyright(C) 2017                                       #
# License: Apache License 2.0                             #
# Github: https://github.com/auxio/SenInfo                #
###########################################################
# bash <(curl -L -Ss https://auxio.github.io/SenInfo/SenInfo.sh)

# SenInfo version
SENINFO_VERSION="0.1Alpha"

# saving start time
stime=$(date +"%m-%d-%Y %T")
cstime=`date +%s`

#Centos and Umbunto are differend!
if [ -f /etc/centos-release ]; then
    OS="CentOs"
elif [ -f /etc/lsb-release ]; then
    OS="Ubuntu"
else
    echo "Sorry, your system is not supported by SenInfo." 
	exit 1
fi

clear
echo "============================================================"
echo "Information about your Sentora install"
echo "Seninfo v$SENINFO_VERSION"
echo "Have patience, it will take approximately 1 minute."
echo "============================================================"

echo "Starting gethering information about your system..."

echo "(1/24)  Creating directory with unique name..."
UniqueDirName=SenInfo-`date +%s`
DirDirectory=root
SenInfoDirname=/$DirDirectory/$UniqueDirName
mkdir -p $SenInfoDirname;

echo "(2/24)  Searching CPU model..."
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
#cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
#cname=$( cat /proc/cpuinfo |grep -m 1 "model name"|cut -d' ' -f 4- )

echo "(3/24)  Searching Number of cores..."
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
#cores=$(cat /proc/cpuinfo |grep -m 1 "model name"|cut -d' ' -f 4-)

echo "(4/24)  Searching CPU frequency..."
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
#freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
#freq=$( cat /proc/cpuinfo |grep -m 1 "cpu MHz"|cut -d' ' -f 3- )


echo "(5/24)  Searching Operating System..."
opsy=$( cat /etc/issue.net | awk 'NR==1 {print}' ) # Operating System & Version

echo "(6/24)  Searching Architecture..."
arch=$( uname -m )
#arch=$( uname -i )
# Architecture in Bit
lbit=$( getconf LONG_BIT )
# Kernel
kern=$( uname -r )

echo "(7/24)  Searching Hostname..."
hn=$( hostname )

echo "(8/24)  Searching Public IPv4..."
ipv4=$(wget -qO- http://api.sentora.org/ip.txt)

echo "(9/24)  Searching Total memory..."
tram=$(grep MemTotal /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024^2" | bc)
#tram=$(cat /proc/meminfo | grep MemTotal | cut -d' ' -f 2- | sed 's/ //g')
#tram=$( free -m | awk 'NR==2 {print $2}' )

echo "(10/24) Searching Free memory..."
fram=$(grep MemFree /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024^2" | bc)
#fram=$(cat /proc/meminfo | grep MemFree | cut -d' ' -f 2- | sed 's/ //g')
#fram=$( cat /proc/meminfo | grep MemFree|cut -d' ' -f 2- | awk '{ sum=$1 ; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}' )
#fram=$( ( cat /proc/meminfo | awk 'NR==2 {print $2}' ) | awk '{ sum=$1 ; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}' )

echo "(11/24) Searching Total SWAP..."
swap=$(grep SwapTotal /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024^2" | bc)
#swap=$(cat /proc/meminfo | grep SwapTotal | cut -d' ' -f 2- | sed 's/ //g')
#swap=$( free -m | awk 'NR==4 {print $2}' )

echo "(12/24) Searching Free SWAP..."
fswap=$(grep SwapFree /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024^2" | bc)
#fswap=$(cat /proc/meminfo | grep SwapFree | cut -d' ' -f 2- | sed 's/ //g')
#fswap=$( ( cat /proc/meminfo | awk 'NR==16 {print $2}' ) | awk '{ sum=$1 ; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}' )
#fswap=$( cat /proc/meminfo | grep MemFree|cut -d' ' -f 2- | awk '{ sum=$1 ; hum[1024**3]="Gb";hum[1024**2]="Mb";hum[1024]="Kb"; for (x=1024**3; x>=1024; x/=1024){ if (sum>=x) { printf "%.2f %s\n",sum/x,hum[x];break } }}')

echo "(13/24) Searching uptime..."
up=$(uptime | awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }' | sed 's/^[ \t]*//;s/[ \t]*$//' | cut -f1 -d",")
#up=$( uptime | awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }' | sed 's/^[ \t]*//;s/[ \t]*$//' )
#up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')

echo "(14/24) Searching HDD/SSD space..."
disk=$( df -h | awk 'NR==2 {print $2}'| sed 's/.$//' )

echo "(15/24) Searching Used HDD/SSD space..."
udisk=$( df -h | awk 'NR==2 {print $3}' | sed 's/.$//' )
updisk=$( df -h | awk 'NR==2 {print $5}' )

#echo "(16/24) Searching Free HDD/SSD space..."
#fdisk=$( df -h | awk 'NR==2 {print $4}' )

echo "(16/24) Testing I/O Speed..."
io1=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
io2=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
io3=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
# Calculating avg I/O (better approach with awk for non int values)
ioraw1=$( echo $io1 | awk 'NR==1 {print $1}' )
ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
ioall=$( awk 'BEGIN{print '$ioraw1' + '$ioraw2' + '$ioraw3'}' )
ioavg=$( awk 'BEGIN{print '$ioall'/3}' )
#io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' )
#io="Skip"

echo "(7/24) Testing Download Speed..."
speedtest=$( wget -O /dev/null http://cachefly.cachefly.net/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
#speedtest="Skip"

echo "(18/24) Testing Ping..."
ping=$( ping -c 3 cachefly.cachefly.net 2>&1 )
#ping=$( ping -c 10 cachefly.cachefly.net 2>&1 | awk 'NR==14' )
#ping="Skip"

mkdir -p $SenInfoDirname/sentora;
echo "(19/24) Backing up Sentora config - Apache config file into $SenInfoDirname." 
cp /etc/sentora/configs/apache/httpd.conf $SenInfoDirname/sentora/httpd.conf

echo "(20/24) Backing up Sentora config - virtual host file into $SenInfoDirname."
cp /etc/sentora/configs/apache/httpd-vhosts.conf $SenInfoDirname/sentora/httpd-vhosts.conf

echo "(21/24) Backing up Sentora config - FTP config file into $SenInfoDirname."
cp /etc/sentora/configs/proftpd/proftpd-mysql.conf $SenInfoDirname/sentora/proftpd-mysql.conf

mkdir -p $SenInfoDirname/apache;
echo "(22/24) Backing up Apache log file into $SenInfoDirname."
if [ $OS="CentOs" ]; then
	cp /var/log/httpd/error_log $SenInfoDirname/apache/error.log
elif [ $OS="Ubuntu" ]; then
	cp /var/log/apache2/error.log $SenInfoDirname/apache/error.log
else
	echo "Whoops, something went horribly wrong!" 
	exit 1
fi

mkdir -p $SenInfoDirname/mysql;
echo "(23/24) Backing up Mysql log file into $SenInfoDirname."
if [ $OS="CentOs" ]; then
	cp /var/log/mysqld.log $SenInfoDirname/mysql/mysqld.log
elif [ $OS="Ubuntu" ]; then
	cp /var/log/mysql/error.log $SenInfoDirname/mysql/mysqld.log
else
	echo "Whoops, something went horribly wrong!" 
	exit 1
fi

echo "(24/24) Writing information to SenInfo.txt ..."
echo "" 
# Output of results
echo "System Info" | tee -a $SenInfoDirname/SenInfo.txt
echo "============================================" | tee -a $SenInfoDirname/SenInfo.txt
echo "Processor	: $cname" | tee -a $SenInfoDirname/SenInfo.txt
echo "CPU Cores	: $cores" | tee -a $SenInfoDirname/SenInfo.txt
echo "Frequency	: $freq MHz" | tee -a $SenInfoDirname/SenInfo.txt
echo "Memory		: $tram GB" | tee -a $SenInfoDirname/SenInfo.txt
echo "Free memory     : $fram GB" | tee -a $SenInfoDirname/SenInfo.txt
echo "Swap		: $swap GB" | tee -a $SenInfoDirname/SenInfo.txt
echo "Free swap       : $fswap GB" | tee -a $SenInfoDirname/SenInfo.txt
echo "HDD/SSD size    : $disk GB" | tee -a $SenInfoDirname/SenInfo.txt
echo "HDD/SSD used    : $udisk GB ($updisk)" | tee -a $SenInfoDirname/SenInfo.txt
#echo "HDD/SSD free    : $fdisk" | tee -a $SenInfoDirname/SenInfo.txt
echo "Uptime		: $up" | tee -a $SenInfoDirname/SenInfo.txt
echo "OS		: $opsy" | tee -a $SenInfoDirname/SenInfo.txt
echo "Arch		: $arch ($lbit Bit)" | tee -a $SenInfoDirname/SenInfo.txt
echo "Kernel		: $kern" | tee -a $SenInfoDirname/SenInfo.txt
echo "Hostname	: $hn" | tee -a $SenInfoDirname/SenInfo.txt
echo "Public IPv4	: $ipv4" | tee -a $SenInfoDirname/SenInfo.txt
echo "" | tee -a $SenInfoDirname/SenInfo.txt

echo "Speedtest:" | tee -a $SenInfoDirname/SenInfo.txt
echo "===========" | tee -a $SenInfoDirname/SenInfo.txt
echo "Disk:" | tee -a $SenInfoDirname/SenInfo.txt
echo "-----------" | tee -a $SenInfoDirname/SenInfo.txt
echo "I/O (1st run)	: $io1" | tee -a $SenInfoDirname/SenInfo.txt
echo "I/O (2nd run)	: $io2" | tee -a $SenInfoDirname/SenInfo.txt
echo "I/O (3rd run)	: $io3" | tee -a $SenInfoDirname/SenInfo.txt
echo "Average I/O	: $ioavg MB/s" | tee -a $SenInfoDirname/SenInfo.txt
echo "" | tee -a $SenInfoDirname/SenInfo.txt

echo "Download" | tee -a $SenInfoDirname/SenInfo.txt
echo "-----------" | tee -a $SenInfoDirname/SenInfo.txt
echo "cachefly CDN	: $speedtest" | tee -a $SenInfoDirname/SenInfo.txt
echo "" | tee -a $SenInfoDirname/SenInfo.txt

echo "Ping" | tee -a $SenInfoDirname/SenInfo.txt
echo "-----------" | tee -a $SenInfoDirname/SenInfo.txt
echo "$ping" | tee -a $SenInfoDirname/SenInfo.txt
echo "" | tee -a $SenInfoDirname/SenInfo.txt

echo "=======================================================" | tee -a $SenInfoDirname/SenInfo.txt
echo ""

echo "Zipping $SenInfoDirname directory."
cd /$DirDirectory/
zip -q -r $UniqueDirName{.zip,}

echo "Removing $SenInfoDirname directory."
sudo rm -rf $SenInfoDirname

echo "We are done, all information is gathered."
echo "You may use $SenInfoDirname.zip on the Sentora forum to provide extra information about your problem."