Bash script for resume Nmap scans. It read a list of targets in a text file that can be indicated with the parameter -f, take each line as a target (could be a host, network, URL or range) and execute a Nmap full TCP syn scan scan per line. 

If the task is interrupted, it will store in a file the number line that was currently being scanned. So once executed again, the scan will start scanning the last target that was being running. You can also indicate the starting line to read the TARGET file using the parameter -l (line is a positive integer).

USAGE:
./resumenmap.sh -f TARGET -l Line_To_Start [OPTIONAL]

TARGET is a plain text file, with one valid Nmap target per line (Either a host, range URL or a network). 

For example, if you have a 30 lines file scan called TARGET and you stop once target in row 15th was being scanned, the log file TARGET.current.log will store the number 15, and once executing resumenmap.sh -f TARGET, Nmap will continue scanning the target in line number 15. Once completed, the file TARGET.current.log will contain the integer 30.

Might help in long scan test with multiple targets that should be interrupted and resumed.

TIP: For big scans (like class A or B) subnetting in class C networks will be the best strategy.

Nmap scan will run with the following defaults: 

nmap  $target -oA $file.resumenmap.$i -p 0-65535 -Pn -T 4 --open -vvvv --min-rate 500 --max-rate 700 --min-rtt-timeout 100ms --min-hostgroup 256 --privileged -n;

#Default scans (hardcoded Nmap options):
 #-Pn: Treat all hosts as online -- skip host discovery
 #-F: Fast mode - Scan fewer ports than the default scan or -P 0-65535 ALL ports
 #--min-hostgroup/max-hostgroup <size>: Parallel host scan group sizes = 256
 #-oA <basename>: Output in the three major formats at once
 #--privileged: Assume that the user is fully privileged
 #-vvvv: Increase verbosity level (use -vv or more for greater effect)
 #--min-rate <number>: Send packets no slower than <number> per second = 500
 #--max-rate <number>: Send packets no faster than <number> per second = 700
 #--min-rtt-timeout: Specifies probe round trip time. =100ms
 #-T<0-5>: Set timing template (higher is faster) =4
 #--open: Only show open (or possibly open) ports
 #-n/-R: Never do DNS resolution/Always resolve -n

OUTPUT: 
Default Nmap, gnmap and xml output per scan. 
Grepable output of hosts and open ports in: TARGET.resumenmap.#.openports.csv 
Grepable output of hosts In: TARGET.resumenmap.#.hosts.csv 
Grepable output of open ports in: TARGET.resumenmap.#.ports.csv 
Grepable output of open ports in one line and comma separated in: TARGET.resumenmap.#.portsoneline.csv 
Grepable output of IP with the count of open ports in: TARGET.resumenmap.#.hostsportcount.csv 

Current line being scanned TAREGETFILE.current.log

Nmap licensing and details can be found in: https://nmap.org/
Tested on Nmap 6.X and 7.X in Debian environments. Should be run as root (or remove the --privileged Nmap parameter).



