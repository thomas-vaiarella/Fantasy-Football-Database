import requests
import pprint
import mysql.connector

db = mysql.connector.connect(host="160.153.61.162", user="seandatabase", password="theseandatabase", database="connollynfldata")
if db is None:
    db.close()
    print("We r screwed")
    exit(1)


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
    '33': 'PAT', #PAT made
    '34': 'PATM', #PAT missed
    '35': 'FG0', #FG 0-39yds (maybe <20?)
    '36': 'FG0', #FG 0-39yds (maybe 20-29?)
    '37': 'FG0', #FG 0-39yds (maybe 30-39?)
    '38': 'FG40', #FG 40-49yds
    '39': 'FG50', #FG 50+yds
    '42': 'FGM', #FG missed (some distance)
    '43': 'FGM', #FG missed (some distance)
    '44': 'FGM', #FG missed (some distance)
}

pp = pprint.PrettyPrinter()


# Parses the stats in the NFL's stats JSON
# object to change stat codes to actual stat
# names for ease of use in the backend.
def parse_stats(stats, player_name):
    mapped_stats = dict()

    for key in stats:
        abbr = stat_codes.get(key, None)
        if abbr is not None:
            mapped_stats[abbr] = int(stats.get(key)) + mapped_stats.get(abbr, 0)
        elif key != "1":
            print("No stat name for code: ", key, "player: ", player_name)
    return mapped_stats


# Takes a "Player" object from the NFL's API
# stats response and manipulates it to match
# what our database is looking for.
def player_week(player):
    player.pop('esbid')
    player.pop('gsisPlayerId')
    player.pop('seasonPts')
    player.pop('seasonProjectedPts')
    player.pop('weekPts')
    player.pop('weekProjectedPts')

    stats = player.pop('stats')

    player['stats'] = parse_stats(stats, player["name"])

    return player


# Fetches the stats for players of the given position in
# the given week from the NFL API.
def player_stats_for_week(position, week):
    assert position in positions_array
    assert type(week) == int
    assert week >= 1, week <= 17
    print("Getting stats for", position, "from week", week)
    payload = {'format': 'json', 'statType': 'weekStats', 'position': position, 'week': week}
    data = nfl_request(endpoint=stats_endpoint, payload=payload)
    players = list(map(player_week, list(data['players'])))
    return players


# Executes a request on the NFL API with the given endpoint
# and payload.
def nfl_request(endpoint, payload):
    r = requests.get(api_url + endpoint, params=payload)
    return r.json()


def all_stats_for_week(week):
    week_stats = dict()
    for position in positions_array:
        week_stats[position] = player_stats_for_week(position, week)
    return week_stats


# This query will give back the id of the given player in the database,
# inserting a new record if one does not exist.
get_player_id_query = "SELECT get_player_id(%s, %s, %s, %s);"

# This query will give back the id of the record for a given player's
# stats for a given week, creating a new record if necessary.
get_week_stats_for_player_week = "SELECT get_player_week_stats(%s, %s);"

# This statement will call a procedure to insert a stat value for
# a given stat for a given week's stats.
set_stats_produced = "call set_stats_produced(%s, %s, %s);"


# Gets all stats for the given week via helper methods,
# then inserts the appropriate values into the DB with
# the above procedures.
def insert_stats_for_week(week):
    cursor = db.cursor()
    player_stats = all_stats_for_week(week)
    for position in player_stats:
        players = player_stats[position]
        for player in players:
            print("Adding stats for: ", player['name'], ", week: ", week)
            cursor.execute(get_player_id_query, (player['id'],
                                                 player['name'],
                                                 None if player['teamAbbr'] == '' else player['teamAbbr'],
                                                 player['position']))
            player_id = cursor.fetchone()[0]
            cursor.execute(get_week_stats_for_player_week, (player_id, week))
            weekstats_id = cursor.fetchone()[0]
            stats = player['stats']
            for stat_name in stats:
                cursor.execute(set_stats_produced, (weekstats_id, stat_name, stats[stat_name]))
    db.commit()
    cursor.close()

insert_stats_for_week(1)
insert_stats_for_week(2)
insert_stats_for_week(3)
insert_stats_for_week(4)
insert_stats_for_week(5)
insert_stats_for_week(6)
insert_stats_for_week(7)
insert_stats_for_week(8)
insert_stats_for_week(9)
insert_stats_for_week(10)
insert_stats_for_week(11)
insert_stats_for_week(12)
insert_stats_for_week(13)
