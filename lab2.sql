alter session set "_ORACLE_SCRIPT"= true;

GRANT SELECT ANY DICTIONARY TO KRISTINA;
GRANT CREATE ROLE TO KRISTINA;
GRANT CREATE PROFILE TO KRISTINA;
GRANT CREATE PROFILE TO RL_GKSCORE;
ALTER USER KRISTINA PROFILE PF_GKSCORE;
GRANT DBA TO KRISTINA;
GRANT SYSDBA TO KRISTINA;
GRANT SYSOPER TO KRISTINA;


--1 Создайте табличное пространство для постоянных данных
create tablespace TS_GKS
    datafile 'TS_GKS'
    size 7M
    reuse
    autoextend on
    next 5M
    maxsize 20M;

SELECT tablespace_name, file_name, bytes, autoextensible, maxbytes
FROM dba_data_files
WHERE tablespace_name = 'TS_GKS';

-- 2 Создайте табличное пространство для временных данных
create temporary tablespace TS_GKS_TEMP
    tempfile 'TS_GKS_TEMP'
    size 5M
    reuse
    autoextend on
    next 3M
    maxsize 30M;

-- 3 Получите список всех табличных пространств, списки всех файлов с помощью select-запроса к словарю
SELECT  TABLESPACE_NAME from dba_tablespaces;
SELECT  TABLESPACE_NAME, FILE_NAME from DBA_DATA_FILES;

-- 4 Создайте роль с именем RL_XXXCORE. Назначьте ей следующие системные привилегии:
CREATE ROLE RL_GKSCORE;

GRANT CREATE SESSION TO RL_GKSCORE; -- разрешение на соединение с сервером
GRANT CREATE TABLE TO RL_GKSCORE;
GRANT CREATE VIEW TO RL_GKSCORE;
GRANT CREATE PROCEDURE TO RL_GKSCORE;

GRANT DROP any TABLE TO RL_GKSCORE;
GRANT DROP any VIEW TO RL_GKSCORE;
GRANT DROP any PROCEDURE TO RL_GKSCORE;

-- 5 Найдите с помощью select-запроса роль в словаре. Найдите с помощью select-запроса все системные привилегии, назначенные роли.
SELECT * FROM dba_roles WHERE role = 'RL_GKSCORE';
SELECT * FROM dba_role_privs WHERE granted_role = 'RL_GKSCORE';
--select * from DBA_SYS_PRIVS where grantee='KRISTINA';

-- 6 Создайте профиль безопасности с именем PF_XXXCORE, имеющий опции, аналогичные примеру из лекции.
CREATE PROFILE PF_GKSCORE LIMIT
    PASSWORD_LIFE_TIME 180          -- количество дней жизни пароля
    SESSIONS_PER_USER 3             -- количество сессий для пользователя
    FAILED_LOGIN_ATTEMPTS 7         -- количество попыток входа
    PASSWORD_LOCK_TIME 1            -- количество дней блокирования после ошибок
    PASSWORD_REUSE_TIME 10          -- через сколько дней можно повторить пароль
    PASSWORD_GRACE_TIME DEFAULT        -- количество дней предупреждений о смене пароля
    CONNECT_TIME 180                -- время соединения, минут
    IDLE_TIME 30;                   -- количество минут простоя



----


-- 7 Получите список всех профилей БД.
-- Получите значения всех параметров профиля PF_XXXCORE.
-- Получите значения всех параметров профиля DEFAULT.
select * from DBA_PROFILES;
select * from DBA_PROFILES where PROFILE='PF_GKSCORE';
select * from DBA_PROFILES where PROFILE='DEFAULT';

-- 8 Создайте пользователя с именем XXXCORE
create user GKSCORE identified by GKSCORE
    default tablespace TS_GKS
    temporary tablespace TS_GKS_TEMP
    profile DEFAULT
    account unlock
    password expire;

-- 10 Создайте соединение с помощью SQL Developer для пользователя XXXCORE.
-- Создайте любую таблицу и любое представление
grant connect, create session, create any table, drop any table, create any view to GKSCORE;
GRANT UNLIMITED TABLESPACE TO GKSCORE;
-- GRANT SELECT ON GKS_t TO GKSCORE;
-- GRANT INSERT ON GKS_t TO GKSCORE;
-- GRANT INSERT ON TS_GKS TO GKSCORE;
-- GRANT SELECT ANY DICTIONARY TO GKSCORE;

create table GKS_t
(
    x number(3) primary key,
    s varchar2(50)
);

insert into GKS_t (x, s) values (1, 'apple');
insert into GKS_t (x, s) values (2, 'banana');
insert into GKS_t (x, s) values (3, 'kivi');
commit;

create view GKSCORE_V as select s from GKS_t where x = 1;
select * from GKSCORE_V;

-- 11 . Создайте табличное пространство с именем XXX_QDATA (10m).
-- При создании установите его в состояние offline. Затем переведите табличное пространство в состояние online.
-- Выделите пользователю XXX квоту 2m в пространстве XXX_QDATA.
create tablespace GKS_QDATA OFFLINE
  datafile 'GKS_QDATA'
  size 10M reuse
  autoextend on next 5M
  maxsize 20M;

alter tablespace GKS_QDATA online;

alter user GKSCORE QUOTA 2M ON GKS_QDATA;

create table GKS_t1
(
    x number(3) primary key,
    s varchar2(50)
) TABLESPACE GKS_QDATA;

insert into GKS_t1 (x, s) values (1, 'apple');
insert into GKS_t1 (x, s) values (2, 'banana');
insert into GKS_t1 (x, s) values (3, 'kivi');
commit;

select * from GKS_T1;

drop role RL_GKSCORE;

drop table GKS_t;
drop table GKS_t1;
drop view GKSCORE_V;

drop profile PF_GKSCORE;
drop tablespace TS_GKS INCLUDING CONTENTS AND DATAFILES;
drop tablespace TS_GKS_TEMP INCLUDING CONTENTS AND DATAFILES;
drop tablespace GKS_QDATA INCLUDING CONTENTS AND DATAFILES;
drop user GKSCORE cascade;



