 --1. Добавьте в таблицу TEACHERS два столбца BIRTHDAY и SALARY, заполните их значениями.
alter table TEACHER add BIRTHDAY date;
alter table TEACHER add SALARY number;

update TEACHER
set BIRTHDAY = '12-02-1959'
where TEACHER = 'СМЛВ';
update TEACHER
set BIRTHDAY = '30-01-1987'
where TEACHER = 'АКНВЧ';
update TEACHER
set BIRTHDAY = '19-01-1991'
where TEACHER = 'КЛСНВ';
update TEACHER
set BIRTHDAY = '16-04-1964'
where TEACHER = 'ГРМН';
update TEACHER
set BIRTHDAY = '19-11-1988'
where TEACHER = 'ЛЩНК';
update TEACHER
set BIRTHDAY = '05-10-1966'
where TEACHER = 'БРКВЧ';
update TEACHER
set BIRTHDAY = '10-08-1976'
where TEACHER = 'ДДК';
update TEACHER
set BIRTHDAY = '11-09-1989'
where TEACHER = 'КБЛ';
update TEACHER
set BIRTHDAY = '24-12-1983'
where TEACHER = 'УРБ';
update TEACHER
set BIRTHDAY = '03-06-1990'
where TEACHER = 'РМНК';
update TEACHER
set BIRTHDAY = '10-05-1970'
where TEACHER = 'ПСТВЛВ';
update TEACHER
set BIRTHDAY = '26-10-1999'
where TEACHER = '?';
update TEACHER
set BIRTHDAY = '30-07-1984'
where TEACHER = 'ГРН';
update TEACHER
set BIRTHDAY = '11-03-1975'
where TEACHER = 'ЖЛК';
update TEACHER
set BIRTHDAY = '12-07-1969'
where TEACHER = 'БРТШВЧ';
update TEACHER
set BIRTHDAY = '26-02-1983'
where TEACHER = 'ЮДНКВ';
update TEACHER
set BIRTHDAY = '13-12-1991'
where TEACHER = 'БРНВСК';
update TEACHER
set BIRTHDAY = '20-01-1968'
where TEACHER = 'НВРВ';
update TEACHER
set BIRTHDAY = '21-12-1969'
where TEACHER = 'РВКЧ';
update TEACHER
set BIRTHDAY = '28-01-1975'
where TEACHER = 'ДМДК';
update TEACHER
set BIRTHDAY = '10-07-1983'
where TEACHER = 'МШКВСК';
update TEACHER
set BIRTHDAY = '08-10-1988'
where TEACHER = 'ЛБХ';
update TEACHER
set BIRTHDAY = '30-07-1984'
where TEACHER = 'ЗВГЦВ';
update TEACHER
set BIRTHDAY = '16-04-1964'
where TEACHER = 'БЗБРДВ';
update TEACHER
set BIRTHDAY = '12-05-1985'
where TEACHER = 'ПРКПЧК';
update TEACHER
set BIRTHDAY = '20-10-1980'
where TEACHER = 'НСКВЦ';
update TEACHER
set BIRTHDAY = '21-08-1990'
where TEACHER = 'МХВ';
update TEACHER
set BIRTHDAY = '13-08-1966'
where TEACHER = 'ЕЩНК';
update TEACHER
set BIRTHDAY = '11-11-1978'
where TEACHER = 'ЖРСК';

update TEACHER
set SALARY = 1030
where TEACHER = 'СМЛВ';
update TEACHER
set SALARY = 1030
where TEACHER = 'АКНВЧ';
update TEACHER
set SALARY = 980
where TEACHER = 'КЛСНВ';
update TEACHER
set SALARY = 1050
where TEACHER = 'ГРМН';
update TEACHER
set SALARY = 590
where TEACHER = 'ЛЩНК';
update TEACHER
set SALARY = 870
where TEACHER = 'БРКВЧ';
update TEACHER
set SALARY = 815
where TEACHER = 'ДДК';
update TEACHER
set SALARY = 995
where TEACHER = 'КБЛ';
update TEACHER
set SALARY = 1460
where TEACHER = 'УРБ';
update TEACHER
set SALARY = 1120
where TEACHER = 'РМНК';
update TEACHER
set SALARY = 1250
where TEACHER = 'ПСТВЛВ';
update TEACHER
set SALARY = 333
where TEACHER = '?';
update TEACHER
set SALARY = 1520
where TEACHER = 'ГРН';
update TEACHER
set SALARY = 1430
where TEACHER = 'ЖЛК';
update TEACHER
set SALARY = 900
where TEACHER = 'БРТШВЧ';
update TEACHER
set SALARY = 875
where TEACHER = 'ЮДНКВ';
update TEACHER
set SALARY = 970
where TEACHER = 'БРНВСК';
update TEACHER
set SALARY = 780
where TEACHER = 'НВРВ';
update TEACHER
set SALARY = 1150
where TEACHER = 'РВКЧ';
update TEACHER
set SALARY = 805
where TEACHER = 'ДМДК';
update TEACHER
set SALARY = 905
where TEACHER = 'МШКВСК';
update TEACHER
set SALARY = 1200
where TEACHER = 'ЛБХ';
update TEACHER
set SALARY = 1500
where TEACHER = 'ЗВГЦВ';
update TEACHER
set SALARY = 905
where TEACHER = 'БЗБРДВ';
update TEACHER
set SALARY = 715
where TEACHER = 'ПРКПЧК';
update TEACHER
set SALARY = 880
where TEACHER = 'НСКВЦ';
update TEACHER
set SALARY = 735
where TEACHER = 'МХВ';
update TEACHER
set SALARY = 595
where TEACHER = 'ЕЩНК';
update TEACHER
set SALARY = 850
where TEACHER = 'ЖРСК';
commit;
--2. Получите список преподавателей в виде Фамилия И.О.

