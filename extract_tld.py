# Author: George Tasios
# FileName: extract_tld.py.sh

##called from 'runrecon.sh' file##

import tldextract #use this library to extract tld and main domain
import sys

global finaldomain

dom = sys.argv[1]

#The following line extracts the domain and the TLD, even if TLD
#is more than 2 words and keep the url clear from subdomains or paths
t = tldextract.extract(dom)

#Sets the variable 'finaldomain' with the domain+its tld, even if it is more than one word. 
#TLDextract library uses the Mozilla public TLDs list.
finaldomain = t.registered_domain

file = 'URLTEMP.txt'

#Appending the argument in the URLTEMP.txt file
with open(file, 'a') as f:
    f.write(finaldomain)


