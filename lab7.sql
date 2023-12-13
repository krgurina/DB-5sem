-- 1. Прочитайте задание полностью и выдайте своему пользователю необходимые права.
-- CREATE PROFILE PF_GKS LIMIT
--   FAILED_LOGIN_ATTEMPTS 7
--   SESSIONS_PER_USER 3
--   PASSWORD_LIFE_TIME 60
--   PASSWORD_REUSE_TIME 365
--   PASSWORD_LOCK_TIME 1
--   CONNECT_TIME 180;
--
-- CREATE USER GKS identified by 123
--   DEFAULT TABLESPACE TS_PDB_GKS
--   TEMPORARY TABLESPACE TS_PDB_GKS_TEMP
--   PROFILE PF_GKS
--   ACCOUNT UNLOCK;

GRANT CREATE SESSION TO GKS;
GRANT CREATE ANY TABLE TO GKS;
GRANT CREATE ANY VIEW TO GKS;
GRANT DROP ANY VIEW TO GKS;
GRANT CREATE SEQUENCE TO GKS;
GRANT CREATE CLUSTER TO GKS;
GRANT CREATE SYNONYM TO GKS;
GRANT CREATE PUBLIC SYNONYM TO GKS;
GRANT DROP PUBLIC SYNONYM TO GKS;
GRANT CREATE MATERIALIZED VIEW TO GKS;

-- 2. Создайте последовательность S1 (SEQUENCE), со следующими характеристиками:
-- начальное значение 1000;
-- приращение 10;
-- нет минимального значения;
-- нет максимального значения;
-- не циклическая;
-- значения не кэшируются в памяти;
-- хронология значений не гарантируется.
-- Получите несколько значений последовательности. Получите текущее значение последовательности.

create sequence S1
  start with 1000
  increment by 10
  nominvalue
  nomaxvalue
  nocycle
  nocache
  noorder;

select S1.NEXTVAL from DUAL;
select S1.CURRVAL from DUAL;

-- 3. Создайте последовательность S2 (SEQUENCE), со следующими характеристиками:
-- начальное значение 10;
-- приращение 10;
-- максимальное значение 100;
-- не циклическую.
-- Получите все значения последовательности.
-- Попытайтесь получить значение, выходящее за максимальное значение.
create sequence S2
  start with 10
  increment by 10
  maxvalue 100
  nocycle;

select S2.NEXTVAL from DUAL;

-- 5. Создайте последовательность S3 (SEQUENCE), со следующими характеристиками:
-- начальное значение 10;
-- приращение -10;
-- минимальное значение -100;
-- не циклическую;
-- гарантирующую хронологию значений.
-- Получите все значения последовательности.
-- Попытайтесь получить значение, меньше минимального значения.

create sequence S3
  start with 10
  increment by -10
  minvalue -100
  maxvalue 100
  nocycle
  order;

select S3.NEXTVAL from DUAL;


-- 6. Создайте последовательность S4 (SEQUENCE), со следующими характеристиками:
-- начальное значение 1;
-- приращение 1;
-- минимальное значение 10;
-- циклическая;
-- кэшируется в памяти 5 значений;
-- хронология значений не гарантируется.
-- Продемонстрируйте цикличность генерации значений последовательностью S4.

create sequence S4
  start with 1
  increment by 1
  maxvalue 10
  cycle
  cache 5
  noorder;

select S4.NEXTVAL from DUAL;

-- 7. Получите список всех последовательностей в словаре базы данных,
-- владельцем которых является пользователь XXX.
select * from USER_SEQUENCES;
select * from ALL_SEQUENCES WHERE SEQUENCE_OWNER = 'GKS';


-- 8. Создайте таблицу T1, имеющую столбцы N1, N2, N3, N4, типа NUMBER (20),
-- кэшируемую и расположенную в буферном пуле KEEP.
-- С помощью оператора INSERT добавьте 7 строк, вводимое значение для столбцов
-- должно формироваться с помощью последовательностей S1, S2, S3, S4.
create table T1 (
  N1 NUMBER(20),
  N2 NUMBER(20),
  N3 NUMBER(20),
  N4 NUMBER(20)
) cache storage ( buffer_pool keep ) tablespace TS_PDB_GKS;

alter sequence S2 maxvalue 200;
alter sequence S3 minvalue -200;

