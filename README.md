![image](https://github.com/user-attachments/assets/edfe3a05-3a62-4dd5-8a77-8d2e702642a4)

# "Recontool2"


## Geting Started
### Short Description
>This tool addresses the first step of the cyberattack cycle, known as "Reconnaissance."<br/>
>Orchestrates and leverages open-source techniques and tools to gather information, starting with a domain name, uncovering related subdomains, identifying their corresponding IP addresses, and finally scanning for open ports to reveal running services.<br/>
>The last step is the Visualization of the results using GDBMS graphs in order to depict schematically what is not obvious by reading text reports.<br/>
**>My intention was to create a tool that works as automated as possible, from the beggining to the end, without the need for interaction with the user all time.**<br/>

### Environment of Development and Operation
>This tool has been developed in Linux OS, "Ubuntu version 22.04.4 LTS."<br/>
>We used BASH shell scripting language ("GNU bash, version 5.1.16") and Python ("Python 3.10.12") programming language.<br/>
>We also used the “Cypher query Language” of Neo4j GDBMS, the “Neo4j Browser” and the “Neo4j Server” on which runs the DBMS is version 5.21.0.<br/>


### Dependencies
For the implementation of this project we orchestrated a variety of carefully chosen open-source tools and libraries. <br/>

#### Tools
- Python3 ver. 3.10.12
- Amass v. 3.19.2
- Nmap v. 7.80
- Neo4j v. 5.21.0 GDBMS

#### Python modules (Part of Python's Standard Library)
- sys
- socket
- re
- subprocess
- os
- ipaddress
- random
- datetime (from datetime)
- time
- threading
- select
- csv
- xml.etree.ElementTree

#### Libraries
- requests
- validators
- tldextract
- pandas
- py2neo


### Installing
The tool has been tested and validated in a few versions of the abovementioned distro Linux OS.<br/> 
It will be tested as soon as possible in more platforms but till then...... it's up to you.<br/>


#### Install the necessary "building blocks"
- install python simply with "sudo apt install python3"
- Install 'nmap' (on ubuntu) using the instruction of nmap_install.txt
- install 'amass' using the instructions of amass_install.txt
- install 'Neo4j' GDBMS using the instructions of neo4j_install.txt


#### Install the necessary libraries
pip install -r requirements.txt



### Executing the Program
**WARNING: Don't forget to use a VPN connection...**

-Usage: "./recontool2.sh [OPTIONS]"

-OPTIONS
- -h,      Display this help message
- -d,      insert the domain for investigation (required)
- -a,      Active mode enabled. Performs deep DNS enumeration techniques like zone transfers, port scanning of SSL/TLS, certificates grabbing etc. (*CAUTION: More than usually time needed)
- -v,      Enable verbose mode
- -b,      Brute force SubDomain Enumeration with default dictionary. Use along with -w flag to use your own wordlist
- -w,      Path to use wordlist for sub-domains brute forcing
  






### Help
- If you encounter any issues with specific versions of libraries, you can adjust them in the requirements.txt file by specifying a version or using version specifiers like >=, <=, or ~=. 
- For example:
requests>=2.25.0

- Make sure that pip is up to date to avoid compatibility issues:
pip install --upgrade pip


### Authors
gtasCyber


