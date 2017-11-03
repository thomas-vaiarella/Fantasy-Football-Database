DROP schema if exists fantasyfootball;
create schema fantasyfootball;
USE fantasyfootball;

create table scoring (
	scoring_id int primary key,
    scoring_name enum('standard', 'ppr')

);

create table stat (
	stat_id int primary key,
    stat_name enum('RY', 'RTD', 'REC', 'REY', 'RETD', 'FUML', 'PY', 'PTD', 'INT', 'SK', 'DINT', 'FR', 'DYD', 'PA', 'DTD', 'KRTD', 'PRTD')
);

create table statvalue (
	scoring_id int,
    stat_id int,
    value_pts float,
    constraint scoring_id_fk foreign key (scoring_id) references scoring (scoring_id),
    constraint stat_id_fk foreign key (stat_id) references stat (stat_id),
    constraint pk_statvalue primary key (stat_id, scoring_id)
);

create table league (
	league_id int auto_increment primary key,
    scoring_id int,
    constraint scoring_id_fk_league foreign key (scoring_id) references scoring (scoring_id)
);

create table team (
	team_id int auto_increment primary key,
	league_id int,
    team_name varchar(45),
	username varchar(45),
    constraint league_id_fk foreign key (league_id) references league (league_id),
    constraint one_team_per_league unique (league_id, username),
    constraint unique_team_name unique (league_id, team_name)
);

create table matchup (
	week_num int,
    team1_id int,
    team2_id int,
    constraint team1_id_fk foreign key (team1_id) references team (team_id),
    constraint team2_id_fk foreign key (team2_id) references team (team_id)
);

create table player (
	player_id int primary key,
    player_name varchar(60),
    player_team enum('TB', 'MIA', 'SF', 'CHI', 'CIN', 'BUF', 'DEN', 'CLE', 'ARI', 'LAC', 'KC', 'IND', 'DAL', 'PHI', 'ATL', 
    'NYG', 'JAX', 'NYJ', 'DET', 'GB', 'CAR', 'NE', 'OAK', 'LA', 'BAL', 'WAS', 'NO', 'SEA', 'PIT', 'HOU', 'TEN', 'MIN'),
    player_position enum('QB', 'RB', 'WR', 'TE', 'DEF', 'K')
);

create table weekstats (
	weekstats_id int primary key auto_increment,
    player_id int,
    week_num int,
    constraint player_id_fk foreign key (player_id) references player (player_id),
    constraint one_week_stats unique (player_id, week_num)
);


create table statsproduced (
	weekstats_id int,
    stat_id int,
    stat_total int,
    constraint weekstats_id_fk_statsproduced foreign key (weekstats_id) references weekstats (weekstats_id),
    constraint stat_id_fk_statsproduced foreign key (stat_id) references stat (stat_id),
    constraint statsproduced_pk primary key (stat_id, weekstats_id)
);

create table lineup (
	lineup_id int auto_increment primary key,
    week_num int,
    team_id int,
    constraint team_id_fk foreign key (team_id) references team (team_id),
    constraint unique_team_week unique (week_num, team_id)
);

create table slot (
	lineup_id int,
    player_id int,
    starting_or_not boolean,
    constraint lineup_id_fk_slot foreign key (lineup_id) references lineup (lineup_id),
    constraint player_id_fk_slot foreign key (player_id) references player (player_id),
    constraint slot_pk primary key (lineup_id, player_id)
);

