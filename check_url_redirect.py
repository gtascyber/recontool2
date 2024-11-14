# Author: George Tasios
# FileName: check_url_redirect.py

import sys
import requests
import validators
import socket
import re
import subprocess
import os


#The following code checks if the URL is in the right Format and if it redirects to another url
#then shows the final URL where it ends

#FUNCTION checks URL format 
def check_hostname(my_domain):
	try:
		my_domain = my_domain.lower()
		valid = validators.domain(my_domain)
		if valid:
			print('\nDomain \"' + my_domain + '\" is a valid format.....')
		else:
			print('\nDomain didn\'t inserted or  is NOT a valid domain format')
			exit(1)
	except Exception as error:
		print('\nAn error occured while checking HOST (domain). Please try again')
		exit(1)

#FUNCTION to check if URL resolve to an IP
def domain_resolv(domain_to_resolv):
	try:
		r = socket.gethostbyname(domain_to_resolv)
		print("\nDomain \'" + domain_to_resolv + "\' resolved successfully to IP: \'" + r + "\'\n")
	except socket.error:
		print("\nDomain didn't resolve... Script is stopped!!!\n")
		exit(1)

#===============================================================================================

#checks if argument is in valid host format. otherwise it exits() the script
check_hostname(sys.argv[1])

#composes the url from domain name (host)
my_url=("http://"+sys.argv[1])
my_urls=("https://"+sys.argv[1])

my_domain=(sys.argv[1])

print("Printing my domain: " + my_domain)

domain_resolv(my_domain)

#the following runs only if a valid HOST (domain) is given
#returns successfully a status code if the domain resolves to a service or webpage
try:
	resolved=False
	#Check HTTP requests
	try:
		r = requests.get(my_url, allow_redirects=True)
		print("\nHTTP Status Code:[" + str(r.status_code) +"]...")
		print("\nHTTP Redirections Codes History: " + str(r.history))
		resolved=True
	except:
		pass
	if(resolved == False):
		try:
			rs = requests.get(my_urls, allow_redirects=True)
			#The same for the https requests
			print("\nHTTPS Status Code:[" + str(rs.status_code) +"]...")
			print("\nHTTPS Redirections Codes History: " + str(rs.history))
		except:
			print("\nAn ERROR occured in 'http' handling or URL finaly could not resolve. Please try again\n")
			exit(1)
	# checks if final url is http or https and prints it. Then it is passed to the bash script 'pass_url.sh' 
	if(my_url != r.url):
	  print("\nFinal URL is: \'"+ r.url +"\'")
	elif(my_urls != rs.url):
	  print("\nFinal URL is: \'"+ rs.url +"\'")
	#########
	if r.url:
	  subprocess.call(['./pass_url.sh', r.url])
	elif rs.url:
	  subprocess.call(['./pass_url.sh', rs.url])
	#print(r.headers)
except Exception as error:
	print("\nAn ERROR occured in 'http' handling or URL finaly could not resolve. Please try again\n")
	exit(1)


