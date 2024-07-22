grant create trigger, drop any trigger to GKS;
alter session set nls_date_format='dd-mm-yyyy hh24:mi:ss';


--1. Создайте таблицу, имеющую несколько атрибутов, один из которых первичный ключ.
--  drop table T1

create table GKS.T1
(
    a int primary key,
    b varchar(30)
);

--2. Заполните таблицу строками (10 шт.).
begin
    for i in 1..10
    loop
        insert into T1 values (i, 'xe');
    end loop;
end;


-----------------------------------------------
select * from T1;
insert into T1 values (11, 'xx');
insert into T1 values (12, 'xx');
insert into T1 values (13, 'xx');
update T1 set b = 'QQ' where a = 11 OR A=12;
delete T1 where a = 11 OR a = 12 OR A=13;
----------------------------------------------


--3.4. Создайте BEFORE – триггер уровня оператора на события INSERT, DELETE и UPDATE.
create or replace trigger INS_DEL_UPD_TRIGGER
    before insert or delete or update
    on T1
begin
    DBMS_OUTPUT.PUT_LINE('BEFORE_INS_DEL_UPD_TRIGGER');
end;


--5. 6. Создайте BEFORE-триггер уровня строки на события INSERT, DELETE и UPDATE.
create or replace trigger INS_DEL_UPD_TRIGGER_FOR_ROW
    before insert or delete or update
    on T1
    for each row
begin
    if INSERTING then
        DBMS_OUTPUT.PUT_LINE('BEFORE_INSERT_TRIGGER_FOR_ROW');
    ELSIF UPDATING then
        DBMS_OUTPUT.PUT_LINE('BEFORE_UPDATE_TRIGGER_FOR_ROW');
    ELSIF DELETING then
        DBMS_OUTPUT.PUT_LINE('BEFORE_DELETE_TRIGGER_FOR_ROW');
    end if;
    --DBMS_OUTPUT.PUT_LINE('INS_DEL_UPD_TRIGGER_FOR_ROW');
end;


-- 7.	Разработайте AFTER-триггеры уровня оператора на события INSERT, DELETE и UPDATE.
create or replace trigger AFTER_INS_DEL_UPD_TRIGGER
    after insert or delete or update
    on T1
begin
    DBMS_OUTPUT.PUT_LINE('AFTER_INS_DEL_UPD_TRIGGER');
end;

create or replace trigger AFTER_INSERT_TRIGGER
    after insert
    on T1
begin
    DBMS_OUTPUT.PUT_LINE('AFTER_INSERT_TRIGGER');
end;

create or replace trigger AFTER_UPDATE_TRIGGER
    after update
    on T1
begin
    DBMS_OUTPUT.PUT_LINE('AFTER_UPDATE_TRIGGER');
end;

create or replace trigger AFTER_DELETE_TRIGGER
    after delete
    on T1
begin
    DBMS_OUTPUT.PUT_LINE('AFTER_DELETE_TRIGGER');
end;

--8.	Разработайте AFTER-триггеры уровня строки на события INSERT, DELETE и UPDATE.

create or replace trigger AFTER_INSERT_TRIGGER_FOR_ROW
    after insert
    on T1
    for each row
begin
    DBMS_OUTPUT.PUT_LINE('AFTER_INSERT_TRIGGER_FOR_ROW');
end;

create or replace trigger AFTER_UPDATE_TRIGGER_FOR_ROW
    after update
    on T1
    for each row
begin
    DBMS_OUTPUT.PUT_LINE('AFTER_UPDATE_TRIGGER_FOR_ROW');
end;

create or replace trigger AFTER_DELETE_TRIGGER_FOR_ROW
    after delete
    on T1
    for each row
begin
    DBMS_OUTPUT.PUT_LINE('AFTER_DELETE_TRIGGER_FOR_ROW');
end;


-- 9.	Создайте таблицу с именем AUDIT
create table AUDITT
(
    OperationDate date,
    OperationType varchar2(50),
    TriggerName   varchar2(50),
    Data          varchar2(40)
);

--10.	Измените триггеры таким образом, чтобы они регистрировали все операции с исходной таблицей в таблице AUDIT.
    create or replace trigger TRIGGER_BEFORE_AUDIT
    before insert or update or delete
    on T1
    for each row
