ALTER TABLE matches
	ADD first_club_yellow SMALLINT; /*����� ��������*/
ALTER TABLE matches
	ADD second_club_yellow SMALLINT;
	
ALTER TABLE matches
	ADD first_club_red SMALLINT; /*������� ��������*/
ALTER TABLE matches
	ADD second_club_red SMALLINT;
	
ALTER TABLE matches
	ADD first_club_percent SMALLINT; /*�������� �����*/
	
ALTER TABLE matches
	ADD first_club_pressure SMALLINT; /*�������� �� ����� �������� (% �� ������ ��������, � �� �� ������� ����� �����)*/
ALTER TABLE matches
	ADD second_club_pressure SMALLINT;

ALTER TABLE matches
	ADD first_club_shorts SMALLINT; /*�����*/
ALTER TABLE matches
	ADD second_club_shorts SMALLINT;

ALTER TABLE matches
	ADD first_club_shorts_in_target SMALLINT; /*����� � �����*/
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
