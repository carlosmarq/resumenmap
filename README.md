# resumenmap
Bash script for resume nmap scans. It read a list of targets in a text file (targets.txt), and execue one Nmap full TCP syn scan scan per line to the specified target. If the task is interrupted, it will store in a file the number line that was currently being scanned. So once executed again, the scan will start scaning the last target that was scanned. Might help in long scan test with multiple targets that should be interrupted and resumed.

Tested on Nmap 7.40 in Debian enviroments

Usage: ./resumenmap.sh
List of targets should be written in targets.txt file, one per line (Either a host or a network).
You might want to use a host or class (maximun a C netwok) per line. For big scans (like scans, like class A or B) subnetting will be the best strategy.


Nmap scan will ru nwith the following defaults: 
All TCP ports, SYN scan, no Pong, insane 
nmap -sS TARGET -oA TAREGETFILE.ALL.# -p 0-65535 -Pn -T 5 --open -vvvv -n --min-rate 6500 --max-rate 7000 --min-rtt-timeout 100ms --min-hostgroup 256 --privileged

Output:
Default Nmap, gnmap and xml output per scan
Grepable output of open ports TAREGETFILE.ALL.#.openports.csv
Curren line being scanned TAREGETFILE.current.log


Nmap licensing and details can be found in: https://nmap.org/ 