begin
  for i in 1..7 loop
    insert into T1 values (S1.NEXTVAL, S2.NEXTVAL, S3.NEXTVAL, S4.NEXTVAL);
  end loop;
end;

select * from T1;


-- 9. Создайте кластер ABC, имеющий hash-тип (размер 200) и
-- содержащий 2 поля: X (NUMBER (10)), V (VARCHAR2(12)).
create cluster ABC (
  X NUMBER(10),
  V VARCHAR2(12)
) size 200 hashkeys 200;

-- 10. Создайте таблицу A, имеющую столбцы XA (NUMBER (10)) и VA (VARCHAR2(12)),
-- принадлежащие кластеру ABC, а также еще один произвольный столбец.
create table A (
  XA NUMBER(10),
  VA VARCHAR2(12),
  XE NUMBER(10)
) cluster ABC(XA, VA);

-- 11. Создайте таблицу B, имеющую столбцы XB (NUMBER (10)) и VB (VARCHAR2(12)),
-- принадлежащие кластеру ABC, а также еще один произвольный столбец.
create table B (
  XB NUMBER(10),
  VB VARCHAR2(12),
  XEXE NUMBER(10)
) cluster ABC(XB, VB);

INSERT INTO B VALUES (1, 'B', 1);

-- 12. Создайте таблицу С, имеющую столбцы XС (NUMBER (10)) и VС (VARCHAR2(12)),
-- принадлежащие кластеру ABC, а также еще один произвольный столбец.
create table C (
  XC NUMBER(10),
  VC VARCHAR2(12),
  NEXE NUMBER(10)
) cluster ABC(XC, VC);

INSERT INTO C VALUES (2, 'C', 2);

-- 13. Найдите созданные таблицы и кластер в представлениях словаря Oracle.
select TABLE_NAME from USER_TABLES;
select CLUSTER_NAME from USER_CLUSTERS;

-- 14. Создайте частный синоним для таблицы XXX.С и продемонстрируйте его применение.
create synonym SC for GKS.C;
select * from C;
select * from SC;


-- 15. Создайте публичный синоним для таблицы XXX.B и продемонстрируйте его применение.
create public synonym SB for GKS.B;
select * from SB;


-- 16. Создайте две произвольные таблицы A и B (с первичным и внешним ключами),
-- заполните их данными, создайте представление V1,
-- основанное на SELECT... FOR A inner join B.
-- Продемонстрируйте его работоспособность.
create table AA (
  XA NUMBER(10),
  VA VARCHAR2(12),
  XEXE NUMBER(10),
  constraint PK_AA primary key (XA)
);

create table BB (
  XB NUMBER(10),
  VB VARCHAR2(12),
  NEXEXE NUMBER(10),
  constraint FK_BB foreign key (XB) references AA(XA)
);

INSERT INTO AA VALUES (1, 'A', 2);
INSERT INTO BB VALUES (1, 'B', 3);
commit;

create view V1 as
  select * from AA
  INNER JOIN BB ON AA.XA = BB.XB;

select * from V1;

-- 17. На основе таблиц A и B создайте материализованное представление MV,
-- которое имеет периодичность обновления 2 минуты.
-- Продемонстрируйте его работоспособность.
create materialized view MV
    build immediate
    refresh complete
    next  sysdate + numtodsinterval(2, 'minute')
as
select * from AA
    inner join
    BB
    on AA.XA = BB.XB;

------


create materialized view MV
    build immediate
    refresh complete
    enable query rewrite
as
select * from AA
    inner join
    BB
    on AA.XA = BB.XB;

alter materialized view MV
    refresh complete --on demand
    start with sysdate
    next  sysdate + numtodsinterval(2, 'minute');

commit;

select * from MV;
--delete from BB where XB = 4;
--delete from AA where XA = 4;

insert into AA(XA) values (4);
insert into BB(XB) values (4);
commit;

begin
    DBMS_MVIEW.REFRESH('MV');
end;

----------------------------------------------------------------
DROP SEQUENCE S1;
DROP SEQUENCE S2;
DROP SEQUENCE S3;
DROP SEQUENCE S4;

drop table T1;
drop table A;
drop table B;
drop table C;
drop cluster ABC;
drop synonym SC;
drop public synonym SB;
drop table BB;
drop table AA;
drop view V1;
drop materialized view MV;