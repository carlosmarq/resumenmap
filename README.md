# Resumenmap v1.0

Bash script for resume Nmap scans. Intended to be used in segmentation tests.

## Usage

The script reads a list of targets in a text file that can be indicated with the parameter -f, take each line as a target (could be a host, network, URL or range) and execute a Nmap full TCP syn scan scan per line. 

If the task is interrupted, it will store in a file the number line that was currently being scanned. So once executed again, the scan will start scanning the last target that was being running. You can also indicate the starting line to read the TARGET file using the parameter -l (line is a positive integer).

```
./resumenmap.sh -f TARGET -l Line_To_Start [OPTIONAL]

```

TARGET is a plain text file, with one valid Nmap target per line (Either a host, range URL or a network). 

For example, if you have a 30 lines file scan called TARGET and you stop once target in row 15th was being scanned, the log file TARGET.current.log will store the number 15, and once executing resumenmap.sh -f TARGET, Nmap will continue scanning the target in line number 15. Once completed, the file TARGET.current.log will contain the integer 30.

Might help in long scan test with multiple targets that should be interrupted and resumed.

TIP: For big scans (like class A or B) subnetting in class C networks will be the best strategy.

Nmap scan will run with the following defaults: 

```
nmap  $target -oA $file.resumenmap.$i -p 0-65535 -Pn -T 4 -sV --open -vvvv --min-rate 5500 --max-rate 5700 --min-rtt-timeout 100ms --privileged -n;

```
### Default scans (hardcoded Nmap options):

 * -Pn: Treat all hosts as online -- skip host discovery
 * Scan all 0-65535 TCP ports (default SYN scan)
 * -sV Fingerprint identified services
 * -oA <basename>: Output in the three major formats at once
 * --privileged: Assume that the user is fully privileged
 * -vvvv: Increase verbosity level 
 * --min-rate <number>: Send packets no slower than <number> per second = 5500
 * --max-rate <number>: Send packets no faster than <number> per second = 5700
 * --min-rtt-timeout: Specifies probe round trip time. = 100ms
 * -T<0-5>: Set timing template (higher is faster) = 4
 * --open: Only show open (or possibly open) ports
 * -n/-R: Never do DNS resolution/Always resolve -n

### Output

Default Nmap, gnmap and xml output per scan, using the name format TARGET.resumenmap.#

### Data processing

* Grepable output of hosts and open ports in: TARGET.resumenmap.#.openports.csv 
* Grepable output of hosts In: TARGET.resumenmap.#.hosts.csv 
* Grepable output of open ports in: TARGET.resumenmap.#.ports.csv 
* Grepable output of open ports in one line and comma separated in: TARGET.resumenmap.#.portsoneline.csv 
* Grepable output of IP with the count of open ports in: TARGET.resumenmap.#.hostsportcount.csv 
* Multiple files named $port.ips, listin all IP hosts that have an specific port open. 
* Executive results brief in English resuming the statistics of the scan in TARGET.resumenmap.#.report.txt
* System network configuration (ifconfig, route -evn) will be stored in TARGET.resumenmap.#.network.txt

* Current line being scanned TARGETFILE.current.log

### Testing results file

Testing results file will looks like this:
```
SEGMENTATION TESTING RESULTS 
 
The scan was completed on Fri 17 Apr 14:28:58 BST 2020 with the following results: 
54 systems and 5 TCP services were reachable from the point of view of the testing system. 

The reachable services include the flowing Transmission Control Protocol (TCP) ports:  

22,443,3389,7001,7002,  

The top 10 systems with the most open ports were:  

IP/hostname   Number of Open Ports:
10.10.10.101	3
10.10.10.100	3
10.10.10.207	1
10.10.10.117	1
10.10.10.115	1
10.10.10.107	1
10.10.10.87	 1
10.10.10.86	 1
10.10.10.85	 1
10.10.10.84	 1  

The top 10 TCP reachable services were:  

Services   TCP Port number: 
     46 443
      5 3389
      3 22
      2 7001
      2 7002  
```

## License
Apache License Version 2.0, January 2004
Nmap licensing and details can be found in: https://nmap.org/

### Requirements

Nmap > 6.X
Tested on Nmap 6.X and 7.X in Debian environments. Should be run as root (or remove the --privileged parameter).