begin
    if inserting then
         DBMS_OUTPUT.PUT_LINE('TRIGGER_BEFORE_AUDIT - INSERT' );
         insert into AUDITT values (
                                    sysdate,
                                    'insert',
                                    'TRIGGER_BEFORE_AUDIT',
                                    :new.a || ' ' || :new.b
                                   );
    elsif updating then
        DBMS_OUTPUT.PUT_LINE('TRIGGER_BEFORE_AUDIT - UPDATE' );
        insert into AUDITT values (
                                    sysdate,
                                    'update',
                                    'TRIGGER_BEFORE_AUDIT',
                                     :old.a || ' ' || :old.b || ' -> ' || :new.a || ' ' || :new.b
                                   );
    elsif deleting then
         DBMS_OUTPUT.PUT_LINE('TRIGGER_BEFORE_AUDIT - DELETE' );
         insert into AUDITT values (
                                    sysdate,
                                    'delete',
                                    'TRIGGER_BEFORE_AUDIT',
                                    :old.a || ' ' || :old.b
                                   );
    end if;
end;

create or replace trigger TRIGGER_AFTER_AUDIT
    after insert or update or delete
    on T1
    for each row
begin
    if inserting then
         --DBMS_OUTPUT.PUT_LINE('TRIGGER_AFTER_AUDIT - INSERT' );
         insert into AUDITT values (
                                    sysdate,
                                    'insert',
                                    'TRIGGER_AFTER_AUDIT',
                                    :new.a || ' ' || :new.b
                                   );
    elsif updating then
        --DBMS_OUTPUT.PUT_LINE('TRIGGER_AFTER_AUDIT - UPDATE' );
        insert into AUDITT values (
                                    sysdate,
                                    'update',
                                    'TRIGGER_AFTER_AUDIT',
                                     :old.a || ' ' || :old.b || ' -> ' || :new.a || ' ' || :new.b
                                   );
    elsif deleting then
         --DBMS_OUTPUT.PUT_LINE('TRIGGER_AFTER_AUDIT - DELETE' );
         insert into AUDITT values (
                                    sysdate,
                                    'delete',
                                    'TRIGGER_AFTER_AUDIT',
                                    :old.a || ' ' || :old.b
                                   );
    end if;
end;

select * from AUDITT;

-- 11.	Выполните операцию, нарушающую целостность таблицы по первичному ключу.
-- Выясните, зарегистрировал ли триггер это событие. Объясните результат.
insert into T1 values (1, 'v');


-- 12.	Удалите (drop) исходную таблицу.
-- Объясните результат. Добавьте триггер, запрещающий удаление исходной таблицы.
drop table T1;

create table GKS.T1
(
    a int primary key,
    b varchar(30)
);

--drop trigger TRIGGER_PREVENT_TABLE_DROP
create or replace trigger TRIGGER_PREVENT_TABLE_DROP
    before drop
    on GKS.schema
begin
    if DICTIONARY_OBJ_NAME = 'T1'
    then
        RAISE_APPLICATION_ERROR(-20000, 'Вы не можете удалить эту таблицу.');
    end if;
    EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Произошла ошибка: ' || SQLERRM);
end;

--13.	Удалите (drop) таблицу AUDIT. Просмотрите состояние триггеров с помощью SQL-DEVELOPER.
-- Объясните результат. Измените триггеры.
drop table AUDITT;

-- 14.	Создайте представление над исходной таблицей. Разработайте INSTEADOF INSERT-триггер.
-- Триггер должен добавлять строку в таблицу.
--drop view T1_V;
create or replace view T1_V as select * from T1;

create or replace trigger INSTEAD_OF_INSERT_TRIGGER
    instead of insert
    on T1_V
begin
    if INSERTING then
        DBMS_OUTPUT.PUT_LINE('INSTEAD_OF_INSERT_TRIGGER');
        insert into T1 values (100, 'www');
    end if;
end INSTEAD_OF_INSERT_TRIGGER;

select * from T1_V;
insert into T1_V values (22, 'qqq');










--truncate table AUDITS;
