alter session set "_ORACLE_SCRIPT"= true;
alter session set container=XEPDB1;

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
autoextend on next 5M maxsize 20M;

SELECT tablespace_name, file_name, bytes, autoextensible, maxbytes
FROM dba_data_files
-- WHERE tablespace_name = 'TS_GKS';

-- 2 Создайте табличное пространство для временных данных
create temporary tablespace TS_GKS_TEMP
tempfile 'TS_GKS_TEMP'
size 5M
reuse
autoextend on next 3M maxsize 30M;

-- 3 Получите список всех табличных пространств, списки всех файлов с помощью select-запроса к словарю
SELECT  TABLESPACE_NAME from dba_tablespaces;
SELECT  TABLESPACE_NAME, FILE_NAME from DBA_DATA_FILES

-- 4 Создайте роль с именем RL_XXXCORE. Назначьте ей следующие системные привилегии:
CREATE ROLE RL_GKSCORE;

GRANT CREATE SESSION TO RL_GKSCORE; -- разрешение на соединение с сервером

GRANT CREATE TABLE TO RL_GKSCORE;
GRANT CREATE VIEW TO RL_GKSCORE;
GRANT CREATE PROCEDURE TO RL_GKSCORE;
--GRANT CREATE FUNCTION TO RL_GKSCORE;

GRANT DROP any TABLE TO RL_GKSCORE;
GRANT DROP any VIEW TO RL_GKSCORE;
GRANT DROP any PROCEDURE TO RL_GKSCORE;
--GRANT DROP any FUNCTION TO RL_GKSCORE;

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
    PASSWORD_GRACE_TIME 14     -- количество дней предупреждений о смене пароля
    CONNECT_TIME 180                -- время соединения, минут
    IDLE_TIME 30;                    -- количество минут простоя

CREATE PROFILE PF_GKSCORE LIMIT
    PASSWORD_LIFE_TIME 180          -- количество дней жизни пароля
    SESSIONS_PER_USER 3             -- количество сессий для пользователя
    FAILED_LOGIN_ATTEMPTS 7         -- количество попыток входа
    PASSWORD_LOCK_TIME 1            -- количество дней блокирования после ошибок
    PASSWORD_REUSE_TIME 10          -- через сколько дней можно повторить пароль
    PASSWORD_GRACE_TIME DEFAULT        -- количество дней предупреждений о смене пароля
    CONNECT_TIME 180                -- время соединения, минут
    IDLE_TIME 30;                   -- количество минут простоя

create profile PF_GKSCORE limit
    password_life_time 180          -- количество дней жизни пароля
    sessions_per_user 3             -- количество сессий для пользователя
    failed_login_attempts 7         -- количество попыток входа
    password_lock_time 1            -- количество дней блокирования после ошибок
    password_reuse_time 10          -- через сколько дней можно повторить пароль
    password_grace_time default     -- количество дней предупреждений о смене пароля
    connect_time 180                -- время соединения, минут
    idle_time 30;                   -- количество минут простоя



----


-- 7 Получите список всех профилей БД.
-- Получите значения всех параметров профиля PF_XXXCORE.
-- Получите значения всех параметров профиля DEFAULT.
select * from DBA_PROFILES;
select * from DBA_PROFILES where PROFILE='PF_GKSCORE'; -- не работает
select * from DBA_PROFILES where PROFILE='DEFAULT';

-- 8 Создайте пользователя с именем XXXCORE
create user GKSCORE identified by GKSCORE           -- ! после by указывается пароль
    default tablespace TS_GKS
    temporary tablespace TS_GKS_TEMP
    account unlock
    password expire;

-- 10 Создайте соединение с помощью SQL Developer для пользователя XXXCORE. Создайте любую таблицу и любое представление
grant connect, create session, create any table, drop any table, create any view to GKSCORE;

create table GKS_t
(
    x number(3) primary key,
    s varchar2(50)
);
drop table GKS_t;

insert into GKS_t (x, s) values (1, 'apple');
insert into GKS_t (x, s) values (2, 'banana');
insert into GKS_t (x, s) values (3, 'kivi');
commit;


drop tablespace TS_GKS;
drop tablespace TS_GKS_TEMP;



