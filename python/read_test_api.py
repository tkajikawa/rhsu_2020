####################################################################################
import json
from pathlib import Path
import json
from glob import glob

# Set working folder
data_folder = Path.home() / "rhsu_2020" / "data" / "google_api"
outfile = open(data_folder / 'cleaned_google_api_data.txt', 'w', encoding='utf-8', errors='ignore')

# Then let's take the text files and glob together
files = files = list(data_folder.glob('*+*.txt'))
# print(files)

def if_key_exists(myVar, dict):
    if myVar in dict:
        return dict[myVar].replace('\n','').replace('|','').replace('"','')
    else:
        return ''


##############################################################
# Main Function
##############################################################
outfile.write("|".join(['search_term'
                        , 'displayLink'
                        , 'snippet'
                        , 'link'
                        , 'title'
                        , 'number']) + '\n'
            )
for search_result in files:
    i = 0
    infile = open(search_result, 'r', encoding='utf-8', errors='replace')
    data = infile.read().replace('\n', '')
    # print(infile)
    dict_obj = eval(data)
    number=1
    for x in dict_obj['items']:
        # if str(search_result.stem) == 'Helen (Sunny) F. Ladd+Duke':
        #     import pprint
        #     pp = pprint.PrettyPrinter(indent=4)
        #     pp.pprint(x)
        outfile.write("|".join([str(search_result.stem)
                                , if_key_exists('displayLink', x)
                                , if_key_exists('snippet', x)
                                , if_key_exists('link', x)
                                , if_key_exists('title', x)
                                , str(number)]) + '\n'
                    )
        number +=1
    # print (whip)
