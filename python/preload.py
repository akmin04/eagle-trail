'''
For each rank and merit badge in preload.json, get the raw HTML of the corresponding scoutbook page.
By looking for tables and lists, we can extract each requirement and add them to the preload.json.
'''

import bs4
import json
import os.path
import re
import requests

preload_file = "../eagle-trail/Models/preload.json"

rank_url = "https://www.scoutbook.com/mobile/references/boy-scouting/ranks/"

merit_badge_url1 = "https://www.scoutbook.com/mobile/references/boy-scouting/merit-badges/"
merit_badge_url2 = "-merit-badge-requirements.asp"

regex = re.compile('[^a-z0-9]')

RANK = 0
MERIT_BADGE = 1

# Either a rank or a merit badge
class Badge(object):

    def __init__(self, name, i, type, json):
        self.original_name = name
        self.name = name.lower().strip().replace(' ', '-')
        if self.name == 'exploration':
            self.name = 'exploring'
        if self.name == 'moviemaking':
            self.name = 'cinematography-moviemaking'
        if self.name == 'signs-signals-and-codes':
            self.name = 'signs-signals-codes'
        self.i = i
        if type == 0:
            self.url = rank_url + self.name
        else:
            self.url = merit_badge_url1 + self.name + merit_badge_url2
        self.json = json['ranks' if type == RANK else 'meritBadges'][i]


def main():
    print("Parse ranks? (y/n)")
    parse_ranks = yes_no()
    print("Parse merit badges? (y/n)")
    parse_merit_badges = yes_no()
    print("Skip badges already loaded? (y/n)")
    skip = yes_no()

    with open(preload_file, 'r+') as file:
        preload = json.load(file)
        if parse_ranks:
            for i, rank in enumerate(preload['ranks']):
                rank = Badge(rank['name'], i, RANK, preload)
                parse(rank, skip)

                file.seek(0)
                json.dump(preload, file, indent=4)
                file.truncate()

        if parse_merit_badges:
            for i, merit_badge in enumerate(preload['meritBadges']):
                merit_badge = Badge(merit_badge['name'], i, MERIT_BADGE, preload)
                parse(merit_badge, skip)

                file.seek(0)
                json.dump(preload, file, indent=4)
                file.truncate()
        
# Get all requirements for a rank/merit badge, parse the HTML, and add them to the JSON.
def parse(badge, skip):
    if len(badge.json['requirements']) > 0 and skip:
        print("Skipping " + badge.original_name)
        return

    print("Parsing " + badge.original_name + " from " + badge.url)
    req = requests.get(badge.url)
    print("Recieved")

    parsed = bs4.BeautifulSoup(req.text, 'html.parser')
    table = parsed.find('table', attrs={'class': 'requirementsTable'})

    # Get the first level requirements
    rows = table.find_all('tr', recursive=False)

    for row in rows:
        parse_row(0, row, badge)

# Parse a table row.
def parse_row(depth, row, badge):
    cells = row.find_all('td')

    # Get the requirements index and text
    try:
        index = regex.sub('', cells[0].find(
            'div', recursive=False).contents[0].strip())
        text_contents = cells[1].contents
        text = ""
        for content in text_contents:
            if type(content) is bs4.element.NavigableString:
                text += content.strip()
            elif type(content) is bs4.element.Tag:
                if content.name == 'strong':
                    text += content.text.strip()

    except IndexError:
        return

    # Append to JSON
    badge.json['requirements'].append({
        'depth': depth,
        'index': index,
        'text': text
    })

    # Find nested requirements in a table
    if row.find('table'):
        for row in row.find('table').find_all('tr', recursive=False):
            parse_row(depth + 1, row, badge)

    # Find nested requirements in a list
    if row.find('ul'):
        parse_list('ul', depth + 1, row, badge)
    if row.find('ol'):
        parse_list('ol', depth + 1, row, badge)

# Parse an unordered or ordered list.
def parse_list(tag, depth, req, badge):
    rows = req.find(tag).find_all('li', recursive=False)

    for row in rows:
        badge.json['requirements'].append({
            'depth': depth,
            'index': "",
            'text': row.contents[0].strip()
        })

# Ask the user for yes or no.
def yes_no():
    return True if input() == 'y' else False

if __name__ == "__main__":
    main()
