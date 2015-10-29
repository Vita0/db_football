SET NAMES CYRL;
create database 'E:\Program Files\Firebird\db\sport_IS.fdb'
user 'SYSDBA' password 'masterkey'
DEFAULT CHARACTER SET CYRL;

connect 'E:\Program Files\Firebird\db\sport_IS.fdb'
user 'SYSDBA' password 'masterkey';
commit;


CREATE DOMAIN pos_type
AS varchar(10) CHECK (value IS NULL or VALUE IN 
	('Goalkeeper', 'Defender', 'Midfielder', 'Forward', 'Coach'));

CREATE DOMAIN league_type
AS varchar(10) CHECK (value IS NULL or VALUE IN
	('World', 'Continent', 'Country', 'City'));


CREATE TABLE players
	(player_id INTEGER NOT NULL PRIMARY KEY,
	 name VARCHAR(16) NOT NULL,
	 birthdate DATE,
	 pos pos_type
	);
commit;

CREATE TABLE clubs
	(club_id INTEGER NOT NULL PRIMARY KEY,
	 name VARCHAR(16) NOT NULL,
	 birthdate DATE,
	 nickname VARCHAR(17),
	 country VARCHAR(16)
	);
commit;

CREATE TABLE leagues
	(league_id INTEGER NOT NULL PRIMARY KEY,
	 name VARCHAR(16) NOT NULL,
	 kind league_type
	);
commit;

CREATE TABLE seasons
	(season_id INTEGER NOT NULL PRIMARY KEY,
	 league_id INTEGER REFERENCES leagues(league_id),
	 period VARCHAR(9)
	);
commit;

CREATE TABLE matches
	(match_id INTEGER NOT NULL PRIMARY KEY,
	 match_date DATE,
	 season_id INTEGER REFERENCES seasons(season_id),
	 first_club_id INTEGER REFERENCES clubs(club_id),
	 second_club_id INTEGER REFERENCES clubs(club_id),
	 first_club_goals SMALLINT,
	 second_club_goals SMALLINT
	);
commit;

CREATE TABLE goals
	(goal_id INTEGER NOT NULL PRIMARY KEY,
	 player_id INTEGER REFERENCES players(player_id),
	 match_id INTEGER REFERENCES matches(match_id),
	 goal_minute INTEGER,
	 autogoal CHAR(1)
	);
commit;

CREATE TABLE standings
	(season_id INTEGER REFERENCES seasons(season_id),
	 club_id INTEGER REFERENCES clubs(club_id),
	 victories SMALLINT,
	 draws SMALLINT,
	 losses SMALLINT,
	 goals SMALLINT,
	 missed_goals SMALLINT,
	 diff_goals SMALLINT,
	 points SMALLINT
	);
commit;

CREATE TABLE club_players_list_history
	(club_id INTEGER REFERENCES clubs(club_id),
	 player_id INTEGER REFERENCES players(player_id),
	 date_begin DATE NOT NULL,
	 date_end DATE
	);
commit;

CREATE TABLE current_club_players_list
	(club_id INTEGER REFERENCES clubs(club_id),
	 player_id INTEGER REFERENCES players(player_id),
	);
commit;


CREATE GENERATOR gen_player_id;
SET GENERATOR gen_player_id TO 0;
set term !! ;
CREATE TRIGGER PLAYERS_BI FOR players
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
NEW.player_id = GEN_ID(gen_player_id, 1);
END!!
set term ; !!

CREATE GENERATOR gen_club_id;
SET GENERATOR gen_club_id TO 0;
set term !! ;
CREATE TRIGGER CLUBS_BI FOR clubs
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
NEW.club_id = GEN_ID(gen_club_id, 1);
END!!
set term ; !!

CREATE GENERATOR gen_league_id;
SET GENERATOR gen_league_id TO 0;
set term !! ;
CREATE TRIGGER LEAGUES_BI FOR leagues
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
NEW.league_id = GEN_ID(gen_league_id, 1);
END!!
set term ; !!

CREATE GENERATOR gen_season_id;
SET GENERATOR gen_season_id TO 0;
set term !! ;
CREATE TRIGGER SEASONS_BI FOR seasons
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
NEW.season_id = GEN_ID(gen_season_id, 1);
END!!
set term ; !!

CREATE GENERATOR gen_match_id;
SET GENERATOR gen_match_id TO 0;
set term !! ;
CREATE TRIGGER MATCHES_BI FOR matches
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
NEW.match_id = GEN_ID(gen_match_id, 1);
END!!
set term ; !!

CREATE GENERATOR gen_goal_id;
SET GENERATOR gen_goal_id TO 0;
set term !! ;
CREATE TRIGGER GOALS_BI FOR goals
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
NEW.goal_id = GEN_ID(gen_goal_id, 1);
END!!
set term ; !!

/*
CREATE GENERATOR gen_standing_id;
SET GENERATOR gen_standing_id TO 0;
set term !! ;  STANDINGS
CREATE TRIGGER STANDINGS_BI FOR standings
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
NEW.standing_id = GEN_ID(gen_standing_id, 1);
END!!
set term ; !!
*/




