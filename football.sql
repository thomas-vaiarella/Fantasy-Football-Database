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
    
    declare exit handler for not found begin end;
    
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
    
    IF (team1 IS NOT NULL) AND
    (team2 IS NOT NULL) AND
    (team3 IS NOT NULL) AND
    (team4 IS NOT NULL) AND
    (team5 IS NOT NULL) AND
    (team6 IS NOT NULL) AND
    (team7 IS NOT NULL) AND
    (team8 IS NOT NULL) AND
    (team9 IS NOT NULL) THEN
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
    end if;
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
    'NYG', 'JAX', 'NYJ', 'DET', 'GB', 'CAR', 'NE', 'OAK', 'LA', 'BAL', 'WAS', 'NO', 'SEA', 'PIT', 'HOU', 'TEN', 'MIN', ''),
    player_position enum('QB', 'RB', 'WR', 'TE', 'DEF', 'K')
);

use connollynfldata;
describe player;

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

drop trigger if exists before_insert_slot;
delimiter //
create trigger before_insert_slot before insert on slot
for each row
begin
	declare league_id int;
    declare team_id int;
    declare week int;
    declare slots_filled_of_type int;
    declare position varchar(3);
    declare error_message varchar(100) default "No error.";
    
    # find out what league we're in
    select t.league_id into league_id
    from team t join lineup li using(team_id)
	where li.lineup_id = NEW.lineup_id;
    
    # find out what team we're in
    select l.team_id into team_id
	from lineup l
	where l.lineup_id = NEW.lineup_id;
    
    # find out what week this is
    select l.week_num into week
    from lineup l
    where l.lineup_id = NEW.lineup_id;
    
    # find out this player's position
    select p.player_position into position
    from player p
    where p.player_id = NEW.player_id;
    
    # don't allow an insert into a locked (old) lineup.
    if NEW.lineup_id <> current_lineup(team_id)
    then
		signal sqlstate '45000' set message_text = 'Cannot edit a lineup other than the current one.';
    end if;

	# check that the player is available
	if not player_is_available(NEW.player_id, league_id, week)
    then
    signal sqlstate '45000' set message_text = 'That player is not available.';
    end if;
    
    # find the number of slots filled of this type for this lineup
    select count(*) into slots_filled_of_type
    from slot s join lineup li using(lineup_id)
			join player p using(player_id)
	where li.lineup_id = NEW.lineup_id AND NEW.starting_or_not = s.starting_or_not AND 
    (NEW.starting_or_not = 0 OR p.player_position = position); # bench players can have any position
    
    if NEW.starting_or_not = 0
    then # check there are only 6 bench players after this insert.
		if slots_filled_of_type > 5
        then
			signal sqlstate '45000' set message_text = 'The bench is full.';
        end if;  
	else # check each position for the proper number of starters.
		case position
        when 'QB' then
			if slots_filled_of_type > 0
            then 
				signal sqlstate '45000' set message_text = 'Already have one starting QB.';
			end if;
		when 'RB' then
			if slots_filled_of_type > 1
            then 
				signal sqlstate '45000' set message_text = 'Already have two starting RBs.';
			end if;
		when 'WR' then
			if slots_filled_of_type > 2
            then 
				signal sqlstate '45000' set message_text = 'Already have three starting WRs.';
			end if;
		when 'TE' then
			if slots_filled_of_type > 0
            then 
				signal sqlstate '45000' set message_text = 'Already have one starting TE.';
			end if;
		when 'K' then
			if slots_filled_of_type > 0
            then 
				signal sqlstate '45000' set message_text = 'Already have one starting K.';
			end if;
		when 'DEF' then
			if slots_filled_of_type > 0
            then 
				signal sqlstate '45000' set message_text = 'Already have one starting DEF.';
			end if;
		else
			set error_message = concat("Player has invalid position: ", ifnull(position, 'NULL'));
			signal sqlstate '45000' set message_text = error_message;
		end case;
    end if;
    
end //
delimiter ;




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
declare continue handler for sqlexception
	update statsproduced set weekstats_id = given_week_stats_id, 
								stat_name = given_stat_name, 
                                stat_total = given_stat_value
						where weekstats_id = given_week_stats_id and
								stat_name = given_stat_name;

INSERT INTO statsproduced
VALUES (given_week_stats_id, given_stat_name, given_stat_value);
end //

