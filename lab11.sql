-- 1. Процедура должна выводить список преподавателей из таблицы TEACHER
-- (в стандартный серверный вывод), работающих на кафедре заданной кодом в параметре.
-- Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
create or replace procedure GKS.GET_TEACHERS(PCODE TEACHER.PULPIT%TYPE)
    is
    cursor GetTeachers is select TEACHER, TEACHER_NAME, PULPIT
                          from TEACHER
                          where PULPIT = PCODE;
    m_teacher TEACHER.TEACHER%TYPE;
    m_teacher_name TEACHER.TEACHER_NAME%TYPE;
    m_pulpit TEACHER.PULPIT%TYPE;
begin
    open GetTeachers;
    fetch GetTeachers into m_teacher, m_teacher_name, m_pulpit;
    DBMS_OUTPUT.PUT_LINE(m_teacher || ' ' || m_teacher_name || ' ' || m_pulpit);

    while (GetTeachers%found)
        loop
            DBMS_OUTPUT.PUT_LINE(m_teacher || ' ' || m_teacher_name || ' ' || m_pulpit);
            fetch GetTeachers into m_teacher, m_teacher_name, m_pulpit;
        end loop;
    close GetTeachers;
end GET_TEACHERS;

begin
    GET_TEACHERS('ИСиТ');
end;

-- 2. Разработайте локальную функцию
-- 3. Функция должна выводить количество преподавателей из таблицы TEACHER,
-- работающих на кафедре заданной кодом в параметре.
-- Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
create or replace function GKS.GET_NUM_TEACHERS (PCODE TEACHER.PULPIT%TYPE)
return number
is
    result_num number;
begin
    select count(TEACHER) into result_num from TEACHER where PULPIT=PCODE;
    return result_num;
end GET_NUM_TEACHERS;

begin
     DBMS_OUTPUT.PUT_LINE(GET_NUM_TEACHERS('ИСиТ'));
end;

--4.1 Процедура должна выводить список преподавателей из таблицы TEACHER
-- (в стандартный серверный вывод), работающих на факультете, заданным кодом в параметре.
-- Разработайте анонимный блок и продемонстрируйте выполнение процедуры
create or replace procedure GKS.GET_TEACHERS_BY_FACULTY (FCODE FACULTY.FACULTY%TYPE)
    is
    cursor GetTeachersByFaculty is
        select TEACHER, TEACHER_NAME, P.PULPIT
        from TEACHER inner join PULPIT P on P.PULPIT = TEACHER.PULPIT
        where FACULTY = FCODE;

    m_teacher      TEACHER.TEACHER%TYPE;
    m_teacher_name TEACHER.TEACHER_NAME%TYPE;
    m_pulpit       TEACHER.PULPIT%TYPE;
begin
    open GetTeachersByFaculty;
    fetch GetTeachersByFaculty into m_teacher, m_teacher_name, m_pulpit;

    while (GetTeachersByFaculty%found)
    loop
        DBMS_OUTPUT.PUT_LINE(m_teacher || ' ' || m_teacher_name || ' ' || m_pulpit);
        fetch GetTeachersByFaculty into m_teacher, m_teacher_name, m_pulpit;
    end loop;

    close GetTeachersByFaculty;

end GET_TEACHERS_BY_FACULTY;

begin
    GET_TEACHERS_BY_FACULTY('ИДиП');
end;


--4.2 Процедура должна выводить список дисциплин из таблицы SUBJECT,
-- закрепленных за кафедрой, заданной кодом кафедры в параметре.
-- Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
create or replace procedure GKS.GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
is
    cursor GetSubjects is
    select * from SUBJECT where PULPIT=PCODE;

    m_subject SUBJECT.SUBJECT%type;
    m_subject_name SUBJECT.SUBJECT_NAME%type;
    m_pulpit SUBJECT.PULPIT%type;
begin
    open GetSubjects;
    fetch GetSubjects into m_subject, m_subject_name, m_pulpit;

    while (GetSubjects%found)
    loop
        DBMS_OUTPUT.PUT_LINE(m_subject || ' ' || m_subject_name || ' ' || m_pulpit);
        fetch GetSubjects into m_subject, m_subject_name, m_pulpit;
    end loop;
    close GetSubjects;

end GET_SUBJECTS;

begin
    GET_SUBJECTS('ИСиТ');
end;


--5. Разработайте локальную функцию
-- Функция должна выводить количество преподавателей из таблицы TEACHER,
-- работающих на факультете, заданным кодом в параметре.
-- Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
DECLARE
    FUNCTION FGET_NUM_TEACHERS (FCODE FACULTY.FACULTY%TYPE) RETURN NUMBER IS
        result_num NUMBER;
    BEGIN
        SELECT COUNT(TEACHER)
        INTO result_num
        FROM TEACHER
        WHERE TEACHER.PULPIT IN (SELECT PULPIT FROM PULPIT WHERE FACULTY = FCODE);
        RETURN result_num;
    END FGET_NUM_TEACHERS;
