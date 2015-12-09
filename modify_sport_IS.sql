CREATE DOMAIN event_type
AS varchar(11) CHECK (value IS NULL or VALUE IN 
	('GOAL', 'YELLOW', 'RED', 'INJURY', 'REPLACEMENT'));
							/* травма    замена */

CREATE TABLE events
	(player_id INTEGER REFERENCES players(player_id),
	 match_id INTEGER REFERENCES matches(match_id),
	 event_minute SMALLINT,
	 event event_type,
	 ag_io CHAR(1)
	);
/* ag_io - GOAL: 1-autogoal, 0-goal;  YELLOW,RED: NULL; INJURY: 1-нанёс травму, 0-получил травму; REPLACEMENT: 1-зашёл на поле, 0-вышел */

insert into events (player_id, match_id, event_minute, ag_io, event)
	select player_id, match_id, goal_minute, autogoal, 'GOAL' from goals;

DROP trigger GOALS_BI;	
DROP generator gen_goal_id;
/*drop view alterPointsInRFPL15_16;
drop view selectSumOfGoalsRFPL15_16;
drop view selectGoalsPlayers;
drop procedure ins_goal;*/
commit;
DROP table goals;
commit;

ALTER TABLE matches
	ADD first_club_percent SMALLINT; /*владение мячом*/

ALTER TABLE matches
	ADD first_club_shorts SMALLINT; /*удары*/
ALTER TABLE matches
	ADD second_club_shorts SMALLINT;

/*ALTER TABLE matches
	ADD first_club_shorts_in_target SMALLINT;*/ /*удары в створ*/
/*ALTER TABLE matches
	ADD second_club_shorts_in_target SMALLINT;*/

ALTER TABLE matches
	DROP first_club_goals;
ALTER TABLE matches
	DROP second_club_goals;
	
ALTER TABLE matches
	ADD first_club_goals SMALLINT;
ALTER TABLE matches
	ADD second_club_goals SMALLINT;
	
commit;


INSERT INTO clubs (name, birthdate, nickname, country)
	VALUES ('CSKA', '5-AUG-1937', 'Armeytci', 'Russia');
INSERT INTO players (name, birthdate, pos) 
	VALUES ('Natho', '2-JUL-1983', 'Midfielder');
INSERT INTO players (name, birthdate, pos) 
	VALUES ('Berezuzkiy V', '7-MAY-1987', 'Defender');
INSERT INTO players (name, birthdate, pos) 
	VALUES ('Movsisyan', '30-OCT-1991', 'Forward');
INSERT INTO matches (match_date, season_id, first_club_id, second_club_id)
	VALUES('30-NOV-2015',1,3,1);
INSERT INTO matches (match_date, season_id, first_club_id, second_club_id)
	VALUES('30-NOV-2015',1,2,3);

INSERT INTO club_players_list_history (club_id, player_id, date_begin, date_end)
	VALUES (1, 3, '15-MAY-2013', NULL);
INSERT INTO club_players_list_history (club_id, player_id, date_begin, date_end)
	VALUES (3, 4, '3-OCT-2015', NULL);
INSERT INTO club_players_list_history (club_id, player_id, date_begin, date_end)
	VALUES (3, 5, '2-NOV-2000', NULL);
INSERT INTO club_players_list_history (club_id, player_id, date_begin, date_end)
	VALUES (2, 6, '1-JUN-2012', NULL);
	
INSERT INTO current_club_players_list (club_id, player_id)
	VALUES (1, 3);
INSERT INTO current_club_players_list (club_id, player_id)
	VALUES (3, 4);
INSERT INTO current_club_players_list (club_id, player_id)
	VALUES (3, 5);
INSERT INTO current_club_players_list (club_id, player_id)
	VALUES (2, 6);
	
INSERT INTO events (player_id, match_id, event_minute, event, ag_io)
	VALUES (4, 2, 7, 'GOAL', 0);
INSERT INTO events (player_id, match_id, event_minute, event, ag_io)
	VALUES (1, 2, 12, 'GOAL', 0);
INSERT INTO events (player_id, match_id, event_minute, event, ag_io)
	VALUES (6, 3, 79, 'GOAL', 0);

/*
spartak 0 2 zenit
cska    1 1 zenit
spartak 1 0 cska
*/
delete from standings where club_id > 0;
INSERT INTO standings (season_id, club_id, victories, draws, losses, goals, missed_goals, diff_goals, points)
	VALUES(1,1,1,1,0,3,1,2,4);
INSERT INTO standings (season_id, club_id, victories, draws, losses, goals, missed_goals, diff_goals, points)
	VALUES(1,2,1,0,1,1,2,-1,3);
INSERT INTO standings (season_id, club_id, victories, draws, losses, goals, missed_goals, diff_goals, points)
	VALUES(1,3,0,1,1,1,2,-1,1);
	
UPDATE matches SET first_club_goals = 0, second_club_goals = 2 where match_id = 1;
UPDATE matches SET first_club_goals = 1, second_club_goals = 1 where match_id = 2;
UPDATE matches SET first_club_goals = 1, second_club_goals = 0 where match_id = 3;
	
	
insert into events (player_id, match_id, event_minute, event, ag_io)
	VALUES (1, 1, 15, 'YELLOW', 0);
insert into events (player_id, match_id, event_minute, event, ag_io)
	VALUES (5, 2, 90, 'RED', 0);
	
ALTER TABLE seasons
ADD CONSTRAINT con_uq unique (league_id, period);
	
	
/*ALTER TABLE matches
	ADD first_club_pressure SMALLINT;*/ /*владение на чужой половине (% от своего владения, а не от времени всего матча)*/
/*ALTER TABLE matches
	ADD second_club_pressure SMALLINT;*/