DELIMITER ;
drop function if exists get_defensive_ya_pts;
DELIMITER //
create function get_defensive_ya_pts(yds_allowed INT)
RETURNS INT
BEGIN

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
create function get_defensive_pa_pts(pts_allowed INT)
RETURNS INT
BEGIN

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
    WHEN 'FG0' THEN RETURN stat_value * 3;
    WHEN 'FG40' THEN RETURN stat_value * 4;
    WHEN 'FG50' THEN RETURN stat_value * 5;
	WHEN 'FGM' THEN RETURN stat_value * -1;
    WHEN 'PAT' THEN RETURN stat_value * 1;
	WHEN 'PATM' THEN RETURN stat_value * -1;
    
	WHEN 'DYA' THEN RETURN get_defensive_ya_pts(stat_value);
    WHEN 'PA' THEN RETURN get_defensive_pa_pts(stat_value);
    
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
delimiter ;

drop function if exists get_lineup_id;
delimiter //
create function get_lineup_id(team_id int, week int)
returns int
begin 
	declare l_id int default -1;
    
    if week < 1 OR week > 17
    then
	signal sqlstate '45000' set message_text = 'Week must be between 1 and 17.';
    end if;
    
	select lineup_id into l_id
    from lineup
    where week_num = week and lineup.team_id = team_id;
    
    if l_id <> -1
    then return l_id;
    end if;
    
    insert into lineup values (lineup_id, week, team_id);
    return last_insert_id();
end //
delimiter ;

drop function if exists player_is_available;
delimiter //
create function player_is_available(player_id int, league_id int, week int)
returns boolean
begin 
return player_id not in 
(select s.player_id
 from league le join team t using(league_id)
				join lineup li using(team_id)
				join slot s using(lineup_id)
 where le.league_id = league_id and
		week_num = week);
end //

delimiter ;

drop procedure if exists add_player_to_lineup;
delimiter //
create procedure add_player_to_lineup(p_id int, team_id int)
begin
	declare league_id int;
    declare lineup_id int;
    
    # add the player as a backup if necessary.
    declare continue handler for sqlstate '45000'
		insert into slot values (lineup_id, p_id, 0);
    
    # get the league for this team.
    select l.league_id into league_id
    from team join league l using(league_id)
    where team.team_id = team_id
    limit 1;
    
    # find the lineup to insert the player into.
    select current_lineup(team_id) into lineup_id;
    
    # add the player as a starter if possible, using the continue
    # handler when this fails.
    insert into slot values (lineup_id, p_id, 1);
    
end //
delimiter ;

drop function if exists current_lineup;
delimiter //
create function current_lineup(team_id int)
returns int
begin
	declare latest_lineup int;
    
    select lineup_id into latest_lineup
    from lineup join team using(team_id)
    where team.team_id = team_id
    order by week_num desc
    limit 1;

	return latest_lineup;
end //

delimiter ;

drop function if exists points_for_lineup;
delimiter //
create function points_for_lineup(lineup_id int)
returns decimal(5, 2)
begin
    declare scoring int;
    declare total_points decimal(5, 2);
    
    select scoring_id
    into scoring
    from lineup join team using(team_id)
				join league using(league_id)
	where lineup.lineup_id = lineup_id;
    
    select sum(get_fantasy_points(scoring, weekstats_id))
    into total_points
    from slot join weekstats using(player_id)
				join lineup using(lineup_id)
	where slot.lineup_id = lineup_id and
			lineup.lineup_id = lineup_id and
            weekstats.week_num = lineup.week_num and
            starting_or_not = 1;
	
    return total_points;
end //
delimiter ;

drop function if exists get_team_wins;
delimiter //
create function get_team_wins(team_id int)
returns INT
begin
	declare wins int DEFAULT 0;
    declare this_team_pts decimal(5, 2);
    declare opponent_team_id INT;
    declare current_week_num INT;
    declare opponent_pts decimal(5, 2);
    declare opponent_lineup_id INT;
    declare this_team_lineup_id INT;
    DECLARE done INT DEFAULT FALSE;
	DECLARE cur1 CURSOR FOR SELECT week_num, team2_id FROM matchup WHERE team1_id = team_id;
	DECLARE cur2 CURSOR FOR SELECT week_num, team1_id FROM matchup WHERE team2_id = team_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
OPEN cur1;
read_loop: LOOP
    FETCH cur1 INTO current_week_num, opponent_team_id;
    IF done THEN
		LEAVE read_loop;
	END IF;
    
    # Retrieves lineup IDs for each lineup in the matchup that week.
    SELECT lineup_id INTO this_team_lineup_id FROM lineup WHERE current_week_num = lineup.week_num AND team_id = lineup.team_id;
    SELECT lineup_id INTO opponent_lineup_id FROM lineup WHERE current_week_num = lineup.week_num AND opponent_team_id = lineup.team_id;
    
    # Calculates the points for the two head to head lineups
    SELECT points_for_lineup(this_team_lineup_id) INTO this_team_pts;
    SELECT points_for_lineup(opponent_lineup_id) INTO opponent_pts;
    
    # Resets lineup IDs to avoid duplication
    SET this_team_lineup_id = NULL;
    SET opponent_lineup_id = NULL;
    
    IF this_team_pts > opponent_pts THEN
		SET wins = wins + 1;
	END IF;
