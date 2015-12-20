create table man_car
(
    man varchar(10),
    car varchar(10)
);

commit;

insert into man_car values('Виталик','Пежо 308');
insert into man_car values('Никита','Ферари');
insert into man_car values('Стас','Бэха');

commit;

/*2.	Эксперименты по запуску, подтверждению и откату транзакций*/
insert into man_car values('Абама','Развалюха');
select * from man_car;

savepoint lol;
delete from man_car where man = 'Абама';
select * from man_car;

rollback to lol;
select * from man_car;

rollback;
select * from man_car;



/*3.	Эксперименты, показывающие основные возможности транзакций с различным уровнем изоляции*/

connect 'E:\Program Files\Firebird\db\lab7db.fdb' user 'SYSDBA' password 'masterkey';
commit;


/*SNAPSHOT*/

/*1 клиент*/
SET TRANSACTION isolation level snapshot;
select * from man_car;

insert into man_car values('Абама','Развалюха');
commit;
select * from man_car;

/*2 клиент*/
SET TRANSACTION isolation level snapshot;
select * from man_car;

select * from man_car;
commit;
select * from man_car;

/*clear*/
delete from man_car where man = 'Абама';


/*SNAPSHOT TABLE STABILITY*/

/*1 клиент*/
SET TRANSACTION isolation level snapshot table stability;
select * from man_car;

commit;

/*2 клиент*/
--SET TRANSACTION isolation level snapshot table stability;
select * from man_car;

insert into man_car values('Чак','Джип');
/*здесь зависли*/

/*развисли после commit 1 клиента*/

/*clear*/
delete from man_car where man = 'Чак';


/*READ COMMITTED*/

/*NO RECORD_VERSION WAIT*/

/*1 клиент*/
SET TRANSACTION isolation level READ COMMITTED;
select * from man_car;

select * from man_car;

select * from man_car;
/*зависли*/

/*развисли после коммита 2 клиента*/

/*2 клиент*/
insert into man_car values('Чак','Джип');
commit;
delete from man_car where man = 'Чак';

commit;

/*NO RECORD_VERSION NO WAIT*/

/*1 клиент*/
SET TRANSACTION isolation level READ COMMITTED NO WAIT;
select * from man_car;

select * from man_car;
/*ошибка, т.к. другая транзакция изменила таблицу, и не подтвердила*/

/*2 клиент*/
insert into man_car values('Чак','Джип');

commit;

/*RECORD_VERSION*/

/*1 клиент*/
SET TRANSACTION isolation level
READ COMMITTED RECORD_VERSION;
select * from man_car;

select * from man_car;
/*Не видим не подтверждённое изменение*/

select * from man_car;
/*Видим подтверждённое изменение*/

/*2 клиент*/
insert into man_car values('Чак','Джип');

commit;
