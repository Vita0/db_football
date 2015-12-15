/*
1
Вывести 5 лучших игроков за заданный сезон по заданному показателю.
*/
create or alter procedure BEST_PLAYER_BY (
    E EVENT_TYPE,
    L varchar(16),
    P varchar(9))
returns (
    NAME varchar(16),
    NUM integer)
as
begin
    for
    select first 5 players.name as name, num1
    from players,
        (select events.player_id as pid, count(player_id) as num1 from events
            where events."EVENT" = :E
              and events.match_id in
                (select match_id from matches where matches.season_id =
                    (select seasons.season_id from seasons, leagues
                    where seasons.league_id = leagues.league_id
                      and leagues.name = :L
                      and seasons.period = :P))
            group by events.player_id order by num1 desc)
    where players.player_id = pid
    into :name, :num
    do suspend;
end;

/*
2
Для каждой команды за выбранный сезон вывести количество выигранных домашних и гостевых матчей.
*/

--выбираем id команд в сезоне
create or alter procedure SEASON_CLUB_BY_LEAGUE_PERIOD (
    L varchar(16),
    P varchar(9))
returns (
    SID integer,
    CID integer)
as
begin
for
    select season_id, club_id from standings
    where season_id =
                    (select seasons.season_id from seasons, leagues   --сезон
                      where seasons.league_id = leagues.league_id
                        and leagues.name = :L
                        and seasons.period = :P)
    into :sid, :cid
    do suspend;
end

--выводим команды, которые имеют ДОМАШНИЕ победы в сезоне, и количество таких побед
create or alter procedure HOME_WINS_BY (
    L varchar(16),
    P varchar(9))
returns (
    NAME varchar(16),
    HOME_WINS integer)
as
begin
    for
    select clubs.name, home_win from
        clubs,
        (select first_club_id, count(first_club_id) as home_win
         from matches, SEASON_CLUB_BY_LEAGUE_PERIOD(:L,:P)
         where matches.first_club_id = cid
           and matches.first_club_goals > matches.second_club_goals
           and season_id = sid
         group by first_club_id)
    where clubs.club_id = first_club_id
    into :name, :home_wins
    do suspend;
end

--выводим команды, которые имеют ГОСТЕВЫЕ победы в сезоне, и количество таких побед
create or alter procedure GUEST_WINS_BY (
    L varchar(16),
    P varchar(9))
returns (
    NAME varchar(16),
    GUEST_WINS integer)
as
begin
    for
    select clubs.name, guest_win from
        clubs,
        (select second_club_id, count(second_club_id) as guest_win
         from matches, SEASON_CLUB_BY_LEAGUE_PERIOD(:L,:P)
         where matches.second_club_id = cid
           and matches.first_club_goals < matches.second_club_goals
           and season_id = sid
        group by second_club_id)
    where clubs.club_id = second_club_id
    into :name, :guest_wins
    do suspend;
end

--объединяем список всех команд в сезоне, с количеством ДОМАШНИХ и ГОСТЕВЫХ побед
create or alter procedure HOME_GUEST_WINS_BY (
    L varchar(16),
    P varchar(9))
returns (
    NAME varchar(16),
    HOME_WINS integer,
    GUEST_WINS integer)
as
begin
    for
    select name, home_wins, guest_wins from
    (
        select name, guest_wins from GUEST_WINS_BY(:L,:P)
        union
        select name, 0 from clubs, SEASON_CLUB_BY_LEAGUE_PERIOD(:L,:P)
            where club_id = cid
            and name not in (select name from GUEST_WINS_BY(:L,:P))
    )
    inner join
    (
        select name as name2, home_wins from HOME_WINS_BY(:L,:P)
        union
        select name as name2, 0 from clubs, SEASON_CLUB_BY_LEAGUE_PERIOD(:L,:P)
            where club_id = cid
            and name not in (select name from HOME_WINS_BY(:L,:P))
    )
    on name = name2
    into :name, :home_wins, :guest_wins
    do suspend;
end

/*
3
Определить наиболее эффективных (отношение количества голов и голевых передач ко времени на поле) и грубых (отношение количества желтых и красных карточек ко времени на поле) футболистов.
*/

create or alter procedure MOST_EFFECTIVE_PLAYERS_BY (
    E EVENT_TYPE,
    "AUTO" char(1))
returns (
    NAME varchar(16),
    EVENTS_COUNT integer,
    PLAYER_MATCHES_COUNT integer,
    KPD float)
as
begin
for
select players.name, events_count, player_matches_count, kpd
from players,
(
    select player_id as pid, events_count, player_matches_count
        , ( cast(events_count as float) / cast(player_matches_count as float) ) as kpd from
    (
        -- сколько у каждого игрока событий
        select player_id, events_count from
        (   -- все игроки, которые играют
            select player_id
            from current_club_players_list
            group by player_id
        )
        join
        (   -- количество событий у игрока
            select player_id as player_id2, count(player_id) as events_count
            from events
            where events."EVENT" = :E
              and events.ag_io = :"AUTO"
            group by player_id
        )
        on player_id = player_id2
    ),
    (
        -- сколько у каждого игрока матчей
        select player_id as player_id3, sum(club_matches_count) as player_matches_count from
        (
            select * from
            -- каждый игрок выступает за несколько клубов
            current_club_players_list
            join
            (   -- сколько у каждого клуба матчей
                select club_id as club_id2, count(match_id) as club_matches_count
                from clubs, matches
                where clubs.club_id = matches.first_club_id
                   or clubs.club_id = matches.second_club_id
                group by club_id
            )
            on club_id = club_id2
        )
        group by player_id
    )
    where player_id = player_id3
    order by kpd desc
)
where player_id = pid
into :name, :events_count, :player_matches_count, :kpd
do suspend;
end
/* -- эффективные игроки по смешанному параметру (красные + автогол)
select name, kpd, kpd2, (kpd+kpd2) as res_kpd
from MOST_EFFECTIVE_PLAYERS_BY('RED',0)
inner join
(
select name as name2, kpd as kpd2
from MOST_EFFECTIVE_PLAYERS_BY('GOAL',1)
)
on name = name2
order by res_kpd desc
*/
