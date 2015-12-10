/*автоинкремент см. лаб 1*/

/*тригер на изменение или удаление*/
CREATE EXCEPTION ex_no_modify 'This LEAGUE in table SEASONS';
CREATE TRIGGER tr_modif_leadue_id FOR leagues
BEFORE delete or update
AS
BEGIN
    if(old.league_id
        in (select seasons.league_id from seasons))
    then  exception ex_no_modify;
END;
/*
вывод тригера:

delete from leagues  where league_id = 7;
EX_NO_MODIFY.
This LEAGUE in table SEASONS.
At trigger 'TR_MODIF_LEADUE_ID' line: 8, col: 5.

*/

/*
1
При получении второй желтой карточки давать красную.
*/
CREATE TRIGGER tr_two_yellow_in_red FOR events
BEFORE insert
AS
BEGIN
    if (new."EVENT" = 'YELLOW')
    then
        if ('YELLOW' in
             (select events."EVENT" from events
               where events.player_id = new.player_id
                 and events.match_id = new.match_id))
        then
            execute procedure ins_event(new.player_id, new.match_id, new.event_minute, 'RED', 0);
END;
/*execute procedure ins_event(25,546,22,'YELLOW',0);*/
/*select * from events where player_id = 25 and events.match_id = 546;*/
/*
вывод:
   PLAYER_ID     MATCH_ID EVENT_MINUTE EVENT       AG_IO
============ ============ ============ =========== ======
          25          546           22 RED         0
          25          546           22 YELLOW      0
          25          546           14 YELLOW      0
*/

/*
2
При изменении данных в таблице голов изменять данные в записи о матче.
*/
create or alter procedure add_goal_to_matches (pid integer, mid integer, ag CHAR(1))
as
begin

    if ((select count(*) from current_club_players_list, matches
         where matches.match_id = :mid
           and current_club_players_list.club_id = matches.first_club_id
           and current_club_players_list.player_id = :pid) > 0)
    then
        if (ag = 0) then
            update matches set  first_club_goals =  first_club_goals + 1 where match_id = :mid;
        else
            update matches set second_club_goals = second_club_goals + 1 where match_id = :mid;

    if ((select count(*) from current_club_players_list, matches
         where matches.match_id = :mid
           and current_club_players_list.club_id = matches.second_club_id
           and current_club_players_list.player_id = :pid) > 0)
    then
        if (ag = 1) then
            update matches set  first_club_goals =  first_club_goals + 1 where match_id = :mid;
        else
            update matches set second_club_goals = second_club_goals + 1 where match_id = :mid;
end;


CREATE or alter TRIGGER tr_add_goal_to_matches FOR events
BEFORE insert
AS
BEGIN
    if (new."EVENT" = 'GOAL')
    then
        execute procedure add_goal_to_matches(new.player_id, new.match_id, new.ag_io);
END;

--execute procedure ins_event(1, 1, 90, 'GOAL', 0); /*гол Дзюбы, гол 2ой команды*/
--execute procedure ins_event(1, 1, 90, 'GOAL', 1); /*гол Дзюбы, в свои ворота*/
/*


*/

