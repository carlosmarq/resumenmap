# resumenmap
Bash script for resume nmap scans 
Tested on Nmap 7.40 in Debian enviroments

Usage:
List of targets files should be written in targets.txt file, one per line.
You hsould be able to run nmap with privileges access (root)

Nmap scan will ru nwith the following defaults: 
All TCP ports, SYN scan, no Pong, insane 
nmap -sS TARGET -oA TAREGETFILE.ALL.# -p 0-65535 -Pn -T 5 --open -vvvv -n --min-rate 6500 --max-rate 7000 --min-rtt-timeout 100ms --min-hostgroup 256 --privileged

Output:
Default Nmap, gnmap and xml output per scan
Grepable output of open ports TAREGETFILE.ALL.#.openports.csv
Curren line being scanned TAREGETFILE.current.log


Nmap licensing and details can be found in: https://nmap.org/ 
