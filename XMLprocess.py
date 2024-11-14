# Author: George Tasios
# FileName: XMLprocess.py

# XML process: Takes as 1st argument the output XML file from nmapipv4 or nmapipv6 functions of 'checkservices.sh' script
# exports and append the appropriate elements to the last output CSV file


import csv
import xml.etree.ElementTree as ET
import sys

# importing XML file as 1st argument. Used in XMLparse function
xmlfile = sys.argv[1]
# importing as 2nd argument
final_output_CSV = sys.argv[2]
finalCSVfilepath = ''

# CSV headers titles:
# hoststatus,address,addresstype,portnum,protocol,portState,CPE,servName,servConfidence,scanMethod,Product,serviceVer,extraServInfo,OStype,deviceType



hostitems = []
hostitemstemp = []

def XMLparse(XMLfile):
    #creating xml tree object
    tree = ET.parse(xmlfile)
    #getting root element of the xml 'tree'
    root = tree.getroot()

    ### Iterate 'host' items
    for host in root.findall('./host'): # Finds all 'host' items in the tree
        temp = {} # Creating an empty dictionary called 'TEMP'
        # iterate children in host
        for child in host:
            if child.tag == 'status':
                temp['hoststatus'] = child.attrib['state']
            elif child.tag == 'address':
                temp['address'] = child.attrib['addr']
                if 'addrtype' in child.attrib:
                    temp['addresstype'] = child.attrib['addrtype']
                else:
                    temp['addresstype'] = ""

    # Create sub_tag object for 'ports' tag
    # finds 'ports' tag in the host 'tag'. We use the script once for each scanned IP, so it will normally find one 'ports' tag each time
    ports = host.find('ports')

    # iterate 'port' items (children of 'host' item)
    for port in ports.findall('port'):
        temp['portnum'] = port.get('portid')
        temp['protocol'] = port.get('protocol')
        #iterates child items of each 'port' tag

        for child in port:
            if child.tag == 'state': # state element is child of port and appears always  ONCE
                temp['portState'] = child.get('state')
            temp['CPE'] = "" #initializing temp['CPE'] value

            if child.tag == 'service': # Cardinality of 'service' is -?- (none or one)
                temp['servName'] = child.get('name') # Required
                temp['servConfidence'] = child.get('conf') # Required
                temp['scanMethod'] = child.get('method') # Required
                if 'product' in child.attrib:
                    temp['Product'] = child.get('product') 
                else:
                    temp['Product'] = ""

                if 'version' in child.attrib:
                    temp['serviceVer'] = child.get('version')
                else:
                    temp['serviceVer'] = ""

                if 'extrainfo' in child.attrib:
                    temp['extraServInfo'] = child.get('extrainfo')
                else:
                    temp['extraServInfo'] = ""

                if 'ostype' in child.attrib:
                    temp['OStype'] = child.get('ostype')
                else:
                    temp['OStype'] = ""

                if 'devicetype' in child.attrib:
                    temp['deviceType'] = child.get('devicetype')
                else:
                    temp['deviceType'] = ""

                # Find 'Service' tag children and then check if any CPE element exists
                service = port.find('service')
                tmp = ""
                for childr in service:
                    if childr.tag == 'cpe':
                        tmp = childr.text + ";" + tmp
                        temp['CPE'] = tmp
                    else:
                        temp['CPE'] = ""
            else: #what follows run only if 'service' child didn't found
                temp['servName'] = temp['servConfidence'] = temp['scanMethod'] = temp['Product'] = temp['serviceVer'] = ""
                temp['extraServInfo'] = temp['CPE'] = temp['OStype'] = temp['deviceType'] = ""

        hostitems.append(temp)
        dict_to_csvfile(temp, final_output_CSV) # Append results in the csv file. Creates headers row if do not exist
        hostitems.clear()



# Function that writes what the 'hostitems' dictionary contains, into a csv file
def dict_to_csvfile(data, csvfile):
    file_exists = True

    try:
        with open(csvfile, 'r') as f:
            if len(f.readline()) == 0:
                file_exists = False
    except FileNotFoundError:
        file_exists = False

    with open(csvfile, 'a', newline='') as f:
        #....writing data to CSV file
        fieldnames = data.keys()
        writer = csv.DictWriter(f, fieldnames=fieldnames)

        if not file_exists:
            writer.writeheader()
        writer.writerow(data)





XMLparse(xmlfile)