END loop;
CLOSE cur1;

SET done = FALSE;

OPEN cur2;
read_loop: LOOP
	FETCH cur2 INTO current_week_num, opponent_team_id;
    IF done THEN
		LEAVE read_loop;
	END IF;
    
    # Retrieves lineup IDs for each lineup in the matchup that week.
    SELECT lineup_id INTO this_team_lineup_id FROM lineup WHERE current_week_num = week_num AND team_id = lineup.team_id;
    SELECT lineup_id INTO opponent_lineup_id FROM lineup WHERE current_week_num = week_num AND opponent_team_id = lineup.team_id;
    
    # Calculates the points for the two head to head lineups
    SELECT points_for_lineup(this_team_lineup_id) INTO this_team_pts;
    SELECT points_for_lineup(opponent_lineup_id) INTO opponent_pts;
    
	# Resets lineup IDs to avoid duplication
    SET this_team_lineup_id = NULL;
    SET opponent_lineup_id = NULL;
    
    IF this_team_pts > opponent_pts THEN
		SET wins = wins + 1;
	END IF;
END loop;
CLOSE cur2;
RETURN wins;
END//    
DELIMITER ;

drop function if exists get_team_losses;
delimiter //
create function get_team_losses(team_id int)
returns INT
begin
	declare losses int DEFAULT 0;
    declare this_team_pts decimal(5, 2);
    declare opponent_team_id INT;
    declare current_week_num INT;
    declare opponent_pts decimal(5, 2);
    declare opponent_lineup_id INT;
    declare this_team_lineup_id INT;
    DECLARE done INT DEFAULT FALSE;
	DECLARE cur1 CURSOR FOR SELECT week_num, team2_id FROM matchup WHERE team1_id = team_id;
	DECLARE cur2 CURSOR FOR SELECT week_num, team1_id FROM matchup WHERE team2_id = team_id;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
OPEN cur1;
read_loop: LOOP
    FETCH cur1 INTO current_week_num, opponent_team_id;
    IF done THEN
		LEAVE read_loop;
	END IF;
    
    # Retrieves lineup IDs for each lineup in the matchup that week.
    SELECT lineup_id INTO this_team_lineup_id FROM lineup WHERE current_week_num = lineup.week_num AND team_id = lineup.team_id;
    SELECT lineup_id INTO opponent_lineup_id FROM lineup WHERE current_week_num = lineup.week_num AND opponent_team_id = lineup.team_id;
    
    # Calculates the points for the two head to head lineups
    SELECT points_for_lineup(this_team_lineup_id) INTO this_team_pts;
    SELECT points_for_lineup(opponent_lineup_id) INTO opponent_pts;
    
    # Resets lineup IDs to avoid duplication
    SET this_team_lineup_id = NULL;
    SET opponent_lineup_id = NULL;
    
    IF this_team_pts > opponent_pts THEN
		SET losses = losses + 1;
	END IF;
END loop;
CLOSE cur1;

SET done = FALSE;

OPEN cur2;
read_loop: LOOP
	FETCH cur2 INTO current_week_num, opponent_team_id;
    IF done THEN
		LEAVE read_loop;
	END IF;
    
    # Retrieves lineup IDs for each lineup in the matchup that week.
    SELECT lineup_id INTO this_team_lineup_id FROM lineup WHERE current_week_num = week_num AND team_id = lineup.team_id;
    SELECT lineup_id INTO opponent_lineup_id FROM lineup WHERE current_week_num = week_num AND opponent_team_id = lineup.team_id;
    
    # Calculates the points for the two head to head lineups
    SELECT points_for_lineup(this_team_lineup_id) INTO this_team_pts;
    SELECT points_for_lineup(opponent_lineup_id) INTO opponent_pts;
    
	# Resets lineup IDs to avoid duplication
    SET this_team_lineup_id = NULL;
    SET opponent_lineup_id = NULL;
    
    IF this_team_pts < opponent_pts THEN
		SET losses = losses + 1;
	END IF;
END loop;
CLOSE cur2;
RETURN losses;
END//    
DELIMITER ;

