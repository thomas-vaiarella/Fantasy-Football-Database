import mysql.connector

db = mysql.connector.connect(host="160.153.61.162", user="seandatabase", password="theseandatabase", database="connollynfldata")
if db is None:
    db.close()
    print("We r screwed")
    exit(1)


def create_league():
    cursor = db.cursor()

    league_id = -1
    cursor.callproc("create_league", args=[0])

    for result in cursor.stored_results():
        league_id = result.fetchone()[0]

    db.commit()
    cursor.close()

    return league_id


def add_user(name):
    cursor = db.cursor()
    cursor.execute("insert into users values(%s, %s);", params=(name, "password"))
    db.commit()
    cursor.close()


def register_user(name, league):
    cursor = db.cursor()
    cursor.execute("insert into team values(team_id, %s, %s, %s);", (league, name, name))
    cursor.execute("select last_insert_id();")
    team_id = cursor.fetchone()[0]
    db.commit()
    cursor.close()
    return team_id


def add_week1_lineup(team_id):
    cursor = db.cursor()
    cursor.execute("insert into lineup values(lineup_id, 1, %(team)s);", {'team': team_id})
    cursor.execute("select last_insert_id();")
    lineup_id = cursor.fetchone()[0]
    db.commit()
    cursor.close()
    return lineup_id


def add_player_to_lineup(player_name, team_id):
    cursor = db.cursor()
    cursor.execute("select player_id from player where player_name = %(player)s limit 1;", {'player': player_name})
    result = cursor.fetchone()
    if result is None:
        print("Failed to find ", player_name)
        return
    player_id = result[0]
    try:
        cursor.callproc('add_player_to_lineup', (player_id, team_id))
    except mysql.connector.errors.DatabaseError:
        print("Failed to add", player_name, "with id", player_id)
    db.commit()
    cursor.close()




league = create_league()
users = ["test1", "test2", "test3", "test4", "test5", "test6", "test7", "test8", "test9", "test10"]
'''for user in users:
    add_user(user)
    '''
team_ids = []
for user in users:
    team_ids.append(register_user(user, league))

lineup_ids = []
for team_id in team_ids:
    lineup_ids.append(add_week1_lineup(team_id))

add_player_to_lineup("Cam Newton", team_ids[0])
add_player_to_lineup("DeMarco Murray", team_ids[0])
add_player_to_lineup("Amari Cooper", team_ids[0])
add_player_to_lineup("Christian McCaffrey", team_ids[0])
add_player_to_lineup("Larry Fitzgerald", team_ids[0])
add_player_to_lineup("Travis Kelce", team_ids[0])
add_player_to_lineup("Stefon Diggs", team_ids[0])
add_player_to_lineup("Carolina Panthers", team_ids[0])
add_player_to_lineup("Chris Boswell", team_ids[0])
add_player_to_lineup("Latavius Murray", team_ids[0])
add_player_to_lineup("Mike Evans", team_ids[0])
add_player_to_lineup("Doug Martin", team_ids[0])
add_player_to_lineup("Jeremy Maclin", team_ids[0])
add_player_to_lineup("Ben Roethlisberger", team_ids[0])
add_player_to_lineup("LeGarrette Blount", team_ids[0])
add_player_to_lineup("Eric Ebron", team_ids[0])

add_player_to_lineup("Drew Brees", team_ids[1])
add_player_to_lineup("LeSean McCoy", team_ids[1])
add_player_to_lineup("Ezekiel Elliott", team_ids[1])
add_player_to_lineup("Demaryius Thomas", team_ids[1])
add_player_to_lineup("Michael Crabtree", team_ids[1])
add_player_to_lineup("Rob Gronkowski", team_ids[1])
add_player_to_lineup("C.J. Anderson", team_ids[1])
add_player_to_lineup("Denver Broncos", team_ids[1])
add_player_to_lineup("Dustin Hopkins", team_ids[1])
add_player_to_lineup("DeSean Jackson", team_ids[1])
add_player_to_lineup("Donte Moncrief", team_ids[1])
add_player_to_lineup("Matt Forte", team_ids[1])
add_player_to_lineup("Corey Davis", team_ids[1])
add_player_to_lineup("Charles Sims", team_ids[1])
add_player_to_lineup("Tyler Lockett", team_ids[1])
add_player_to_lineup("Thomas Rawls", team_ids[1])


