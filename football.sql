DROP schema if exists fantasyfootball;
create schema fantasyfootball;
USE fantasyfootball;

create table scoring (
	scoring_id int primary key,
    scoring_name enum('standard', 'ppr')

);

create table statvalue (
	scoring_id int,
    stat_name varchar(5),
    value_pts float,
    constraint scoring_id_fk foreign key (scoring_id) references scoring (scoring_id),
    constraint pk_statvalue primary key (stat_name, scoring_id)
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
    stat_name varchar(5),
    stat_total int,
    constraint weekstats_id_fk_statsproduced foreign key (weekstats_id) references weekstats (weekstats_id),
    constraint statsproduced_pk primary key (stat_name, weekstats_id)
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

drop procedure if exists add_player_if_not_exists;
DELIMITER //
create procedure add_player_if_not_exists(new_player_id int, new_player_name varchar(50), new_player_team varchar(50), new_player_position varchar(50))
begin
INSERT INTO player (player_id, player_name, player_team, player_position)
VALUES (new_player_id, new_player_name, new_player_team, new_player_position);
end //

DELIMITER ;
drop function if exists get_player_id;

DELIMITER //
create function get_player_id(given_player_id int, given_player_name varchar(50), given_player_team varchar(50), given_player_position varchar(50))
returns int
begin

declare id int default 000000000;
select player_id into id from player where player_id = given_player_id;
case
	when id  != 000000000 THEN return id;
	else 
		CALL add_player_if_not_exists(given_player_id, given_player_name, given_player_team, given_player_position);
        select player_id into id from player where player_id = given_player_id;
        return id;
        end case;
end //
                
DELIMITER ;
drop procedure if exists add_player_week_stats;
DELIMITER //
create procedure add_player_week_stats(given_id int, given_week_num int)
begin
INSERT INTO weekstats (player_id, week_num)
VALUES (given_id, given_week_num);
end //

DELIMITER ; 
drop function if exists get_player_week_stats;
DELIMITER //
create function get_player_week_stats(given_player_id int, given_week_num int)
returns int
begin
declare week_stats_id_num int default -1;

select weekstats_id into week_stats_id_num 
from weekstats 
where player_id = given_player_id and week_num = given_week_num;

case
	when week_stats_id_num  != -1 THEN return week_stats_id_num;
	else 
		CALL add_player_week_stats(given_player_id, given_week_num);
        select weekstats_id into week_stats_id_num 
		from weekstats 
		where player_id = given_player_id and week_num = given_week_num;
        return week_stats_id_num;
        end case;
end //

DELIMITER ;
drop procedure if exists set_stats_produced;
DELIMITER //
create procedure set_stats_produced(given_week_stats_id int, given_stat_name varchar(5), given_stat_value int)
begin
INSERT INTO stats_produced
VALUES (given_week_stats_id, given_stat_name, given_stat_value);
end //