drop procedure if exists advance_lineup;
delimiter //
create procedure advance_lineup(lineup_to_advance int)
begin
	declare current_week int;
    declare current_team_id int;
    declare new_lineup_id int;
    
    declare current_slot_player int;
    declare current_slot_starting tinyint;
    declare done bool default false;
    
    declare all_slots cursor for
		select player_id, starting_or_not
        from slot 
        where lineup_id = lineup_to_advance;
    
    declare continue handler for not found
    begin
		set done = true;
    end;
    
    # create the new lineup
    select week_num into current_week
    from lineup
    where lineup_id = lineup_to_advance;
    
    select team_id into current_team_id
    from lineup
    where lineup_id = lineup_to_advance;
    
    insert into lineup values(lineup_id, current_week + 1, current_team_id);
    set new_lineup_id = last_insert_id();
    
    open all_slots;
    # duplicate all of the old slots
	read_loop: loop
		fetch all_slots into current_slot_player, current_slot_starting;
        if done then
			leave read_loop;
		end if;
        
        insert into slot values (new_lineup_id, current_slot_player, current_slot_starting);    
    end loop;
    close all_slots;
end //
delimiter ;

drop procedure if exists advance_lineups_in_league;
delimiter //
create procedure advance_lineups_in_league(league int, to_week int)
begin
	declare current_team_id int;
    declare current_lineup_id int;
    declare current_lineup_week int;
    declare done bool default false;
    
	declare all_teams cursor for 
		select team_id 
		from team 
        where league_id = league;
    
    declare continue handler for not found
    begin
		set done = true;
	end;
    
    open all_teams;
    # iterate over all teams in the league
    read_loop: loop
		fetch all_teams into current_team_id;
        if done then
			leave read_loop;
        end if;
        
        # advance the lineup of this team until it's at to_week
        advance_lineup_loop: loop
			select current_lineup(current_team_id) into current_lineup_id;
        
			select week_num into current_lineup_week
			from lineup
			where lineup_id = current_lineup_id;
        
			if current_lineup_week >= to_week
            then
				leave advance_lineup_loop;
            end if;
            
            call advance_lineup(current_lineup_id);
        end loop;
    end loop;
    close all_teams;    
end //
delimiter ;


drop procedure if exists weekly_scores;
delimiter //
create procedure weekly_scores(league int, week int)
begin 
	# we can use this as a basis for weekly scores across a league
	select m.team1_id, points_for_lineup(lt1.lineup_id) as team1_pts, 
            m.team2_id, points_for_lineup(lt2.lineup_id) as team2_points
	from league l join team t using(league_id)
					join matchup m on (t.team_id = m.team1_id)
                    join lineup lt1 on (lt1.team_id = m.team1_id and lt1.week_num = m.week_num)
					join lineup lt2 on (lt2.team_id = m.team2_id and lt2.week_num = m.week_num)
	where m.week_num = week and l.league_id = league
	order by m.team1_id;
end //
delimiter ;

drop function if exists season_points_for_team;
delimiter //
create function season_points_for_team(team int)
returns decimal(6, 2)
begin
	declare total_points decimal(6, 2) default 0;
    declare current_lineup_id int;
    declare done bool default false;
    
    declare team_lineups cursor for
		select lineup_id
        from lineup
        where team_id = team;
	
    declare continue handler for not found
		set done = true;
	
    open team_lineups;
    
    read_loop: loop
		if done then
			leave read_loop;
        end if;
        
        fetch team_lineups into current_lineup_id;
        
        set total_points = total_points + points_for_lineup(current_lineup_id);
    end loop;
    close team_lineups;
    
    return total_points;
end //
delimiter ;

drop procedure if exists current_players_in_lineup;
delimiter //
create procedure current_players_in_lineup (team_id int)
begin
	declare lineup_id int;
    
    select current_lineup(team_id) into lineup_id;
	
    select player_id, player_name, player_position, player_team, starting_or_not
    from slot join player using(player_id)
    where slot.lineup_id = lineup_id
    order by starting_or_not desc, player_position;
    
end //
delimiter ;

