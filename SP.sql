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
    select first 5 players.name as name, num1 from players,
        (select player_id, count(player_id) as num1 from events
        where events."EVENT" = :e
          and events.match_id in
            (select match_id from matches where matches.season_id =
                (select seasons.season_id from seasons, leagues
                where seasons.league_id = leagues.league_id
                  and leagues.name = :l
                  and seasons.period = :p))
        group by player_id order by num1 desc)
    into :name, :num
    do suspend;
end;

/*
2
Для каждой команды за выбранный сезон вывести количество выигранных домашних и гостевых матчей.
*/

/*
3
Определить наиболее эффективных (отношение количества голов и голевых передач ко времени на поле) и грубых (отношение количества желтых и красных карточек ко времени на поле) футболистов.
*/