DECLARE
    CURSOR teachers_cursor IS
        SELECT TEACHER_NAME FROM TEACHER;

    last_name VARCHAR2(50);
    first_name VARCHAR2(50);
    middle_name VARCHAR2(50);
    teacher_rec TEACHER.TEACHER_NAME%type;
BEGIN
    FOR teacher_rec IN teachers_cursor
    LOOP
        -- Извлечение фамилии
        last_name := SUBSTR(teacher_rec.TEACHER_NAME, 1, INSTR(teacher_rec.TEACHER_NAME, ' ') - 1)||' ';
        -- Извлечение инициала имени
        first_name := SUBSTR(teacher_rec.TEACHER_NAME, INSTR(teacher_rec.TEACHER_NAME, ' ') + 1, 1) || '.';
        -- Извлечение инициала отчества
        middle_name := SUBSTR(teacher_rec.TEACHER_NAME, INSTR(teacher_rec.TEACHER_NAME, ' ',1, 2) + 1, 1) || '.';

        -- Вывод результата
        DBMS_OUTPUT.PUT_LINE(teachers_cursor%ROWCOUNT|| ' ' || last_name || first_name || middle_name);
    END LOOP;
END;


--3. Получите список преподавателей, родившихся в понедельник.
SELECT TEACHER_NAME, BIRTHDAY,TO_CHAR(BIRTHDAY, 'Dy') AS DAY_OF_WEEK FROM teacher WHERE TO_CHAR(teacher.birthday, 'D') = 1;

--4. Создайте представление, в котором поместите список преподавателей, которые родились в следующем месяце.
create or replace view V1 as
select teacher.teacher_name, TO_CHAR(TEACHER.BIRTHDAY, 'Month') AS Month from teacher
where TO_CHAR(sysdate, 'MM') - 11  = TO_CHAR(teacher.birthday, 'MM');

select * from V1;
--drop view V1;
select * from teacher;

--5. Создайте представление, в котором поместите количество преподавателей, которые родились в каждом месяце.
create or replace view V2 as
select
    TO_CHAR(TEACHER.BIRTHDAY, 'Month') as birth_month,
    count(*) as teacher_count
from teacher
group by
    EXTRACT(MONTH FROM TEACHER.BIRTHDAY),
    TO_CHAR(TEACHER.BIRTHDAY, 'Month')
ORDER BY
    EXTRACT(MONTH FROM TEACHER.BIRTHDAY);

select * from V2;
--drop view V2;

--6. Создать курсор и вывести список преподавателей, у которых в следующем году юбилей.

declare
    cursor curs is select * from TEACHER where mod(extract(year from sysdate)-extract(year from birthday) + 1, 5) = 0;
    cur_curs TEACHER % rowtype;
begin
    for cur_curs in curs
    loop
        DBMS_OUTPUT.PUT_LINE(curs%ROWCOUNT || '. ' || cur_curs.TEACHER_NAME || ' ' || cur_curs.BIRTHDAY);
    end loop;
exception when others
    then dbms_output.PUT_LINE(sqlerrm);
end;

--7. Создать курсор и вывести среднюю заработную плату по кафедрам с округлением вниз до целых,
--вывести средние итоговые значения для каждого факультета и для всех факультетов в целом.
DECLARE
    CURSOR avgSalaryCursor IS
        SELECT PULPIT, ROUND(AVG(SALARY))  as AVERAGE_SALARY
        FROM TEACHER
        GROUP BY PULPIT;

   CURSOR avgFacultyCursor IS
        SELECT F.FACULTY, ROUND(AVG(T.SALARY)) AS AVERAGE_SALARY
        FROM TEACHER T
        JOIN PULPIT P ON T.PULPIT = P.PULPIT
        JOIN FACULTY F ON P.FACULTY = F.FACULTY
        GROUP BY F.FACULTY;

    totalAvgSalary NUMBER;
BEGIN
    -- платы по кафедрам
    FOR avgSalaryRec IN avgSalaryCursor LOOP
        DBMS_OUTPUT.PUT_LINE('Средняя зарплата на кафедре ' || avgSalaryRec.PULPIT || ': ' || avgSalaryRec.AVERAGE_SALARY);
    END LOOP;
    --  платы для каждого факультета
    FOR avgFacultyRec IN avgFacultyCursor LOOP
        DBMS_OUTPUT.PUT_LINE('Средняя зарплата на факультете ' || avgFacultyRec.FACULTY || ': ' || avgFacultyRec.AVERAGE_SALARY);
    END LOOP;
    -- средней заработной платы
    SELECT ROUND(AVG(SALARY)) INTO totalAvgSalary
    FROM TEACHER;

    DBMS_OUTPUT.PUT_LINE('Общая средняя зарплата по всем факультетам: ' || totalAvgSalary);
END;
--8. Создайте собственный тип PL/SQL-записи (record) и продемонстрируйте работу с ним. Продемонстрируйте работу с вложенными записями.
--Продемонстрируйте и объясните операцию присвоения.
declare
    type params is record
    (
      age number := 19,
      height number := 168
    );
    type person is record
    (
        firstName varchar2(10):= 'Kristina',
        lastName varchar2(10):= 'Gurina',
        personParams params
    );
    person1 person;
begin
    dbms_output.PUT_LINE(person1.firstName || ' ' || person1.lastName || ' ' || person1.personParams.age || ' ' || person1.personParams.height);
    person1.firstName := 'XXX';
    person1.lastName := 'YYY';
    person1.personParams.age := 20;
    person1.personParams.height := 170;
    dbms_output.PUT_LINE(person1.firstName || ' ' || person1.lastName || ' ' || person1.personParams.age || ' ' || person1.personParams.height);
end;

