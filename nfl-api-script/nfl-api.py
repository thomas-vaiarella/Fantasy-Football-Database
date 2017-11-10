import requests
import pprint
import mysql.connector

db = mysql.connector.connect(host="160.153.61.162", user="seandatabase", password="theseandatabase", database="connollynfldata")
if db is None:
    db.close()
    print("We r screwed")
else:
    c = db.cursor()
    c.execute("""SELECT team_name from connollynfldata.team""")
    print("we did it")
print(c.fetchone())


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

pp = pprint.PrettyPrinter()

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

    player['stats'] = parse_stats(stats)

    return player


def player_stats_for_week(position, week):
    assert position in positions_array
    assert type(week) == int
    assert week >= 1, week <= 17
    payload = {'format': 'json', 'statType': 'weekStats', 'position': position, 'week': week}
    data = nfl_request(endpoint=stats_endpoint, payload=payload)
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
    week_stats = dict()
    for position in positions_array:
        week_stats[position] = player_stats_for_week(position, week)
    return week_stats


def all_stats_through_week(week):
    all_stats = dict()
    for wk in range(1, week):
        all_stats[wk] = all_stats_for_week(wk)
    return all_stats


# This query will give back the id of the given player in the database,
# inserting a new record if one does not exist.
get_player_id_query = "SELECT get_player_id(%s, %s, %s, %s);"

# This query will give back the id of the record for a given player's
# stats for a given week, creating a new record if necessary.
get_week_stats_for_player_week = "SELECT get_player_week_stats(%s, %s);"

# This statement will call a procedure to insert a stat value for
# a given stat for a given week's stats.
set_stats_produced = "call set_stats_produced(%s, %s, %s);"

def insert_stats_for_week(week):
    cursor = db.cursor()
    player_stats = all_stats_for_week(week)
    for position in player_stats:
        players = player_stats[position]
        for player in players:
            cursor.execute(get_player_id_query, (player['id'], player['name'], player['teamAbbr'], player['position']))
            player_id = cursor.fetchone()[0]
            cursor.execute(get_week_stats_for_player_week, (player_id, week))
            weekstats_id = cursor.fetchone()[0]
            stats = player['stats']
            for stat_name in stats:
                cursor.execute(set_stats_produced, (weekstats_id, stat_name, stats[stat_name]))


insert_stats_for_week(1)




db.close()