
alter session set "_oracle_script"=true;
GRANT SELECT ANY DICTIONARY TO kristina;
GRANT SELECT ON V$INSTANCE TO kristina;


--1. Получите список всех существующих PDB в рамках экземпляра ORA12W.
-- Определите их текущее состояние.
select PDB_NAME, STATUS from dba_pdbs;

--2 перечень экземпляров
select * from V$INSTANCE;

--3 перечень установленных компонентов СУБД Oracle 12c и их версии и статус
select comp_id, comp_name, version, status
from dba_registry;

--4. Создайте собственный экземпляр PDB (необходимо подключиться к серверу с серверного компьютера и
-- используйте Database Configuration Assistant) с именем XXX_PDB, где XXX – инициалы студента.

CREATE PLUGGABLE DATABASE GKS_PDB ADMIN USER myadmin IDENTIFIED BY 12345 ROLES = (DBA)
FILE_NAME_CONVERT =('/u02/app/oracle/oradata/ORCL/pdbseed', '/u02/app/oracle/oradata/ORCL/GKS_PDB');

ALTER PLUGGABLE DATABASE GKS_PDB OPEN;

--5. Получите список всех существующих PDB в рамках экземпляра ORA12W. Убедитесь, что созданная PDB-база данных существует.
select PDB_NAME, STATUS from dba_pdbs;

--6. Подключитесь к XXX_PDB c помощью SQL Developer создайте инфраструктурные объекты
-- (табличные пространства, роль, профиль безопасности, пользователя с именем U1_XXX_PDB).
--alter session set container=GKS_PDB;

create tablespace TS_PDB_GKS
  datafile 'TS_PDB_GKS.dbf'
  size 7M
  autoextend on next 5M
  maxsize 20M
  extent management local;

       --create tablespace TS_PDB_GKS datafile 'TS_PDB_GKS.dbf' size 7M autoextend on next 5M maxsize 20M extent management local;
create temporary tablespace TS_PDB_GKS_TEMP tempfile 'TS_PDB_GKS_TEMP.dbf' size 5M autoextend on next 3M maxsize 30M;

create temporary tablespace TS_PDB_GKS_TEMP
  tempfile 'TS_PDB_GKS_TEMP.dbf'
  size 5M
  autoextend on next 3M
  maxsize 30M;

alter session set "_ORACLE_SCRIPT"=TRUE;
create role RL_PDB_GKSCORE;

grant connect, create session, create any table, drop any table, create any view,
drop any view, create any procedure, drop any procedure to RL_PDB_GKSCORE;

create profile PF_PDB_GKSCORE limit
  password_life_time 365
  sessions_per_user 5
  failed_login_attempts 5
  password_lock_time 1
  password_reuse_time 10
  password_grace_time default
  connect_time 180
  idle_time 45;

create user U1_GKS_PDB identified by U1_GKS_PDB
default tablespace TS_PDB_GKS quota unlimited on TS_PDB_GKS
temporary tablespace TS_PDB_GKS_TEMP
profile default
account unlock
password expire;

grant RL_PDB_GKSCORE to U1_GKS_PDB;
grant create session to U1_GKS_PDB;
GRANT SELECT ANY DICTIONARY TO U1_GKS_PDB;
--ALTER SESSION SET CONTAINER =GKS_PDB;

--7. Подключитесь к пользователю U1_XXX_PDB, с помощью SQL Developer,
-- создайте таблицу XXX_table, добавьте в нее строки, выполните SELECT-запрос к таблице.
create table GKS_table
(
    x number(3) primary key,
    s varchar2(50)
);

insert into GKS_table (x, s) values (1, 'apple');
insert into GKS_table (x, s) values (2, 'banana');
insert into GKS_table (x, s) values (3, 'kivi');
commit;

select * from GKS_table;

--8. С помощью представлений словаря базы данных определите,
-- все табличные пространства,
-- все  файлы (перманентные и временные),
-- все роли (и выданные им привилегии),
-- профили безопасности,
-- всех пользователей  базы данных XXX_PDB и назначенные им роли.
GRANT SELECT ANY DICTIONARY TO U1_GKS_PDB;

select TABLESPACE_NAME, CONTENTS from USER_TABLESPACES;
select TABLESPACE_NAME, FILE_NAME from DBA_DATA_FILES;
select TABLESPACE_NAME, FILE_NAME from DBA_TEMP_FILES;

select * from DBA_ROLES;
select * from DBA_ROLE_PRIVS;

select * from DBA_PROFILES;
select * from DBA_USERS;
select USERNAME, GRANTED_ROLE from DBA_USERS join DBA_ROLE_PRIVS on USERNAME = GRANTEE ORDER BY USERNAME;


-- 9. Подключитесь к CDB-базе данных,
-- создайте общего пользователя с именем C##XXX, назначьте ему привилегию, позволяющую подключится к базе данных XXX_PDB.
-- Создайте 2 подключения пользователя C##XXX в SQL Developer к CDB-базе данных и  XXX_PDB – базе данных.
-- Проверьте их работоспособность.

-- проверка
--SELECT SYS_CONTEXT ('USERENV', 'CON_NAME') FROM DUAL;

CREATE USER C##GKS IDENTIFIED BY 123456 ACCOUNT UNLOCK;

GRANT CREATE SESSION TO C##GKS;

-- 11   список всех текущих подключений к XXX_PDB
SELECT * FROM v$session WHERE username IS NOT NULL;

--12
SELECT *  FROM DBA_DATA_FILES;

--13
ALTER PLUGGABLE DATABASE GKS_PDB CLOSE IMMEDIATE;
--alter pluggable database GKS_PDB unplug into '/tmp/pdb1.xml';
DROP PLUGGABLE DATABASE GKS_PDB including datafiles;
DROP USER C##GKS cascade;








     
drop role RL_PDB_GKSCORE;
drop profile PF_PDB_GKSCORE;
drop user U1_GKS_PDB cascade;

drop tablespace TS_PDB_GKS INCLUDING CONTENTS AND DATAFILES;
drop tablespace TS_PDB_GKS_TEMP INCLUDING CONTENTS AND DATAFILES;
