SET NAMES WIN1251;
create database 'E:\Program Files\Firebird\db\sport_IS.fdb'
user 'SYSDBA' password 'masterkey'
DEFAULT CHARACTER SET WIN1251;

connect 'E:\Program Files\Firebird\db\sport_IS.fdb'
user 'SYSDBA' password 'masterkey';
commit;

CREATE DOMAIN pos_type
AS varchar(20) CHECK (value IS NULL or VALUE IN 
	('Goalkeeper', 'Defender', 'Midfielder', 'Forward', 'Coach'));

CREATE DOMAIN league_type
AS varchar(20) CHECK (value IS NULL or VALUE IN
	('World', 'Continent', 'Country', 'City'));

CREATE TABLE players
	(player_id INTEGER NOT NULL PRIMARY KEY,
	 name VARCHAR(20) NOT NULL,
	 birthdate DATE,
	 pos pos_type
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

CREATE TABLE clubs
	(club_id INTEGER NOT NULL PRIMARY KEY,
	 name VARCHAR(20) NOT NULL,
	 birthdate DATE,
	 nickname VARCHAR(20),
	 country VARCHAR(20)
	);
commit;

CREATE TABLE leagues
	(leadues_id INTEGER NOT NULL PRIMARY KEY,
	 name VARCHAR(20) NOT NULL,
	 kind league_type
	);
commit;

CREATE TABLE seasons
	(season_id INTEGER NOT NULL PRIMARY KEY,
	 leadues_id INTEGER REFERENCES leagues(leadues_id),
	 period VARCHAR(9)
	);
commit;

CREATE TABLE matches
	(match_id INTEGER NOT NULL PRIMARY KEY,
	 match_date DATE,
	 season_id INTEGER REFERENCES seasons(season_id),
	 first_team_id INTEGER REFERENCES clubs(club_id),
	 second_team_id INTEGER REFERENCES clubs(club_id),
	 first_team_goals INTEGER,
	 second_team_goals INTEGER
	);
commit;

CREATE TABLE goals
	(goal_id INTEGER NOT NULL PRIMARY KEY,
	 match_id INTEGER REFERENCES matches(match_id),
	 goal_minute INTEGER,
	 autogoal CHAR
	);
commit;

CREATE TABLE standings
	(season_id INTEGER REFERENCES seasons(season_id),
	 team_id INTEGER REFERENCES clubs(club_id),
	 victories INTEGER,
	 draws INTEGER,
	 losses INTEGER,
	 goals INTEGER,
	 missed_goals INTEGER,
	 diff_goals INTEGER
	);
commit;

























