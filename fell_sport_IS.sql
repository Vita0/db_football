connect 'E:\Program Files\Firebird\db\sport_IS.fdb' 
	user 'SYSDBA' password 'masterkey';

INSERT INTO players (name, birthdate, pos) 
	VALUES ('Dzuba', '22-AUG-1988', 'Forward');
INSERT INTO players (name, birthdate, pos) 
	VALUES ('Kerjakov', '10-JUN-1982', 'Forward');
INSERT INTO players (name, birthdate, pos) 
	VALUES ('Lodigin', '1-JUN-1990', 'Goalkeeper');
	
INSERT INTO clubs (name, birthdate, nickname, country)
	VALUES ('Zenit', '25-MAY-1925', 'Blue-White-Blue', 'Russia');
INSERT INTO clubs (name, birthdate, nickname, country)
	VALUES ('Spartak', '18-APR-1922', 'White-Red', 'Russia');

INSERT INTO leagues (name, kind)
	VALUES ('RFPL', 'Country');

/*lid = (select league_id from leagues where name = 'РФПЛ');*/
INSERT INTO seasons (league_id, period)
	VALUES (1/*lid*/, '2015/2016');

INSERT INTO matches (match_date, season_id, first_club_id, second_club_id, first_club_goals, second_club_goals)
	VALUES('26-SEP-2015',1,2,1,2,2);

INSERT INTO goals (match_id, player_id, goal_minute, autogoal)
	VALUES(1,1,22,0);
INSERT INTO goals (match_id, player_id, goal_minute, autogoal)
	VALUES(1,2,41,0);

INSERT INTO standings (season_id, club_id, victories, draws, losses, goals, missed_goals, diff_goals, points)
	VALUES(1,1,0,1,0,2,2,0,1);
INSERT INTO standings (season_id, club_id, victories, draws, losses, goals, missed_goals, diff_goals, points)
	VALUES(1,2,0,1,0,2,2,0,1);

INSERT INTO club_players_list_history (club_id, player_id, date_begin, date_end)
	VALUES (1, 1, '20-JUL-2015', NULL);
INSERT INTO club_players_list_history (club_id, player_id, date_begin, date_end)
	VALUES (1, 2, '13-MAY-2005', NULL);

INSERT INTO current_club_players_list (club_id, player_id)
	VALUES (1, 1);
INSERT INTO current_club_players_list (club_id, player_id)
	VALUES (1, 2);
	