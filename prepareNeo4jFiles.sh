#!/bin/bash

# Author: George Tasios
# FileName: prepareNeo4jFiles.sh

# Creation of subfolder for the visualization graphs of the current domain
# visualsfoldername="${FINALDOMAIN}_neo4jVisuals"
mkdir -p -m 777 report/$1/neo4jVisuals


# convert results files of subdomains, ips, ports, services etc into csv files with header suitables to import in neo4j
echo "subdomain" > report/$1/neo4jVisuals/subdomains.csv
cat $2 >> report/$1/neo4jVisuals/subdomains.csv
csv_subdomains_path="report/$1/neo4jVisuals/subdomains.csv"

echo "ip" > report/$1/neo4jVisuals/uniqueips.csv
cat $3 >> report/$1/neo4jVisuals/uniqueips.csv
csv_uniqueips_path="report/$1/neo4jVisuals/uniqueips.csv"

echo "subdomain,ip" > report/$1/neo4jVisuals/domain_ips.csv
cat $4 >> report/$1/neo4jVisuals/domain_ips.csv
csv_domain_ips_path="report/$1/neo4jVisuals/domain_ips.csv"
content=$(cat "report/$1/neo4jVisuals/domain_ips.csv")
modif=${content// /,}
echo "$modif" > "report/$1/neo4jVisuals/domain_ips.csv"


cat $5 > report/$1/neo4jVisuals/services.csv

# Convert open ports csv results file into a suitable to parse in neo4j

echo "IP,Ports" > "report/$1/neo4jVisuals/open_ports.csv"
# read the csv input file line by line
while IFS= read -r line; do
    # Extract IPs and the ports
    ip=$(echo $line | cut -d',' -f1)
    ports=$(echo $line | cut -d',' -f2- | tr -d '\n' | tr -d '\r')
    modified_ports="[$ports]"
    
    # write the formatted data to the open_ports.csv file
    echo "$ip,\"$modified_ports\"" >> "report/$1/neo4jVisuals/open_ports.csv"
done < $6

