--1
--C:\app\XE\product\21c\homes\OraDB21Home1\network\admin

--2
show parameter;

--3
-- conn system@//localhost:1521/GKS_PDB;
alter session set container = GKS_PDB;
select tablespace_name, file_name from dba_data_files;
select tablespace_name, file_name from dba_temp_files;
select role from dba_roles;
select username from dba_users;

--6
--  connect kristina/Qwerty123@GKS_PDB;


--7
select * from x;

--8
help timing
timi start;
select * from dba_roles;
timi stop;

--10
select SEGMENT_NAME from user_segments;

--11

--
create or replace view view_segments as
    select count(SEGMENT_NAME) segments_count, sum(EXTENTS) extents_count,
           sum(BLOCKS) bloks_count, sum(BYTES) memory_size
    from user_segments;
select * from view_segments;
drop view view_segments;

create or replace view v1 as SELECT COUNT(segment_name) s, sum(EXTENTS) ex, sum(blocks) b, sum(bytes) bb from user_segments;
select * from v1;