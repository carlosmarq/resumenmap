#!/bin/bash
echo "resumeNmap v 0.1";
echo "";
echo "";
#Resume section
#Validation if a previous scan was executed

#file: File name with targets
file=targets.txt

if [ -e $file.current.log ]
then
    echo "You have a current scan, we will continue scanning target number $(cat $file.current.log)"
	S=$(cat $file.current.log)
else
    echo "Welcome!"
	S=1
fi

#Scanning section
#S: Start line
#E: End line (Numnber of lines in the file)

E=$(cat $file | wc -l); 
echo "Networks to test $E";
echo "Starting with network $S";

for (( i=$S; i <= $E; i++ )); 
do echo "";
echo "#####################################################################" 
echo "";
echo "Testing network $i results wil be in file:" $file.ALL.$i; 
target=$(sed -n -e "$i p" $file);
echo "Target network is:" $target;
#Creating a $file.current.log file with the nbumber of the target test (number of line in the target file)
echo $i >$file.current.log;
#This is the NMAP line that you might want to modify to tune your scan:
nmap -sS $target -oA $file.ALL.$i -p 0-65535 -Pn -T 5 --open -vvvv -n --min-rate 6500 --max-rate 7000 --min-rtt-timeout 100ms --min-hostgroup 256 --privileged;
echo "";
echo "";
echo "#####################################################################" 
echo "";
done

#Review section
echo ""
echo "#####################################################################"
echo ""
echo Results review:
echo ""
echo "#####################################################################"
echo ""
#Review Section
for (( i=1; i <= 7; i++ )); 
do echo "Output of scan" $i $file.ALL.$i.gnmap:;
	if grep --quiet "Nmap done" $file.ALL.$i.gnmap; then
	echo "The scan $i has been compelted succcesfully:"
	tail -1 $file.ALL.$i.gnmap| GREP_COLOR='01;32'  grep --color "done"
	echo ""
	else 
	echo "The scan $i has failed"
	fi
echo ""
done
echo ""
echo "#####################################################################"
echo ""
echo Review of open ports:
echo ""
echo "#####################################################################"
echo ""
	grep "open/tcp"  $file.ALL.*.gnmap --color | tee $file.ALL.openports.csv
