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
create or alter procedure home_guest_wins_by(L varchar(16), P varchar(9))
returns(id integer,
        home_wins integer,
        guest_wins integer)
as
begin
    for
    select clubs.name, home_win, guest_win from
        clubs,
        (select first_club_id, home_win, guest_win from
            (select * from
            (select first_club_id, count(first_club_id) as home_win from matches,
                (select club_id as cid, season_id as sid from standings
                where season_id =
                    (select seasons.season_id from seasons, leagues   --сезон
                    where seasons.league_id = leagues.league_id
                      and leagues.name = :L
                      and seasons.period = :P))
            where matches.first_club_id = cid
              and matches.first_club_goals > matches.second_club_goals
              and season_id = sid
            group by first_club_id)
    
            union all
    
            select club_id as cid, 0 from standings
                where season_id =
                    (select seasons.season_id from seasons, leagues   --сезон
                    where seasons.league_id = leagues.league_id
                      and leagues.name = :L
                      and seasons.period = :P)
            )
            join
            (
            select * from
            (select second_club_id, count(second_club_id) as guest_win from matches,
                (select club_id as cid, season_id as sid from standings
                where season_id =
                    (select seasons.season_id from seasons, leagues   --сезон
                    where seasons.league_id = leagues.league_id
                      and leagues.name = :L
                      and seasons.period = :P))
            where matches.second_club_id = cid
              and matches.first_club_goals < matches.second_club_goals
              and season_id = sid
            group by second_club_id)
    
            union all
    
            select club_id as cid, 0 from standings
                where season_id =
                    (select seasons.season_id from seasons, leagues   --сезон
                    where seasons.league_id = leagues.league_id
                      and leagues.name = :L
                      and seasons.period = :P)
            )
            on first_club_id = second_club_id)
        where clubs.club_id = first_club_id
    into :id, :home_wins, :guest_wins
    do suspend;
end;
/*        select * from
        (select * from
        (select first_club_id, count(first_club_id) as home_win from matches,
            (select club_id as cid, season_id as sid from standings
            where season_id =
                (select seasons.season_id from seasons, leagues   --сезон
                where seasons.league_id = leagues.league_id
                  and leagues.name = 'RFPL'
                  and seasons.period = '2015/2016'))
        where matches.first_club_id = cid
          and matches.first_club_goals > matches.second_club_goals
          and season_id = sid
        group by first_club_id)

        union all

        select club_id as cid, 0 from standings
            where season_id =
                (select seasons.season_id from seasons, leagues   --сезон
                where seasons.league_id = leagues.league_id
                  and leagues.name = 'RFPL'
                  and seasons.period = '2015/2016')
        )
        join
        (
        select * from
        (select second_club_id, count(second_club_id) as guest_wins from matches,
            (select club_id as cid, season_id as sid from standings
            where season_id =
                (select seasons.season_id from seasons, leagues   --сезон
                where seasons.league_id = leagues.league_id
                  and leagues.name = 'RFPL'
                  and seasons.period = '2015/2016'))
        where matches.second_club_id = cid
          and matches.first_club_goals < matches.second_club_goals
          and season_id = sid
        group by second_club_id)

        union all

        select club_id as cid, 0 from standings
            where season_id =
                (select seasons.season_id from seasons, leagues   --сезон
                where seasons.league_id = leagues.league_id
                  and leagues.name = 'RFPL'
                  and seasons.period = '2015/2016')
        )

         on first_club_id = second_club_id;
*/

/*
3
Определить наиболее эффективных (отношение количества голов и голевых передач ко времени на поле) и грубых (отношение количества желтых и красных карточек ко времени на поле) футболистов.
*/