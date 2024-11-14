# Author: George Tasios
# FileName: pyToNeo.py

import pandas as pd
from py2neo import Graph, Node, Relationship
import os
import sys
import csv


# first argument is the domain name
target = sys.argv[1]

# File paths
subdomains_path = 'report/'+target+'/neo4jVisuals/subdomains.csv'
unique_ips_path = 'report/'+target+'/neo4jVisuals/uniqueips.csv'
domain_ips_path = 'report/'+target+'/neo4jVisuals/domain_ips.csv'
services_path = 'report/'+target+'/neo4jVisuals/services.csv'
open_ports_path = 'report/'+target+'/neo4jVisuals/open_ports.csv'

# Checks if exists anything in a file
def is_file_empty(file_path):
    return os.path.getsize(file_path) == 0


# Reads the domain-target ($FINALDOMAIN valiable)
domain = sys.argv[1]

# Read the CSV files
subdomains_df = pd.read_csv(subdomains_path)
unique_ips_df = pd.read_csv(unique_ips_path)
domain_ips_df = pd.read_csv(domain_ips_path)
open_ports_df = pd.read_csv(open_ports_path)
# Checks if exist results of services in 'services.csv' file
if not is_file_empty(services_path):
    services_df = pd.read_csv(services_path)


# Connect to Neo4j (make sure Neo4j is running and accessible)
graph = Graph("bolt://localhost:7687", auth=("neo4j", "neo4j12345"))

# Clear existing graph data
graph.delete_all()

# Creation of main node of the target-domain
domain_node = Node("Domain", name=domain)
graph.create(domain_node)


# Create subdomain nodes and relationships
for _, row in subdomains_df.iterrows():
    subdomain_node = Node("Subdomain", name=row['subdomain'])
    graph.create(subdomain_node)
    if domain_node:
        contains_subdomain_rel = Relationship(domain_node, "ContainsSubdomain", subdomain_node)
        graph.create(contains_subdomain_rel)


# Create ips unique nodes
for _, row in unique_ips_df.iterrows():
    ipname = str(row['ip'])
    ip_node = Node("IP", address=row['ip'])
    graph.create(ip_node)


# Create IP-Subdomains relationships
for _, row in domain_ips_df.iterrows():
    current_subdomain_node = graph.nodes.match("Subdomain", name=row['subdomain']).first()
    # List with IP nodes
    ip_nodes = list(graph.nodes.match("IP", address=row['ip']))
    for node_a in ip_nodes:
        common_ip = str(node_a['address'])
        if row['ip'] == common_ip:
                resolve_to_rel = Relationship(current_subdomain_node, "ResolveTo", node_a)
                graph.create(resolve_to_rel) 
    

if is_file_empty(services_path):
    exit(1)
else:
    # Create service nodes and relationships
    for _, row in services_df.iterrows():
        ip_node = graph.nodes.match("IP", address=row['address']).first()
        if ip_node:
            service_node = Node("Service", port=row['portnum'], protocol=row['protocol'], state=row['portState'], cpe=row['CPE'], 
                                service_name=row['servName'], confidence=row['servConfidence'], method=row['scanMethod'], product=row['Product'])
            graph.create(service_node)
            contains_service_rel = Relationship(ip_node, "ContainsService", service_node)
            graph.create(contains_service_rel)


