/*индексы*/
/*
CREATE [UNIQUE] [ASC[ENDING] | DESC[ENDING]]
INDEX indexname ON tablename
{(col [, col …]) | COMPUTED BY (<expression>)}; 
*/
CREATE ASC
INDEX matches_match_date ON matches(match_date);

CREATE ASC
INDEX matches_first_club_goals ON matches(first_club_goals);

CREATE ASC
INDEX matches_second_club_goals ON matches(second_club_goals);

ALTER INDEX matches_match_date INACTIVE;

ALTER INDEX matches_first_club_goals INACTIVE;

ALTER INDEX matches_second_club_goals INACTIVE;
/*
CREATE INDEX matches_first_club_wins ON matches COMPUTED BY (first_club_goals > second_club_goals);

CREATE INDEX matches_second_club_wins ON matches COMPUTED BY (first_club_goals < second_club_goals);
*/

/*денормализация*/
ALTER TABLE matches
ADD first_club_goals_minus_second SMALLINT;

UPDATE matches
SET first_club_goals_minus_second = first_club_goals - second_club_goals;


CREATE OR ALTER VIEW SELECTTOPCLUBS_OPT(
    NAME,
    WINS)
AS
select clubs.name, wins from
        (
        select first 5 cid, count(cid) wins from
            (
            select first_club_id cid from matches
                where matches.match_date between '01-SEP-2015' and '31-DEC-2015'
                  and matches.first_club_goals_minus_second > 0
            union all
            select second_club_id cid from matches
                where matches.match_date between '01-SEP-2015' and '31-DEC-2015'
                  and matches.first_club_goals_minus_second < 0
            )
        group by cid order by wins desc
        )
        , clubs
    where clubs.club_id = cid;


/*новая таблица*/
CREATE TABLE MATCHES_OPT (
    MATCH_ID                       INTEGER NOT NULL,
    MATCH_DATE                     DATE,
    SEASON_ID                      INTEGER,
    FIRST_CLUB_ID                  INTEGER,
    SECOND_CLUB_ID                 INTEGER,
    FIRST_CLUB_PERCENT             SMALLINT,
    FIRST_CLUB_SHORTS              SMALLINT,
    SECOND_CLUB_SHORTS             SMALLINT,
    FIRST_CLUB_GOALS               SMALLINT,
    SECOND_CLUB_GOALS              SMALLINT,
    FIRST_CLUB_GOALS_MINUS_SECOND  SMALLINT
);

CREATE GENERATOR gen_match_id_opt;
SET GENERATOR gen_match_id_opt TO 0;
set term !! ;
CREATE TRIGGER MATCHES_OPT_BI FOR matches_opt
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN
NEW.match_id = GEN_ID(gen_match_id_opt, 1);
END!!
set term ; !!

INSERT INTO matches_opt(
                            MATCH_DATE                     ,
                            SEASON_ID                      ,
                            FIRST_CLUB_ID                  ,
                            SECOND_CLUB_ID                 ,
                            FIRST_CLUB_PERCENT             ,
                            FIRST_CLUB_SHORTS              ,
                            SECOND_CLUB_SHORTS             ,
                            FIRST_CLUB_GOALS               ,
                            SECOND_CLUB_GOALS              ,
                            FIRST_CLUB_GOALS_MINUS_SECOND   
                        )
SELECT
                            MATCH_DATE                     ,
                            SEASON_ID                      ,
                            FIRST_CLUB_ID                  ,
                            SECOND_CLUB_ID                 ,
                            FIRST_CLUB_PERCENT             ,
                            FIRST_CLUB_SHORTS              ,
                            SECOND_CLUB_SHORTS             ,
                            FIRST_CLUB_GOALS               ,
                            SECOND_CLUB_GOALS              ,
                            FIRST_CLUB_GOALS_MINUS_SECOND   
FROM matches;

/*заполнение*/
INSERT INTO matches(first_club_goals_minus_second)
SELECT first_club_goals - second_club_goals FROM matches;

/*запрос*/
CREATE OR ALTER VIEW SELECTTOPCLUBS_OPT(
    NAME,
    WINS)
AS
select clubs.name, wins from
        (
        select first 5 cid, count(cid) wins from
            (
            select first_club_id cid from matches_opt
                where matches_opt.match_date between '01-SEP-2015' and '31-DEC-2015'
                  and matches_opt.first_club_goals_minus_second > 0
            union all
            select second_club_id cid from matches_opt
                where matches_opt.match_date between '01-SEP-2015' and '31-DEC-2015'
                  and matches_opt.first_club_goals_minus_second < 0
            )
        group by cid order by wins desc
        )
        , clubs
    where clubs.club_id = cid;

/*быстродействие опт запроса*/
Plan
PLAN JOIN (SORT ((SELECTTOPCLUBS_OPT MATCHES_OPT NATURAL)
PLAN (SELECTTOPCLUBS_OPT MATCHES_OPT NATURAL)), SELECTTOPCLUBS_OPT CLUBS INDEX (RDB$PRIMARY2))

Adapted Plan
PLAN JOIN (SORT ((SELECTTOPCLUBS_OPT MATCHES_OPT NATURAL)
PLAN (SELECTTOPCLUBS_OPT MATCHES_OPT NATURAL)), SELECTTOPCLUBS_OPT CLUBS INDEX (INTEG_5))

------ Performance info ------
Prepare time = 15ms
Execute time = 297ms
Avg fetch time = 59,40 ms
Current memory = 10 062 048
Max memory = 15 071 200
Memory buffers = 2 048
Reads from disk to cache = 0
Writes from cache to disk = 0
Fetches from cache = 405 882


/*добавление индекса*/
CREATE ASC
INDEX matches_match_date ON matches_opt(match_date);

/*добавление индекса*/
CREATE ASC
INDEX first_club_goals_minus_sec_idx ON matches_opt(first_club_goals_minus_second);

