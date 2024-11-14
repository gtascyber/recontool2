#!/bin/bash

# Author: George Tasios
# FileName: checkservices.sh

input_file=$1
output_XML=$2
final_output_CSV=$3
user_agents_file="core_useragents.txt"
useragent="Mozilla/5.0"
random_user_agent=""
isipv6=False


#insert file containing functions to call
source ./func.sh


#Initializing variables
ip=""
ports=""


test_ip() {
    # Check if the ip variable contains an IPv4 address
    if [[ "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
        echo "$ip is an IPv4 address."
    # Check if the ip variable contains an IPv6 address
    elif [[ "$ip" =~ ^([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}$|^([0-9a-fA-F]{1,4}:){1,7}:|^([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}$|^([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}$|^([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}$|^([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}$|^([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}$|^[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})$|^:((:[0-9a-fA-F]{1,4}){1,7}|:)$|^fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}$|^::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])$|^([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])$ ]]; then
        echo "$ip is an IPv6 address."
        isipv6=True #Variable used as a flag, noting that the current ip is IPv6 version
    else
        echo "$ip is not a valid IP address."
    fi
}


print_ports() {
    local num=0
    for i in ${ports//,/ }
    do
      ((num++))
      echo -e "No $num opened port is: $i"
    done
}


select_random_useragent() {
    #Checks if file with user agents exists
    if [ ! -f "$user_agents_file" ]; then
        echo "File with user agents not found: $user_agents_file"
        random_user_agent="Mozilla/5.0"
        echo "setting default user agent: $useragent"
        exit 1
    fi
    # Select randomly a user agent from the file
    random_user_agent=$(shuf -n 1 "$user_agents_file")
    echo -e "Random user agent selected is:\n$random_user_agent\n"
}



nmapipv4() {
    # Creating local array variable where the ports will be stored as an array and not as a comma separated list
    local ports_array
    
    # convert comma separated ports from $ports into array whioch contains the ports
    IFS=',' read -r -a ports_array <<< "$ports"
    
    for port in "${ports_array[@]}"; do
        # function that selects Random user agent from file-list
        select_random_useragent
        # nmap command using custom selected user agent
        nmap -Pn -sV -T4 -n --script http-methods --script-args http.useragent="$random_user_agent" $ip -p "$port" -oX $output_XML
        # Here will run the XML parsing procedure ('XMLprocess.py' script) and elements will be appended to final csv output file (3rd argument of 'checkservices.sh')
        python3 XMLprocess.py $output_XML $final_output_CSV
    done
    
    
}


nmapipv6() {
    # Creating local array variable where the ports will be stored as an array and not as a comma separated list
    local ports_array
    
    # convert comma separated ports from $ports into array whioch contains the ports
    IFS=',' read -r -a ports_array <<< "$ports"
    
    for port in "${ports_array[@]}"; do
        # function that selects Random user agent from file-list
        select_random_useragent
        # nmap command using custom selected user agent
        nmap -Pn -sV -T4 -6 -n --script http-methods --script-args http.useragent="$random_user_agent" $ip -p "$port" -oX $output_XML
        # Here will run the XML parsing procedure ('XMLprocess.py' script) and elements will be appended to final csv output file (3rd argument of 'checkservices.sh')
        python3 XMLprocess.py $output_XML $final_output_CSV
    done
   
    
}

# In the 1st step of this file the following function is executed. Checks if nmap tool is installed. If not, the script stops (this function exists in func.sh)
nmapCheck



# Reads the whole file with the IPs and the ports.
# Iterates EVERY LINE and stores the IP in the 'ip' variable and the ports in the 'ports' variable
while IFS=',' read -r ip ports
do
    isipv6=False
    #echo "$ip"
    #echo "$ports"
    test_ip #Checks the current selected IP and checks if it is ipv6. The 'test_ip' function an ipv6 found sets the variable/flag==True
    print_ports
    if [[ $isipv6 == True ]]; then
        echo -e "\nfound IPv6\n"
        nmapipv6
    elif [[ $isipv6 == False ]]; then
        echo -e "\nfound IPv4\n"
        nmapipv4
    fi
done < $input_file









