Sean Connolly, Tom Vaiarella, Zach Walsh - NFL Fantasy Football DB

http://seanmconnolly.com/dbProj/tester.html

Requires Python (with mysql and requests packages) and MySQL.

1. Set up a new MySQL server to support the backend.
2. Run the football.sql script exactly as-is. This will create a new schema “connollynfldata” and all of the tables in our ER Diagram.
3. To run our python scripts you must have the mysql python package installed. Put your server’s IP address and login information in the DB connection lines at the top of each file (db = mysql.connector.connect(host="<your host ip address>", user="<your username>", password="<your password>", database="connollynfldata"))
 - These can be used to set up users and a league for testing (the league-setup.py script will do this, creating users test1 through test10 in a league). This is necessary to use any of the matchup or scoring functionality.
 - Run the nfl-api.py script to get real NFL stats in the table (add lines at the bottom with later weeks to get up-to-date NFL stats).
 - To advance these lineups for further weeks, call the “advance_lineups_in_league” procedure on a league id, giving it a week. This will allow you to view the record for a team up to that week, and see how lineup manipulation is locked for weeks that have already occurred.