BEGIN
    DBMS_OUTPUT.PUT_LINE(FGET_NUM_TEACHERS('ИДиП'));
END;


--5.2 Функция должна выводить количество дисциплин из таблицы SUBJECT,
-- закрепленных за кафедрой, заданной кодом кафедры параметре.
-- Разработайте анонимный блок и продемонстрируйте выполнение процедуры.
DECLARE
    FUNCTION GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) RETURN NUMBER IS
        result_num NUMBER;
    BEGIN
        SELECT COUNT(SUBJECT)
        INTO result_num
        FROM SUBJECT
        WHERE PULPIT = PCODE;
        RETURN result_num;
    END GET_NUM_SUBJECTS;
BEGIN
    DBMS_OUTPUT.PUT_LINE(GET_NUM_SUBJECTS('ИСиТ'));
END;


-- 6. Разработайте пакет TEACHERS, содержащий процедуры и функции:
create or replace package TEACHERS as
  FCODE FACULTY.FACULTY%type;
  PCODE SUBJECT.PULPIT%type;
  procedure P_GET_TEACHERS(FCODE FACULTY.FACULTY%type);
  procedure P_GET_SUBJECTS (PCODE SUBJECT.PULPIT%type);
  function P_GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%type) return number;
  function P_GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%type) return number;
end TEACHERS;

create or replace package body TEACHERS
is
    procedure P_GET_TEACHERS(FCODE FACULTY.FACULTY%TYPE)
        is
        cursor GetTeachersByFaculty is
            select TEACHER, TEACHER_NAME, P.PULPIT
            from TEACHER
                     inner join PULPIT P on P.PULPIT = TEACHER.PULPIT
            where FACULTY = FCODE;
        m_teacher      TEACHER.TEACHER%TYPE;
        m_teacher_name TEACHER.TEACHER_NAME%TYPE;
        m_pulpit       TEACHER.PULPIT%TYPE;
    begin
        open GetTeachersByFaculty;
        fetch GetTeachersByFaculty into m_teacher, m_teacher_name, m_pulpit;

        while (GetTeachersByFaculty%found)
            loop
                DBMS_OUTPUT.PUT_LINE(m_teacher || ' ' || m_teacher_name || ' ' || m_pulpit);
                fetch GetTeachersByFaculty into m_teacher, m_teacher_name, m_pulpit;
            end loop;

        close GetTeachersByFaculty;

    end P_GET_TEACHERS;
    procedure P_GET_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE)
        is
        cursor GetSubjects is
            select *
            from SUBJECT
            where PULPIT = PCODE;
        m_subject      SUBJECT.SUBJECT%type;
        m_subject_name SUBJECT.SUBJECT_NAME%type;
        m_pulpit       SUBJECT.PULPIT%type;
    begin
        open GetSubjects;
        fetch GetSubjects into m_subject, m_subject_name, m_pulpit;

        while (GetSubjects%found)
            loop
                DBMS_OUTPUT.PUT_LINE(m_subject || ' ' || m_subject_name || ' ' || m_pulpit);
                fetch GetSubjects into m_subject, m_subject_name, m_pulpit;
            end loop;
        close GetSubjects;

    end P_GET_SUBJECTS;
    function P_GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%TYPE)
        return number
        is
        result_num number;
    begin
        select count(TEACHER)
        into result_num
        from TEACHER
        where TEACHER.PULPIT in (select PULPIT from PULPIT where FACULTY = FCODE);
        return result_num;
    end P_GET_NUM_TEACHERS;
    function P_GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%TYPE) return number
        is
        result_num number;
    begin
        select count(SUBJECT) into result_num from SUBJECT where PULPIT = PCODE;
        return result_num;
    end P_GET_NUM_SUBJECTS;
begin
    null;
end TEACHERS;

--7. Разработайте анонимный блок и продемонстрируйте выполнение
-- процедур и функций пакета TEACHERS.
begin
  DBMS_OUTPUT.PUT_LINE('Кол-во преподавателей на факультете: ' || TEACHERS.P_GET_NUM_TEACHERS('ИДиП'));
  DBMS_OUTPUT.PUT_LINE('Кол-во предметов на кафедре: ' || TEACHERS.P_GET_NUM_SUBJECTS('ИСиТ'));
  DBMS_OUTPUT.PUT_LINE('------------------------');
  TEACHERS.P_GET_TEACHERS('ИДиП');
  DBMS_OUTPUT.PUT_LINE('------------------------');
  TEACHERS.P_GET_SUBJECTS('ИСиТ');
end;