add_player_to_lineup("Matt Ryan", team_ids[2])
add_player_to_lineup("Le'Veon Bell", team_ids[2])
add_player_to_lineup("Lamar Miller", team_ids[2])
add_player_to_lineup("Michael Thomas", team_ids[2])
add_player_to_lineup("Sammy Watkins", team_ids[2])
add_player_to_lineup("Jimmy Graham", team_ids[2])
add_player_to_lineup("Allen Robinson", team_ids[2])
add_player_to_lineup("Buffalo Bills", team_ids[2])
add_player_to_lineup("Stephen Gostkowski", team_ids[2])
add_player_to_lineup("Terrance West", team_ids[2])
add_player_to_lineup("Danny Woodhead", team_ids[2])
add_player_to_lineup("Kenny Britt", team_ids[2])
add_player_to_lineup("Jonathan Stewart", team_ids[2])
add_player_to_lineup("Minnesota Vikings", team_ids[2])
add_player_to_lineup("Dion Lewis", team_ids[2])
add_player_to_lineup("Danny Amendola", team_ids[2])


add_player_to_lineup("Russell Wilson", team_ids[3])
add_player_to_lineup("Jordan Howard", team_ids[3])
add_player_to_lineup("Isaiah Crowell", team_ids[3])
add_player_to_lineup("DeAndre Hopkins", team_ids[3])
add_player_to_lineup("Kelvin Benjamin", team_ids[3])
add_player_to_lineup("Jason Witten", team_ids[3])
add_player_to_lineup("Darren Sproles", team_ids[3])
add_player_to_lineup("New England Patriots", team_ids[3])
add_player_to_lineup("Dan Bailey", team_ids[3])
add_player_to_lineup("Odell Beckham", team_ids[3])
add_player_to_lineup("Tyler Eifert", team_ids[3])
add_player_to_lineup("Darren McFadden", team_ids[3])
add_player_to_lineup("Giovani Bernard", team_ids[3])
add_player_to_lineup("Randall Cobb", team_ids[3])
add_player_to_lineup("Marvin Jones", team_ids[3])
add_player_to_lineup("Matthew Stafford", team_ids[3])


add_player_to_lineup("Derek Carr", team_ids[4])
add_player_to_lineup("Devonta Freeman", team_ids[4])
add_player_to_lineup("Marshawn Lynch", team_ids[4])
add_player_to_lineup("Brandin Cooks", team_ids[4])
add_player_to_lineup("Davante Adams", team_ids[4])
add_player_to_lineup("Greg Olsen", team_ids[4])
add_player_to_lineup("Adrian Peterson", team_ids[4])
add_player_to_lineup("Seattle Seahawks", team_ids[4])
add_player_to_lineup("Matt Bryant", team_ids[4])
add_player_to_lineup("Jarvis Landry", team_ids[4])
add_player_to_lineup("Brandon Marshall", team_ids[4])
add_player_to_lineup("James White", team_ids[4])
add_player_to_lineup("Dak Prescott", team_ids[4])
add_player_to_lineup("Jordan Matthews", team_ids[4])
add_player_to_lineup("Jeremy Hill", team_ids[4])
add_player_to_lineup("Kendall Wright", team_ids[4])


add_player_to_lineup("Aaron Rodgers", team_ids[5])
add_player_to_lineup("Todd Gurley", team_ids[5])
add_player_to_lineup("Kareem Hunt", team_ids[5])
add_player_to_lineup("Julio Jones", team_ids[5])
add_player_to_lineup("Golden Tate", team_ids[5])
add_player_to_lineup("Delanie Walker", team_ids[5])
add_player_to_lineup("Jamison Crowder", team_ids[5])
add_player_to_lineup("Houston Texans", team_ids[5])
add_player_to_lineup("Matt Prater", team_ids[5])
add_player_to_lineup("Joe Mixon", team_ids[5])
add_player_to_lineup("Derrick Henry", team_ids[5])
add_player_to_lineup("Jacquizz Rodgers", team_ids[5])
add_player_to_lineup("Jameis Winston", team_ids[5])
add_player_to_lineup("Kevin White", team_ids[5])
add_player_to_lineup("Zay Jones", team_ids[5])
add_player_to_lineup("Charcandrick West", team_ids[5])


