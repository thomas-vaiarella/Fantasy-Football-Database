# import python as python
import requests
import pprint
import MySQLdb

db = MySQLdb.connect("160.153.61.162","seandatabase", "theseandatabase", "connollynfldata")
if db is None:
    db.close()
    print("We r screwed")
else:
    c = db.cursor()
    c.execute("""SELECT team_name from connollynfldata.team""")
    print("we did it")
print(c.fetchone())
db.close()


# URL strings
api_url = 'http://api.fantasy.nfl.com/'
weekstats_endpoint = 'players/weekstats'
stats_endpoint = 'players/stats'
positions_array = ['QB', 'RB', 'WR', 'TE', 'DEF', 'K']
stat_codes = {
    '14': 'RY', #rush yds
    '15': 'RTD', #rush td
    '20': 'REC', #receptions
    '21': 'REY', #rec yds
    '22': 'RETD', #rec td
    '30': 'FUML', #fumbles lost
    '5': 'PY', #pass yds
    '6': 'PTD', #pass tds
    '7': 'INT', #int thrown
    '45': 'SK', #sack
    '46': 'DINT', #int caught
    '47': 'FR', #fum recovered
    '62': 'DYD', #def yds
    '54': 'PA', #pts allowed
    '50': 'DTD', #defensive td
    '00002': 'KRTD', #kick return td
    '00003': 'PRTD', #punt return td
    '49': 'SF', #safety

}
points_mapping = {
    'RY': 0.1, #rush yds
    'RTD': 6.0, #rush td
    'REC': 0.0, #receptions
    'REY': 0.1, #rec yds
    'RETD': 6.0, #rec td
    'FUML': -2.0, #fumbles lost
    'PY': 0.04, #pass yds
    'PTD': 4.0, #pass tds
    'INT': -2.0, #int thrown
    'SK': 1.0, #sack
    'DINT': 2.0, #int caught
    'FR': 2.0, #fum recovered
    'DYD': 100000000, #def yds
    'PA': 100000000, #pts allowed
    'INTTD': 6.0, #pick-six
    'FRTD': 6.0, #fumble-six
    'KRTD': 6.0, #kick return td
    'PRTD': 6.0, #punt return td
    'SF': 2.0
}
pp = pprint.PrettyPrinter(indent=4)


def parse_stats(stats):
    mapped_stats = dict()

    for key in stats:
        abbr = stat_codes.get(key, None)
        if abbr is not None:
            mapped_stats[abbr] = int(stats.get(key))
    return mapped_stats


def player_points(player):
    stats = player.get('stats', None)
    if stats is None:
        return 0.0
    return points(stats)


def points(stats):
    total_points = 0.0
    for key in stats:
        amount = stats.get(key, 0)
        total_points += amount * points_mapping.get(key, 0.0)
    return round(total_points, 2)


def player_week(player):
    """

    :type player: dict
    """
    player.pop('esbid')
    player.pop('gsisPlayerId')
    player.pop('seasonPts')
    player.pop('seasonProjectedPts')
    player.pop('weekPts')
    player.pop('weekProjectedPts')

    stats = player.pop('stats')
    if (stats.get('30', None) is 0) or (stats.get('31', None) is 0):
        print(player)

    player['stats'] = parse_stats(stats)

    return player


def player_stats_for_week(position, week):
    assert position in positions_array
    assert type(week) == int
    assert week >= 1, week <= 17
    print("Getting stats for position ", position, " during week ", week)
    payload = {'format': 'json', 'statType': 'weekStats', 'position': position, 'week': week}
    data = nfl_request(endpoint=stats_endpoint, payload=payload)
    print("Received")
    pp.pprint(data['players'])
    players = list(map(player_week, list(data['players'])))
    return players


def nfl_request(endpoint, payload):
    r = requests.get(api_url + endpoint, params=payload)
    return r.json()


def player_tds(player):
    stats = player.get('stats', None)
    if stats is None:
        return 0
    rectds = int(stats.get('rectd', 0))
    rushtds = int(stats.get('rushtd', 0))
    passtds = int(stats.get('passtd', 0))
    return rectds + rushtds + passtds


def all_stats_for_week(week):
    print("Getting stats for week ", week)
    week_stats = dict()
    for position in positions_array:
        week_stats[position] = player_stats_for_week(position, week)
    return week_stats


def all_stats_through_week(week):
    all_stats = dict()
    for wk in range(1, week):
        all_stats[wk] = all_stats_for_week(wk)
    return all_stats


#defenses = player_stats_for_week("DEF", 5)
#pp.pprint(defenses)


# Commented this out because it was causing an error. Tried with original api link to test.
# r = requests.post("https://api.nfl.com/v1/oauth/token?grant_type=client_credentials&client_id=nfl&client_secret=15232")
r = requests.post("http://api.fantasy.nfl.com/v1/players/stats?statType=seasonStats&season=2017&week=9&format=json")
pp.pprint(r.json())