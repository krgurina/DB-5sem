ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

--DROP TABLE T_RANGE;
--1.	Создайте таблицу T_RANGE c диапазонным секционированием. Используйте ключ секционирования типа NUMBER.
CREATE TABLE T_RANGE
(
    ID NUMBER,
    NUM NUMBER
)
PARTITION BY RANGE (NUM)
(
    PARTITION P1 VALUES LESS THAN (10),
    PARTITION P2 VALUES LESS THAN (50),
    PARTITION P3 VALUES LESS THAN (100),
    PARTITION P4 VALUES LESS THAN (MAXVALUE)
);

INSERT INTO T_RANGE VALUES (1, 5);
INSERT INTO T_RANGE VALUES (2, 15);
INSERT INTO T_RANGE VALUES (3, 25);
INSERT INTO T_RANGE VALUES (4, 70);
INSERT INTO T_RANGE VALUES (5, 110);
INSERT INTO T_RANGE VALUES (6, 1000);
commit;

alter table T_RANGE enable row movement;
UPDATE T_RANGE SET NUM = 100 WHERE ID = 1;

select * from T_RANGE partition (p1);
select * from T_RANGE partition (p2);
select * from T_RANGE partition (p3);
select * from T_RANGE partition (p4);


-- DROP TABLE T_INTERVAL
CREATE TABLE T_INTERVAL
(
    ID NUMBER,
    DATE_COLUMN DATE
)
PARTITION BY RANGE (DATE_COLUMN)
INTERVAL(NUMTOYMINTERVAL(1, 'YEAR'))
(
    PARTITION P1 VALUES LESS THAN (TO_DATE('2023-01-01', 'YYYY-MM-DD')),
    PARTITION P2 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD'))
);

-- Пример вставки данных в таблицу
INSERT INTO T_INTERVAL VALUES (1,  TO_DATE('2022-01-15', 'YYYY-MM-DD'));
INSERT INTO T_INTERVAL VALUES (2,  TO_DATE('2023-02-20', 'YYYY-MM-DD'));
INSERT INTO T_INTERVAL VALUES (3,  TO_DATE('2025-03-25', 'YYYY-MM-DD'));
INSERT INTO T_INTERVAL VALUES (3,  TO_DATE('2025-06-07', 'YYYY-MM-DD'));
commit ;
select * from T_INTERVAL partition(p1);
select * from T_INTERVAL partition(p2);
select * from T_INTERVAL;
select * from T_INTERVAL partition for (to_date('2025-03-25', 'YYYY-MM-DD'));

CREATE TABLE T_HASH
(
    ID NUMBER,
    TEXT VARCHAR2(50)
)
PARTITION BY HASH (TEXT)
PARTITIONS 3;

INSERT INTO T_HASH VALUES (1, 'T1');
INSERT INTO T_HASH VALUES (2, 'T2');
INSERT INTO T_HASH VALUES (3, 'T3');
INSERT INTO T_HASH VALUES (3, 'T4');

commit;

select * from T_HASH partition for ('T3');
select * from T_HASH partition for ('T2');
select * from T_HASH partition for ('T1');
drop TABLE T_HASH;


CREATE TABLE T_LIST
(
    ID NUMBER,
    NAME VARCHAR2(50),
    CHAR_COLUMN CHAR(1)
)
PARTITION BY LIST (CHAR_COLUMN)
(
    PARTITION P1 VALUES ('A'),
    PARTITION P2 VALUES ('B'),
    PARTITION P3 VALUES ('C')
);

INSERT INTO T_LIST VALUES (1, 'QQ1', 'A');
INSERT INTO T_LIST VALUES (2, 'QQ2', 'B');
INSERT INTO T_LIST VALUES (3, 'QQ3', 'C');
commit;
alter table T_LIST enable row movement;
update T_LIST set CHAR_COLUMN='C' where ID=1;
select * from T_LIST partition(p1);
select * from T_LIST partition(p2);
select * from T_LIST partition(p3);




ALTER TABLE T_RANGE MERGE PARTITIONS P1, P2 INTO PARTITION P_NEW;
select * from T_RANGE partition (P_NEW);
ALTER TABLE T_RANGE SPLIT PARTITION P3 AT (70) INTO (PARTITION P_3_NEW, PARTITION P3);
select * from T_RANGE partition (P_3_NEW);



CREATE TABLE temp
(
    ID NUMBER,
    NUM NUMBER
);
alter table T_RANGE exchange partition p4 with table temp;
select * from temp;
select * from T_RANGE partition (p3);



drop table T_LIST;