import neovim
import os
import json, requests 
from base64 import b64encode
import re
import datetime

@neovim.plugin
class Main(object):
    def __init__(self, vim):
        self.vim = vim

    @neovim.function('DoItPython')
    def doItPython(self, args):
        self.vim.command('echo "hello from DoItPython"')

    @neovim.function('PrintMyFilename')
    def printMyFilename(self, args):
        filename = self.vim.current.buffer.name
        regex = re.match(".*(\d{4})/(\d{2})/(\d{2}).md$", filename)

        if not regex:
            print('no date found')
            return

        year = int(regex.group(1))
        month = int(regex.group(2))
        day = int(regex.group(3))

        date = datetime.date(year, month, day)
        datePlusOne = date.replace(day=date.day + 1)

        self.vim.command('echo "year: ' + regex.group(1) + '"')
        self.vim.command('echo "month: ' + regex.group(2) + '"')
        self.vim.command('echo "day: ' + regex.group(3) + '"')

        #payload = {'start_date': date.isoformat(), 'end_date': datePlusOne.isoformat()}
        #data = requests.get(
            #    'https://api.track.toggl.com/api/v9/me/time_entries',
            #    auth=("xxx", "xxx"),
            #    params=payload,
            #    headers={'content-type': 'application/json'}
            #)

        #toggl = json.loads(data.text)

        #for entry in toggl:
        #    print('new')
        #    print(entry['description'])
