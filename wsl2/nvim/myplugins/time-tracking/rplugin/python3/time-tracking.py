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
        self.src = vim.new_highlight_source()

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

        jiraTitleRegex = "^\[*([a-zA-Z0-9]*-\d+)\]* (.*)(@jira)$"
        timeRegex = "^ \* \[ \] (\d{0,3}h* *\d{0,3}m* *\d{0,3}s*)"

        # call api via buffer.api.line_count() === nvim_buf_line_count()

        buffer = self.vim.current.buffer
        tickets = dict()
        latestTicket = ''
        comment = ''
        for i in range(0, buffer.api.line_count()):
            ticketRegexMatch = re.match(jiraTitleRegex, buffer[i])
            if (ticketRegexMatch):
                latestTicket = ticketRegexMatch.group(1)
                tickets[ticketRegexMatch.group(1)] = {'ticketLine': i}
                continue

            timeRegexMatch = re.match(timeRegex, buffer[i])
            if (not timeRegexMatch and latestTicket):
                comment += buffer[i] + '\n'
                tickets[latestTicket]['comment'] = comment

            if (timeRegexMatch):
                tickets[latestTicket]['timeLine'] = i
                tickets[latestTicket]['time'] = timeRegexMatch.group(1)
                latestTicket = ''
                comment = ''

        for ticket in tickets:
            buffer.add_highlight("String", tickets[ticket]['ticketLine'], 0, len(ticket), src_id=self.src)

            buffer.api.set_text(tickets[ticket]['timeLine'], 4, tickets[ticket]['timeLine'], 5, ['X'])


        # payload = {'start_date': date.isoformat(), 'end_date': datePlusOne.isoformat()}
        # data = requests.get(
        #         'https://api.track.toggl.com/api/v9/me/time_entries',
        #         auth=(os.getenv('TOGGL_USERNAME'), os.getenv('TOGGL_PASSWORD')),
        #         params=payload,
        #         headers={'content-type': 'application/json'}
        #     )
        #
        # toggl = json.loads(data.text)
        #
        # for entry in toggl:
        #     print('new')
        #     print(entry['description'])
