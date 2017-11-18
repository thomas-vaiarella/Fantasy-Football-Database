DROP schema if exists connollynfldata;
create schema connollynfldata;
USE connollynfldata;

create table users (
	username varchar(30) primary key,
    psswrd varchar(30)
);

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

drop procedure if exists create_league;
delimiter //
create procedure create_league(s_id int)
begin
	if s_id not in (select s_id from scoring)
    then signal sqlstate '45000' set message_text = 'That scoring type does not exist.';
    end if;
    
    insert into league values (league_id, s_id);
    select last_insert_id();
end //
delimiter ;

create table team (
	team_id int auto_increment primary key,
	league_id int,
    team_name varchar(45),
	username varchar(45),
    constraint league_id_fk foreign key (league_id) references league (league_id),
    constraint username_fk foreign key (username) references users (username),
    constraint one_team_per_league unique (league_id, username),
    constraint unique_team_name unique (league_id, team_name)
);

drop trigger if exists max_teams_per_league;
delimiter //
create trigger max_teams_per_league before insert on team
for each row
begin
	declare league int;
    declare current_num_teams int;
    set league = new.league_id;
    select teams_in_league(league) into current_num_teams;
    
    if current_num_teams >= 10
    then signal sqlstate '45000' set message_text = "This league is full.";
    end if;
    
end //
delimiter ;

drop function if exists teams_in_league;
delimiter //
create function teams_in_league(league_id int)
returns int
begin 
	declare num_teams int;
    select count(distinct(team_id))
	into num_teams
	from team t
    where t.league_id = league_id;
    return num_teams;
end //
delimiter ;

drop trigger if exists create_matchups;
delimiter //
create trigger create_matchups after insert on team
for each row
begin 
    declare team0 int;
	declare team1 int;
	declare team2 int;
    declare team3 int;
	declare team4 int;
	declare team5 int;
    declare team6 int;
	declare team7 int;
	declare team8 int;
    declare team9 int;
    
	declare team_ids cursor for 
    select team_id
    from team
    where league_id = NEW.league_id;
    
    open team_ids;
    
    fetch team_ids into team0;
    fetch team_ids into team1;
    fetch team_ids into team2;
    fetch team_ids into team3;
    fetch team_ids into team4;
    fetch team_ids into team5;
    fetch team_ids into team6;
    fetch team_ids into team7;
    fetch team_ids into team8;
    fetch team_ids into team9;
    
    insert into matchup values (1, team0, team2);
    insert into matchup values (1, team1, team4);
    insert into matchup values (1, team3, team5);
    insert into matchup values (1, team6, team9);
    insert into matchup values (1, team7, team8);
    
    insert into matchup values (2, team0, team5);
    insert into matchup values (2, team1, team3);
    insert into matchup values (2, team2, team6);
    insert into matchup values (2, team4, team8);
    insert into matchup values (2, team7, team9);
    
    insert into matchup values (3, team0, team1);
    insert into matchup values (3, team2, team9);
    insert into matchup values (3, team3, team8);
    insert into matchup values (3, team4, team7);
    insert into matchup values (3, team5, team6);
    
    insert into matchup values (4, team0, team8);
    insert into matchup values (4, team1, team6);
    insert into matchup values (4, team2, team5);
    insert into matchup values (4, team3, team7);
    insert into matchup values (4, team4, team9);
    
    insert into matchup values (5, team0, team7);
    insert into matchup values (5, team1, team2);
    insert into matchup values (5, team3, team4);
    insert into matchup values (5, team5, team9);
    insert into matchup values (5, team6, team8);
    
    insert into matchup values (6, team0, team4);
    insert into matchup values (6, team1, team5);
    insert into matchup values (6, team2, team8);
    insert into matchup values (6, team3, team9);
    insert into matchup values (6, team6, team7);
    
    insert into matchup values (7, team0, team3);
    insert into matchup values (7, team1, team9);
    insert into matchup values (7, team2, team7);
    insert into matchup values (7, team4, team6);
    insert into matchup values (7, team5, team8);
    
    insert into matchup values (8, team0, team9);
    insert into matchup values (8, team1, team8);
    insert into matchup values (8, team2, team4);
    insert into matchup values (8, team3, team6);
    insert into matchup values (8, team5, team7);
    
    insert into matchup values (9, team0, team6);
    insert into matchup values (9, team1, team7);
    insert into matchup values (9, team2, team3);
    insert into matchup values (9, team4, team5);
    insert into matchup values (9, team8, team9);
    
    insert into matchup values (10, team0, team2);
    insert into matchup values (10, team1, team4);
    insert into matchup values (10, team3, team5);
    insert into matchup values (10, team6, team9);
    insert into matchup values (10, team7, team8);
    
    insert into matchup values (11, team0, team5);
    insert into matchup values (11, team1, team3);
    insert into matchup values (11, team2, team6);
    insert into matchup values (11, team4, team8);
    insert into matchup values (11, team7, team9);
    
    insert into matchup values (12, team0, team5);
    insert into matchup values (12, team1, team3);
    insert into matchup values (12, team2, team6);
    insert into matchup values (12, team4, team8);
    insert into matchup values (12, team7, team9);
    
    insert into matchup values (13, team0, team1);
    insert into matchup values (13, team2, team9);
    insert into matchup values (13, team3, team8);
    insert into matchup values (13, team4, team7);
    insert into matchup values (13, team5, team6);
    
    insert into matchup values (14, team0, team8);
    insert into matchup values (14, team1, team6);
    insert into matchup values (14, team2, team5);
    insert into matchup values (14, team3, team7);
    insert into matchup values (14, team4, team9);
    
    insert into matchup values (15, team0, team7);
    insert into matchup values (15, team1, team2);
    insert into matchup values (15, team3, team4);
    insert into matchup values (15, team5, team9);
    insert into matchup values (15, team6, team8);
    
    insert into matchup values (16, team0, team4);
    insert into matchup values (16, team1, team5);
    insert into matchup values (16, team2, team8);
    insert into matchup values (16, team3, team9);
    insert into matchup values (16, team6, team7);
    
    insert into matchup values (17, team0, team3);
    insert into matchup values (17, team1, team9);
    insert into matchup values (17, team2, team7);
    insert into matchup values (17, team4, team6);
    insert into matchup values (17, team5, team8);
