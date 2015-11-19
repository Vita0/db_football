ALTER TABLE matches
	ADD first_club_yellow SMALLINT; /*жЄлтые карточки*/
ALTER TABLE matches
	ADD second_club_yellow SMALLINT;
	
ALTER TABLE matches
	ADD first_club_red SMALLINT; /*красные карточки*/
ALTER TABLE matches
	ADD second_club_red SMALLINT;
	
ALTER TABLE matches
	ADD first_club_percent SMALLINT; /*владение м€чом*/
	
ALTER TABLE matches
	ADD first_club_pressure SMALLINT; /*владение на чужой половине (% от своего владени€, а не от времени всего матча)*/
ALTER TABLE matches
	ADD second_club_pressure SMALLINT;

ALTER TABLE matches
	ADD first_club_shorts SMALLINT; /*удары*/
ALTER TABLE matches
	ADD second_club_shorts SMALLINT;

ALTER TABLE matches
	ADD first_club_shorts_in_target SMALLINT; /*удары в створ*/
ALTER TABLE matches
	ADD second_club_shorts_in_target SMALLINT;


	
/*
CREATE TABLE yellow_cards
	(match_id INTEGER REFERENCES matches(match_id),
	 player_id INTEGER REFERENCES players(player_id),
	 card_minute SMALLINT
	);
commit;

CREATE TABLE red_cards
	(match_id INTEGER REFERENCES matches(match_id),
	 player_id INTEGER REFERENCES players(player_id),
	 card_minute SMALLINT
	);
commit;

INSERT INTO yellow_cards (match_id, player_id, card_minute)
	VALUES(1,1,25);
INSERT INTO yellow_cards (match_id, player_id, card_minute)
	VALUES(1,1,90);
	
INSERT INTO red_cards (match_id, player_id, card_minute)
	VALUES(1,1,90);
*/
