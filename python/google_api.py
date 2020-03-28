######################################################################################
# SET LOCAL VARS HERE (WILL CHANGE BASED ON USER)
######################################################################################
## CHANGE BELOW TO YOUR API KEY (connected to your google account)
api_key = ""

from apiclient.discovery import build
import json
from pathlib import Path
import json

# Save the git repo in your home area. For example mine is "C:\Users\tkajikaw\"
data_folder = Path.home() / "rhsu_2020" / "data"

######################################################################################
# SET LOCAL VARS HERE (WILL CHANGE BASED ON USER)
######################################################################################
# Need to change infile and outfile titles
infile = open(data_folder / 'search_terms.txt', 'r')

######################################################################################
# Start processing
######################################################################################
resource = build("customsearch", 'v1', developerKey=api_key).cse()

for line in infile.readlines():
    row = line.replace("\n","").replace("\r","").split("\t")
    searchTerm = row[0]

    name_file = str(searchTerm.replace('"','')) +'.txt'
    outfile = open(data_folder / 'google_api' / name_file ,'w', encoding='utf8')

    result = resource.list(q=searchTerm, cx='002245436681417226717:err5kak7vky').execute()
    output = str(result).encode('utf-8').decode('utf-8')
    outfile.write(output)
    # Take search term and run through Google API
    # try:
    #     name_file = str(searchTerm.replace('"','')) +'.txt'
    #     outfile = open(data_folder / name_file ,'w')
    #     result = resource.list(q=searchTerm, cx='002245436681417226717:err5kak7vky').execute()
    #     outfile.write(result)
    #     outfile.close()
    # # If fails, write a blank record
    # except:
    #     print(searchTerm)