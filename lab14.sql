alter session set nls_date_format='dd-mm-yyyy hh24:mi:ss';

alter system set JOB_QUEUE_PROCESSES = 5;
select count(*) from dba_objects_ae where Object_Type = 'PACKAGE';

--1.
--drop table T14;
--drop table T14_TO;
--drop table job_status;
select * from T14;
select * from T14_TO;

delete from T14_TO;

begin
    for i in 1..10
    loop
        insert into T14 values (i, i*10);
    end loop;
    commit;
end;




create table T14
(
    a number,
    b number
);
create table T14_TO
(
    a number,
    b number
);

create table job_status
(
    status        nvarchar2(50),
    error_message nvarchar2(500),
    datetime      date default sysdate
);

select * from job_status;

--2.	Раз в неделю в определенное время выполняется копирование части данных
-- по условию из одной таблицы в другую, после чего эти данные из первой таблицы
-- удаляются.
--drop procedure job_procedure;
create or replace procedure job_procedure
is
    cursor cur is
    select * from T14;

    err_message varchar2(500);
begin
    for t in cur
    loop
        insert into T14_TO values (t.a, t.b);
    end loop;

    delete from T14;
    insert into job_status (status, datetime) values ('SUCCESS', sysdate);
    commit;
    exception
      when others then
          err_message := sqlerrm;
          insert into job_status (status, error_message) values ('FAILURE', err_message);
          commit;
end job_procedure;

declare job_number user_jobs.job%type;
begin
  dbms_job.submit(job_number, 'BEGIN job_procedure(); END;', sysdate, ' SYSTIMESTAMP + 7 + (7 + 28/60)/24');
  commit;
  dbms_output.put_line(job_number);
end;


DECLARE
  job_number user_jobs.job%TYPE;
BEGIN
  DBMS_JOB.SUBMIT(
    job       => job_number,
    what      => 'BEGIN job_procedure(); END;',
    next_date => TO_TIMESTAMP_TZ('10:22 Europe/Minsk', 'HH24:MI TZR') + INTERVAL '7' DAY,
    interval  => 'TRUNC(SYSDATE, ''DD'') + 7',
    no_parse  => FALSE
  );

  COMMIT;
  DBMS_OUTPUT.PUT_LINE(job_number);
END;
/

DECLARE
  job_number user_jobs.job%TYPE;
BEGIN
  DBMS_JOB.SUBMIT(
    job       => job_number,
    what      => 'BEGIN job_procedure(); END;',
    next_date => TO_TIMESTAMP_TZ(
                   TO_CHAR(TRUNC(SYSDATE) + INTERVAL '1' DAY + INTERVAL '10:30' HOUR TO MINUTE, 'YYYY-MM-DD HH24:MI'),
                   'YYYY-MM-DD HH24:MI TZR'
                 ),
    interval  => 'TRUNC(SYSDATE, ''DD'') + 7',
    no_parse  => FALSE
  );

  COMMIT;
  DBMS_OUTPUT.PUT_LINE(job_number);
END;
/





select * from JOB_STATUS;
-- 4.	Необходимо проверять, выполняется ли сейчас это задание.
select job, what, last_date, last_sec, next_date, next_sec, broken, interval from user_jobs;


--5.	Необходимо дать возможность выполнять задание в другое время, приостановить или отменить вообще.
begin
  dbms_job.INTERVAL(42,'sysdate + 5 + (10 + 17/60)/24');
end;

begin
  dbms_job.run(46);
end;

begin
  dbms_job.remove(23);
end;



select * from JOB_STATUS;

-- 6.	Разработайте пакет, функционально аналогичный пакету из задания 1-5. Используйте пакет DBMS_SHEDULER.
begin
dbms_scheduler.create_schedule(
  schedule_name => 'schedule',
  start_date => SYSTIMESTAMP,
  repeat_interval => 'FREQ=WEEKLY; BYHOUR=10; BYMINUTE=0',
  comments => 'schedule WEEKLY starts now'
);
end;

select * from user_scheduler_schedules;

begin
dbms_scheduler.create_program(
  program_name => 'program',
  program_type => 'STORED_PROCEDURE',
  program_action => 'job_procedure',
  number_of_arguments => 0,
  enabled => true,
  comments => 'program_1'
);
end;

select * from user_scheduler_programs;


begin
    dbms_scheduler.create_job(
            job_name => 'JOB_1',
            program_name => 'program',
            schedule_name => 'schedule',
            enabled => true
        );
end;

SELECT * FROM user_scheduler_job_run_details WHERE job_name = 'JOB_1';
select job_name, next_run_date from user_scheduler_jobs;

select * from user_scheduler_jobs;

begin
  DBMS_SCHEDULER.DISABLE('JOB_1');
end;

begin
    DBMS_SCHEDULER.RUN_JOB('JOB_1');
end;


begin
  DBMS_SCHEDULER.DROP_JOB(  'JOB_1');
  DBMS_SCHEDULER.DROP_SCHEDULE( 'schedule');
  DBMS_SCHEDULER.DROP_PROGRAM( 'program');
end;

DECLARE
  job_number user_jobs.job%TYPE;
BEGIN
  DBMS_JOB.SUBMIT(
    job       => job_number,
    what      => 'BEGIN job_procedure(); END;',
    next_date => SYSTIMESTAMP + INTERVAL '7' DAY + (7 + 28/60)/24,
    interval  => 'SYSTIMESTAMP + 7 + (7 + 28/60)/24',
    no_parse  => FALSE
  );

  COMMIT;
  DBMS_OUTPUT.PUT_LINE(job_number);
END;
/