add_player_to_lineup("Kirk Cousins", team_ids[6])
add_player_to_lineup("Leonard Fournette", team_ids[6])
add_player_to_lineup("Mark Ingram", team_ids[6])
add_player_to_lineup("Jordy Nelson", team_ids[6])
add_player_to_lineup("Alshon Jeffery", team_ids[6])
add_player_to_lineup("Jordan Reed", team_ids[6])
add_player_to_lineup("Mike Gillislee", team_ids[6])
add_player_to_lineup("Arizona Cardinals", team_ids[6])
add_player_to_lineup("Adam Vinatieri", team_ids[6])
add_player_to_lineup("Tyreek Hill", team_ids[6])
add_player_to_lineup("Eric Decker", team_ids[6])
add_player_to_lineup("Theo Riddick", team_ids[6])
add_player_to_lineup("Eddie Lacy", team_ids[6])
add_player_to_lineup("Ted Ginn", team_ids[6])
add_player_to_lineup("Carson Wentz", team_ids[6])
add_player_to_lineup("Mohamed Sanu", team_ids[6])


add_player_to_lineup("Marcus Mariota", team_ids[7])
add_player_to_lineup("Melvin Gordon", team_ids[7])
add_player_to_lineup("Dalvin Cook", team_ids[7])
add_player_to_lineup("A.J. Green", team_ids[7])
add_player_to_lineup("Terrelle Pryor", team_ids[7])
add_player_to_lineup("Kyle Rudolph", team_ids[7])
add_player_to_lineup("Keenan Allen", team_ids[7])
add_player_to_lineup("Los Angeles Chargers", team_ids[7])
add_player_to_lineup("Mason Crosby", team_ids[7])
add_player_to_lineup("Ty Montgomery", team_ids[7])
add_player_to_lineup("Pierre Garcon", team_ids[7])
add_player_to_lineup("Tevin Coleman", team_ids[7])
add_player_to_lineup("Chris Hogan", team_ids[7])
add_player_to_lineup("Austin Hooper", team_ids[7])
add_player_to_lineup("Andy Dalton", team_ids[7])
add_player_to_lineup("Alvin Kamara", team_ids[7])


add_player_to_lineup("Tom Brady", team_ids[8])
add_player_to_lineup("Carlos Hyde", team_ids[8])
add_player_to_lineup("Rob Kelley", team_ids[8])
add_player_to_lineup("Antonio Brown", team_ids[8])
add_player_to_lineup("Dez Bryant", team_ids[8])
add_player_to_lineup("Zach Ertz", team_ids[8])
add_player_to_lineup("Frank Gore", team_ids[8])
add_player_to_lineup("Baltimore Ravens", team_ids[8])
add_player_to_lineup("Justin Tucker", team_ids[8])
add_player_to_lineup("Jay Ajayi", team_ids[8])
add_player_to_lineup("Emmanuel Sanders", team_ids[8])
add_player_to_lineup("Paul Perkins", team_ids[8])
add_player_to_lineup("Martellus Bennett", team_ids[8])
add_player_to_lineup("Kansas City Chiefs", team_ids[8])
add_player_to_lineup("Rishard Matthews", team_ids[8])
add_player_to_lineup("Adam Thielen", team_ids[8])

add_player_to_lineup("Philip Rivers", team_ids[9])
add_player_to_lineup("David Johnson", team_ids[9])
add_player_to_lineup("Bilal Powell", team_ids[9])
add_player_to_lineup("Doug Baldwin", team_ids[9])
add_player_to_lineup("T.Y. Hilton", team_ids[9])
add_player_to_lineup("Hunter Henry", team_ids[9])
add_player_to_lineup("Martavis Bryant", team_ids[9])
add_player_to_lineup("New York Giants", team_ids[9])
add_player_to_lineup("Cairo Santos", team_ids[9])
add_player_to_lineup("Devante Parker", team_ids[9])
add_player_to_lineup("Ameer Abdullah", team_ids[9])
add_player_to_lineup("Duke Johnson", team_ids[9])
add_player_to_lineup("Willie Snead", team_ids[9])
add_player_to_lineup("Corey Coleman", team_ids[9])
add_player_to_lineup("D'Onta Foreman", team_ids[9])

