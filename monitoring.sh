#!/bin/bash //tells the OS to invoke the shell and run the following commands
arc=$(uname -a) // uname prints basic system information. -a displays all available information
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l) // search for the line "physical id" in /proc/cpuinfo and return them. Then sort sorts the response, removes the duplicates (uniq), does a count of the lines (wc) and prints the number of lines (-l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l) // replaces "physical id" in the previous command with "processor" and runs the command
fram=$(free -m | awk '$1 == "Mem:" {print $2}') // displays the memory usage in MB (-m). Print the figure in field 2 (print $2)
uram=$(free -m | awk '$1 == "Mem:" {print $3}') // displays the memory usage in MB (-m). Print the figure in field 3 (print $3)
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')
fdisk=$(df -Bg | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')
udisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}')
pdisk=$(df -Bm | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')
lvmt=$(lsblk | grep "lvm" | wc -l)
lvmu=$(if [ $lvmt -eq 0 ]; then echo no; else echo yes; fi)
ctcp=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
ulog=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip link show | awk '$1 == "link/ether" {print $2}')
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "	#Architecture: $arc
	#CPU physical: $pcpu
	#vCPU: $vcpu
	#Memory Usage: $uram/${fram}MB ($pram%)
	#Disk Usage: $udisk/${fdisk}Gb ($pdisk%)
	#CPU load: $cpul
	#Last boot: $lb
	#LVM use: $lvmu
	#Connexions TCP: $ctcp ESTABLISHED
	#User log: $ulog
	#Network: IP $ip ($mac)
	#Sudo: $cmds cmd"
