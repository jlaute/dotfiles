" [...]

" Starts a section for Python 3 code.
python3 << EOF
# Imports Python modules to be used by the plugin.
import vim
import json, requests 
from base64 import b64encode
import re
import datetime

# Sets up variables for the HTTP requests the
# plugin makes to fetch word definitions from
# the Wiktionary dictionary.
request_headers = { "accept": "application/json" }
request_base_url = "https://en.wiktionary.org/api/rest_v1/page/definition/"
request_url_options = "?redirect=true"

# Fetches available definitions for a given word.
def get_word_definitions(word_to_define):
    response = requests.get(request_base_url + word_to_define + request_url_options, headers=request_headers)

    if (response.status_code != 200):
        print(response.status_code + ": " + response.reason)
        return

    definition_json = json.loads(response.text)

    for definition_item in definition_json["en"]:
        print(definition_item["partOfSpeech"])

        for definition in definition_item["definitions"]:
            print(" - " + definition["definition"])

def get_date_from_filename(filename):
    regex = re.match(".*(\d{4})/(\d{2})/(\d{2}).md$", filename)

    if not regex:
        print('no date found')
        return

    year = int(regex.group(1))
    month = int(regex.group(2))
    day = int(regex.group(3))

    date = datetime.date(year, month, day)
    datePlusOne = date.replace(day=date.day + 1)

    print('year: ' + regex.group(1))
    print('month: ' + regex.group(2))
    print('day: ' + regex.group(3))
    
    payload = {'start_date': date.isoformat(), 'end_date': datePlusOne.isoformat()}
    data = requests.get(
        'https://api.track.toggl.com/api/v9/me/time_entries',
        auth=("xxx", "xxx"),
        params=payload,
        headers={'content-type': 'application/json'}
    )

    toggl = json.loads(data.text)

    for entry in toggl:
        print('new')
        print(entry['description'])
EOF

" Calls the Python 3 function.
function! time_tracking#DefineWord()
    let cursorWord = expand('<cword>')
    python3 get_word_definitions(vim.eval('cursorWord'))
endfunction

function! time_tracking#GetFilenme()
    let filename = expand('%')
    python3 get_date_from_filename(vim.eval('filename'))
endfunction