end //
delimiter ;

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
INSERT INTO statsproduced
VALUES (given_week_stats_id, given_stat_name, given_stat_value);
end //

DELIMITER ;
drop function if exists get_defensive_ya_pts;
DELIMITER //
create function get_defensive_ya_pts(stat_value INT)
RETURNS INT
BEGIN
DECLARE yds_allowed INT;

SELECT stat_total
FROM statsproduced 
WHERE statsproduced.weekstats_id = weekstats_id 
AND statsproduced.stat_name = 'DYD' INTO yds_allowed;

CASE
    WHEN yds_allowed = NULL THEN RETURN 0;
	WHEN yds_allowed < 100 THEN RETURN 5;
    WHEN yds_allowed >= 100 AND yds_allowed <= 199 THEN RETURN 3;
	WHEN yds_allowed >= 200 AND yds_allowed <= 299 THEN RETURN 2;
    WHEN yds_allowed >= 300 AND yds_allowed <= 349 THEN RETURN 0;
	WHEN yds_allowed >= 350 AND yds_allowed <= 399 THEN RETURN -1;
	WHEN yds_allowed >= 400 AND yds_allowed <= 449 THEN RETURN -3;
	WHEN yds_allowed >= 450 AND yds_allowed <= 499 THEN RETURN -5;
	WHEN yds_allowed >= 500 AND yds_allowed <= 549 THEN RETURN -6;
	WHEN yds_allowed > 550 THEN RETURN -7;
    ELSE RETURN 0;
    END CASE;
END //

