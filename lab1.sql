create table GKS_t (x number(3) primary key, s varchar2(50));

insert into GKS_t (x, s) values (1, 'apple');
insert into GKS_t (x, s) values (2, 'banana');
insert into GKS_t (x, s) values (3, 'kivi');
commit;

update GKS_t set x = '0' where s = 'kivi';
update GKS_t set s = 'mango' where x = '0';
commit;

select * from GKS_t;
select s from GKS_t where x=2;
select sum(x) from GKS_t;

delete from GKS_t where x=0;
commit;

create table GKS_t1
(
x1 number(3),
s1 varchar2(50),
  CONSTRAINT fk_xx1 FOREIGN KEY (x1) REFERENCES GKS_t(x)
);

insert into GKS_t1(x1, s1) values (1, 'two charry');
insert into GKS_t1(x1, s1) values (2, 'two strawberry');
insert into GKS_t1(x1, s1) values (2, 'two lime');
commit;


select * from GKS_t inner join GKS_t1 on GKS_t.x = GKS_t1.x1;

select * from GKS_t left outer join GKS_t1 on GKS_t.x = GKS_t1.x1;

select * from GKS_t right outer join GKS_t1 on GKS_t.x = GKS_t1.x1;

drop table GKS_t1;
drop table GKS_t;
