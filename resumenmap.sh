#!/bin/bash
#Identify file with targets and if is a new scan or an already started scan

declare file
declare starting
declare limit

echo $file
echo $starting

#scanning input for paramaters	

while getopts "f:l:R:T:hAVS" opt; do
  case $opt in
    f)  #echo "-f was triggered, Parameter: $OPTARG" >&2
		file=$OPTARG;
		#Target file provided exists AND it's size is > 0?
			if test -s "$file"
			then 
				#echo "OK $file exists and is >0";
				#Read number of luunes of target files
				limit=$(cat $file | wc -l); 		
			else
				echo "ERROR $file does not exist or is empty"
			exit 1	
			fi			
	    ;;
	
	l)	echo "-l was triggered, Parameter: $OPTARG" >&2
	
			#Validating if $OPTARG" is an integer
			if [ -n "$OPTARG" ] && [ "$OPTARG" -eq "$OPTARG" ] && [ "$OPTARG" -gt 0 ] 2>/dev/null;  #if not null and <= self (integer?)
			then
				starting=$OPTARG
				echo "$starting is a positive integer";
				
						#Is starting line greater that the lines present in target file?	
						if [ $starting -gt $limit ]
						then 
							echo "ERROR! $file has $limit lines, but you indicated starting from line $starting";
							exit 0
						fi	
				
			else
				echo "ERROR! The line number parameter $OPTARG is NOT a positive integer"
				exit 1
			fi	
		;;
			

	h)  echo "resumenmap version 0.3";
		echo "";
		echo "A tool for resuming and reporting Nmap scans using a text file input with defined targets. Should be executed as root."; 
		echo "Please use a targets file with one target per line (host, range or network)."; 	
		echo "Once executed, a file with the line number of the current scan is stored in $FILENAME.current.log";
		echo "The Nmap scan will start reading the line indicated in the file FILENAME.current.log or the number indicated in the paramater -l (positivie integer) to start/resume a scan"	
		echo "The list of host with open ports, open ports and live hosts will be stored in multiple CVS output files."
		echo "";
		echo "SYNTAX: ./resumenmap.sh -f targets.txt -l Line_To_Start"
		echo "";
		exit 0	>&2;;  
		
	*) echo "SYNTAX: ./resumenmap.sh -f targets.txt -l Line_To_Start or ./resumenmap.sh -h for help" >&2
       exit 1;;		
	
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
	  
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

	if [[ $@ != *"-f"* ]] ; then
		echo "ERROR: No target file was indicated!" 
		echo "SYNTAX: ./resumenmap.sh -f targets.txt -l Line_To_Start or ./resumenmap.sh -h for help" >&2
		exit 0		
	fi



		if [[ $@ != *"-l"* ]]
		then
			echo "**Arguments: does not contain line starting number (-l)"
						
						if [ -e $file.current.log ]
						then
							starting=$(cat $file.current.log)
								
								#Validating if $starting" is an integer
								if [ -n "$starting" ] && [ "$starting" -eq "$starting" ] && [ "$starting" -gt 0 ] 2>/dev/null;  #if not null and <= self (integer?)
								then
									echo "starting line $starting in $file.current.log is a positive integer";
				
						#Is starting line greater that the lines present in target file?	
									if [ $starting -gt $limit ]
									then 
										echo "ERROR! $file has $limit lines, but $file.current.log starting line is $starting";
										exit 1
									fi	
								else
									echo "ERROR! The line number parameter $OPTARG is NOT a positive integer"
									exit 1
								fi
															
							echo "You have a current scan, we will continue scanning target number $(cat $file.current.log)"
							
						else
							echo "Starting the scan from the FIRST row in $file!"
							starting=1
						fi
		fi
	

resumenmap()
{
echo "Targets file list is" $file
echo "Networks to test" $limit;
echo "Starting with network" $starting;

for (( i=$starting; i <= $limit; i++ )); 
do echo "";
echo "#####################################################################" 
echo "";
echo "Testing network $i results wil be in file:" $file.resumenmap.$i; 
target=$(sed -n -e "$i p" $file);
echo "Target network is:" $target;
#Creating a $file.current.log file with the nbumber of the target test (number of line in the target file)
echo $i >$file.current.log;

##############################################################################

#This is the NMAP line that you might want to modify to tune your scan:
nmap -sS $target -oA $file.resumenmap.$i -F -Pn -T 4 --open -vvvv --min-rate 500 --max-rate 700 --min-rtt-timeout 100ms --min-hostgroup 256 --privileged -n;

###############################################################################

echo "";
echo "";
echo "#####################################################################" 
echo "";
done
}


#Call the funtion
#resumenmap target line 
#resumenmap $1 $2 $3 
resumenmap $file $start $limit


#Report section

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo ""
echo "#####################################################################"
echo ""
echo Results review:
echo ""
echo "#####################################################################"
echo ""
#Review Section
for (( i=1; i <= $limit; i++ )); 
do echo "Output of scan" $i $file.resumenmap.$i.gnmap:;
	if grep --quiet "Nmap done" $file.resumenmap.$i.gnmap; then
	echo "The scan $i has been compelted succcesfully:"
	tail -1 $file.resumenmap.$i.gnmap| GREP_COLOR='01;32'  grep --color "done"
	echo ""
	else 
	echo -e "The scan ${RED} $i ${NC} has ${RED} failed ${NC}"
	fi
echo ""
done
echo ""



echo "#####################################################################"
echo ""
echo Review of open ports:
echo ""
echo -e "${NC}List of ALL hosts and open ports will be stored in:${GREEN}" $file.resumenmap.openports.csv; 
echo ""
echo -e "${NC}List of hosts with open ports will be stored in:${GREEN}" $file.resumenmap.hosts.csv; 
echo ""
echo -e "${NC}List of open ports will be stored in:${GREEN}" $file.resumenmap.ports.csv; 
echo ""
echo -e "${NC}List of open ports with counts will be stored in:${GREEN}" $file.resumenmap.portscount.csv; 
echo ""
echo -e "${NC}#####################################################################"
echo ""
	grep "open/tcp"  $file.resumenmap.*.gnmap --color | tee $file.resumenmap.openports.csv
	cat $file.resumenmap.openports.csv | awk '{print $2}' > $file.resumenmap.hosts.csv
	cat $file.resumenmap.openports.csv |  grep -o -E "\b[0-9]{1,5}/open" --color |sort -n | uniq | sed 's/\/open//g' > $file.resumenmap.ports.csv
	awk -vORS=, '{ print $1 }' $file.resumenmap.ports.csv >  $file.resumenmap.portsoneline.csv
	cat $file.resumenmap.openports.csv | grep -o -E "\b[0-9]{1,5}/open" --color |sort -n | uniq -c | sed 's/\/open//g' | sort -r > $file.resumenmap.portscount.csv