drop procedure if exists matchup_for_week;
delimiter //
create procedure matchup_for_week(team_id int, week_num int)
begin
	declare scoring int default 0;
    declare other_team_id int;
    declare team_lineup int;
    declare other_lineup int;
    
    select scoring_id into scoring
    from league join team using (league_id)
    where team.team_id = team_id
    limit 1;
            
	(select 1 as team, m.team1_id as team_id, p.player_id, player_name, player_position,
			starting_or_not, get_fantasy_points(scoring, weekstats_id) as points
	from (matchup m join lineup l1 on (l1.team_id = team1_id and l1.week_num = week_num)
					join slot s1 on (s1.lineup_id = l1.lineup_id)
					join player p using(player_id)
					join weekstats w on (w.player_id = p.player_id and w.week_num = week_num))
	where m.week_num = week_num and 
			(m.team1_id = team_id or m.team2_id = team_id)
	order by starting_or_not desc, player_position)
            
	union all 
    
	(select 2 as team, m.team2_id as team_id, p.player_id, player_name, player_position, 
			starting_or_not, get_fantasy_points(scoring, weekstats_id) as points
	from (matchup m join lineup l1 on (l1.team_id = team2_id and l1.week_num = week_num)
				join slot s1 on (s1.lineup_id = l1.lineup_id)
				join player p using(player_id)
				join weekstats w on (w.player_id = p.player_id and w.week_num = week_num))
	where m.week_num = week_num and 
			(m.team1_id = team_id or m.team2_id = team_id)
	order by starting_or_not desc, player_position)
    
	order by team, starting_or_not desc, field(player_position, 'QB', 'RB', 'WR', 'TE', 'DEF', 'K');
end //
delimiter ;

drop procedure if exists drop_player_to_fa;
delimiter //
create procedure drop_player_to_fa(player_id INT, team_id INT)
BEGIN
DELETE FROM slot WHERE lineup_id = (SELECT current_lineup(team_id)) AND slot.player_id = player_id;
END //

delimiter ;
drop procedure if exists swap_slots;
delimiter //
create procedure swap_slots(player_id1 INT, player_id2 INT, team_id INT)
BEGIN
DECLARE player_1_starting INT;
DECLARE player_2_starting INT;

IF (SELECT player_position FROM player WHERE player_id = player_id1) 
= (SELECT player_position FROM player WHERE player_id = player_id1)
THEN
	SET player_1_starting = (SELECT starting_or_not FROM slot WHERE lineup_id = (SELECT current_lineup(team_id)) AND player_id = player1_id);
    SET player_2_starting = (SELECT starting_or_not FROM slot WHERE lineup_id = (SELECT current_lineup(team_id)) AND player_id = player2_id);
	
    IF player_1_starting != player_2_starting THEN 
		UPDATE slot SET starting_or_not = player_1_starting WHERE lineup_id = (SELECT current_lineup(team_id)) AND player_id = player2_id;
        UPDATE slot SET starting_or_not = player_2_starting WHERE lineup_id = (SELECT current_lineup(team_id)) AND player_id = player1_id;
	END IF;
END IF;
END //

delimiter ;
drop procedure if exists bench_player;
delimiter //
create procedure bench_player(player_id INT, team_id INT)
begin
	UPDATE slot SET starting_or_not = 0 WHERE lineup_id = (SELECT current_lineup(team_id)) AND slot.player_id = player_id;
end //

delimiter ;
drop procedure if exists start_player;
delimiter //
create procedure start_player(player_id INT, team_id INT)
begin
	UPDATE slot SET starting_or_not = 1 WHERE lineup_id = (SELECT current_lineup(team_id)) AND slot.player_id = player_id;
end //

delimiter ;
drop procedure if exists bench_entire_lineup;
delimiter //
create procedure bench_entire_lineup(team_id INT)
begin
	UPDATE slot SET starting_or_not = 0 WHERE lineup_id = (SELECT current_lineup(team_id));
end //

delimiter ;
drop procedure if exists join_leauge;
delimiter //
create procedure join_league(league_id INT, team_id INT)
begin
	UPDATE team SET league_id = league_id WHERE team.team_id = team_id;
end //

# Returns a formatted matchup score varchar
delimiter ;
drop function if exists get_matchup_score;
delimiter //
create function get_matchup_score(week_num INT, team_id_1 INT, team_id_2 INT)
returns VARCHAR(45)
begin
	DECLARE team_1_pts  DECIMAL(5, 2);
	DECLARE team_2_pts DECIMAL(5, 2) ;
	SELECT points_for_lineup((SELECT lineup_id FROM lineup WHERE team_id = team_id_1 AND lineup.week_num = week_num)) INTO team_1_pts;
    SELECT points_for_lineup((SELECT lineup_id FROM lineup WHERE team_id = team_id_2 AND lineup.week_num = week_num)) INTO team_2_pts;
    
    RETURN CONCAT(team_1_pts, ' - ',  team_2_pts);
end //

# Returns a formatted season-long record varchar
delimiter ;
drop function if exists get_record;
delimiter //
create function get_record(team_id INT)
returns VARCHAR(45)
begin
    RETURN CONCAT('SEASON RECORD: ', (SELECT get_team_wins(team_id)), ' - ',  (SELECT get_team_losses(team_id)));
end //

delimiter ;