DELIMITER ;
drop function if exists get_defensive_pa_pts;
DELIMITER //
create function get_defensive_pa_pts(stat_value INT)
RETURNS INT
BEGIN
DECLARE pts_allowed INT;

SELECT stat_total
FROM statsproduced 
WHERE statsproduced.weekstats_id = weekstats_id 
AND statsproduced.stat_name = 'PA' INTO pts_allowed;

CASE
    WHEN pts_allowed = NULL THEN RETURN 0;
	WHEN pts_allowed = 0 THEN RETURN 5;
    WHEN pts_allowed >= 1 AND pts_allowed <= 6 THEN RETURN 4;
    WHEN pts_allowed >= 7 AND pts_allowed <= 13 THEN RETURN 3;
    WHEN pts_allowed >= 14 AND pts_allowed <= 17 THEN RETURN 1;
    WHEN pts_allowed >= 28 AND pts_allowed <= 34 THEN RETURN -1;
    WHEN pts_allowed >= 35 AND pts_allowed <= 45 THEN RETURN -3;
    WHEN pts_allowed >= 46 THEN RETURN -5;
    ELSE RETURN 0;
    END CASE;

END //


DELIMITER ;
drop function if exists get_pts_for_stat;
DELIMITER //
create function get_pts_for_stat(stat_name VARCHAR(5), stat_value INT, rec_value INT)
RETURNS DECIMAL(5, 2)
BEGIN

CASE stat_name
	WHEN 'RY' THEN RETURN stat_value * 0.1;
    WHEN 'RTD' THEN RETURN stat_value * 6;
    WHEN 'REC' THEN RETURN stat_value * rec_value;
    WHEN 'REY' THEN RETURN stat_value * 0.1;
    WHEN 'RETD' THEN RETURN stat_value * 6;
    WHEN 'FUML' THEN RETURN stat_value * -2;
    WHEN 'PY' THEN RETURN stat_value * 0.04;
    WHEN 'PTD' THEN RETURN stat_value * 4;
    WHEN 'INT' THEN RETURN stat_value * -2;
    WHEN 'SK' THEN RETURN stat_value * 1;
    WHEN 'DINT' THEN RETURN stat_value * 2;
    WHEN 'FR' THEN RETURN stat_value * 2;
    WHEN 'DTD' THEN RETURN stat_value *4;
    WHEN 'KRTD' THEN RETURN stat_value * 6;
    WHEN 'PRTD' THEN RETURN stat_value * 6;
	WHEN 'SF' THEN RETURN stat_value * 2;
    
    WHEN 'DYA' THEN RETURN (SELECT get_defensive_ya_points(stat_value));
    WHEN 'PA' THEN RETURN (SELECT get_defensive_pa_points(stat_value));
    
    ELSE RETURN 0;
	END CASE;
END//

DELIMITER ;
drop function if exists get_fantasy_points;
DELIMITER //
create function get_fantasy_points(scoring_id INT, weekstats_id INT)
RETURNS DECIMAL(5, 2)
BEGIN
declare reception_pts INT DEFAULT 0;
declare total_pts DECIMAL(5, 2) DEFAULT 0;
declare yds_allowed INT;
declare pts_allowed INT;
DECLARE week_id INT;
DECLARE stat_name VARCHAR(5);
DECLARE stat_total INT;
DECLARE done INT DEFAULT FALSE;
DECLARE cur1 CURSOR FOR SELECT * FROM statsproduced WHERE statsproduced.weekstats_id = weekstats_id;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;


CASE
	WHEN (SELECT scoring_name FROM scoring WHERE scoring.scoring_id = scoring_id) = 'standard' THEN set reception_pts = 0;
    ELSE set reception_pts = 1;
    END CASE;

OPEN cur1;
read_loop: LOOP
    FETCH cur1 INTO week_id, stat_name, stat_total;
    IF done THEN
		LEAVE read_loop;
	END IF;
    SET total_pts = total_pts + (SELECT get_pts_for_stat(stat_name, stat_total, reception_pts));
END loop;
CLOSE cur1;
RETURN total_pts;
END//
