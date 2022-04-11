#!/bin/bash //tells the OS to invoke the shell and run the following commands
arc=$(uname -a) // uname prints basic system information. -a displays all available information
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l) // search for the line "physical id" in /proc/cpuinfo and return them. Then sort sorts the response, removes the duplicates (uniq), does a count of the lines (wc) and prints the number of lines (-l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l) // look for lines that start with "processor". count the lines and return them.
fram=$(free -m | awk '$1 == "Mem:" {print $2}') // gets the memory usage (free) in MB (-m). Print the figure in field 2 (print $2) of line Mem.
uram=$(free -m | awk '$1 == "Mem:" {print $3}') // gets the memory usage (free) in MB (-m). Print the figure in field 3 (print $3) of line Mem.
pram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')// get the memory usage (free) then divide field 3 by field 2, multiply by 100 and print the result to two decimal places.
fdisk=$(df -BG | grep '^/dev/' | grep -v '/boot$' | awk '{ft += $2} END {print ft}')// df is disk free, -BG shows the result in GB's. look for lines that have /dev/ in them. ignore (-v) lines that have /boot in them. total the amounts in column 2 and print them.
udisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} END {print ut}') // df is disk free, -BM shows the result in MB's. look for lines that have /dev/ in them. ignore (-v) lines that have /boot in them. total the amounts in column 3 and print themn.
pdisk=$(df -BM | grep '^/dev/' | grep -v '/boot$' | awk '{ut += $3} {ft+= $2} END {printf("%d"), ut/ft*100}')// df is disk free, -BM shows the result in MB's. look for lines that have /dev/ in them. ignore (-v) lines that have /boot in them. total the amounts in column 3 and column 2. divide column 3 by column 2, multiply by 100 and print as a whole number.
cpul=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')// top displays CPU utilisation. -bn1 shows the first iteration. look for lines that start with Cpu. cut column 9. use this information to print to one decimal place the percentage of field 1 plus 3.
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')// who -b will show the date and time of the last re-boot. print field 3 and 4 with a space between them.
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi) //is lvm active? return yes if true no if false. fi closes the if statement.
ctcp=$(ss -neopt state established | wc -l)// ss shows socket statistics, -neopt state established will show you only TCP sessions established. count and return the number of lines.
ulog=$(users | wc -w)// the users command will print the users logged in on a single line. the wc -w command will count the number of words and return the total
ip=$(hostname -I)// hostname will return the current host name and domain name on a line. -I will show network address of the host
mac=$(ifconfig -a | grep "ether" | awk '{print $2}') // show MAC (Media Access Control) address of your server
cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)// journalctl gets all the journal entries for sudo, filter by COMMAND to get all commands run by sudo then count the lines and return
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
