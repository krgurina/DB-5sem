-- 1. Разработайте АБ, демонстрирующий работу оператора SELECT с точной выборкой.
declare
    f FACULTY%rowtype;
begin
    SELECT * into f FROM FACULTY WHERE FACULTY = 'ИЭФ';
    DBMS_OUTPUT.put_line(f.FACULTY_NAME);
end;
-- 2. Разработайте АБ, демонстрирующий работу оператора SELECT с неточной точной выборкой.
-- Используйте конструкцию WHEN OTHERS секции исключений и встроенную функции
-- SQLERRM, SQLCODE для диагностирования неточной выборки.
declare
    f FACULTY%rowtype;
begin
    SELECT * into f FROM FACULTY;
    DBMS_OUTPUT.put_line(f.FACULTY_NAME);
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error: ' || sqlerrm);
        dbms_output.put_line('Error code: ' || sqlcode);
end;

-- 3. Разработайте АБ, демонстрирующий работу конструкции WHEN TO_MANY_ROWS
-- секции исключений для диагностирования неточной выборки.
declare
    f FACULTY%rowtype;
begin
    SELECT * into f FROM FACULTY;
    DBMS_OUTPUT.put_line(f.FACULTY_NAME);
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

-- 4. Разработайте АБ, демонстрирующий возникновение и обработку исключения NO_DATA_FOUND.
declare
    f FACULTY%rowtype;
begin
    SELECT * into f FROM FACULTY where FACULTY_NAME='wqqq';
    DBMS_OUTPUT.put_line(f.FACULTY_NAME);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

--4. Разработайте АБ, демонстрирующий применение атрибутов неявного курсора.
DECLARE
    f FACULTY%rowtype;
BEGIN
    SELECT * INTO f FROM FACULTY WHERE FACULTY = 'ИЭФ';
    DBMS_OUTPUT.put_line(f.FACULTY_NAME);

    if sql%found then
        dbms_output.put_line('%found:     true');
    else
        dbms_output.put_line('%found:     false');
    end if;

    if sql%isopen then
        dbms_output.put_line('$isopen:    true');
    else
        dbms_output.put_line('$isopen:    false');
    end if;

    if sql%notfound then
        dbms_output.put_line('%notfound:  true');
    else
        dbms_output.put_line('%notfound:  false');
    end if;

    dbms_output.put_line('%rowcount:  ' || sql%rowcount);
end;

-- 5. Разработайте АБ, демонстрирующий применение оператора UPDATE совместно с операторами COMMIT/ROLLBACK.
begin
    update AUDITORIUM set AUDITORIUM_CAPACITY = 90 where AUDITORIUM = '206-3';
    commit;
    update AUDITORIUM set AUDITORIUM_CAPACITY = 10 where AUDITORIUM = '206-3';
    rollback;
exception
    when others then
    DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

select * from auditorium where auditorium like '206%';

-- 6. Продемонстрируйте оператор UPDATE, вызывающий нарушение целостности в базе данных.
-- Обработайте возникшее исключение.
begin
    update AUDITORIUM set AUDITORIUM_CAPACITY = 'qqq' where AUDITORIUM = '206-3';
    commit;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;


-- 7. Разработайте АБ, демонстрирующий применение оператора INSERT
-- совместно с операторами COMMIT/ROLLBACK.
begin
    insert into AUDITORIUM VALUES ('111-5', '111-5', 90, 'ЛК');
    commit;
    insert into AUDITORIUM VALUES ('111-6', '115-6', 90, 'ЛК');
    rollback;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

select * from AUDITORIUM where auditorium like '111%';


-- 8. Продемонстрируйте оператор INSERT, вызывающий нарушение целостности в базе данных.
-- Обработайте возникшее исключение.
begin
    insert into AUDITORIUM VALUES ('111-5', '111-5', 'qqq', 4);
    commit;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

select * from AUDITORIUM where auditorium like '111%';


-- 9. Разработайте АБ, демонстрирующий применение оператора DELETE
-- совместно с операторами COMMIT/ROLLBACK.
begin
    delete from auditorium where auditorium = '111-5';
    commit;
    delete from auditorium where auditorium = '111-4';
    rollback;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

select * from AUDITORIUM where auditorium like '111%';


-- 10. Продемонстрируйте оператор DELETE, вызывающий нарушение целостности в базе данных.
-- Обработайте возникшее исключение.
begin
    delete from auditorium where auditorium = 'qqq';
        if (sql%rowcount = 0) then
            raise no_data_found;
        end if;
    commit;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

select * from auditorium where auditorium like '111%';


-- 11. Создайте анонимный блок, распечатывающий таблицу TEACHER с применением
-- явного курсора LOOP-цикла. Считанные данные должны быть записаны в переменные,
-- объявленные с применением опции %TYPE.
select * from TEACHER;


declare
    cursor cursor_teach is select TEACHER, TEACHER_NAME, PULPIT from TEACHER;
    v_teacher      TEACHER.TEACHER%type;
    v_teacher_name TEACHER.TEACHER_NAME%type;
    v_pulpit       TEACHER.PULPIT%type;
begin
    open cursor_teach;
    loop
        fetch cursor_teach into v_teacher, v_teacher_name, v_pulpit;
        exit when cursor_teach%notfound;
        dbms_output.put_line(' ' || cursor_teach%rowcount || ' ' || v_teacher || ' ' || v_teacher_name || ' ' || v_pulpit);
    end loop;
    close cursor_teach;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;


-- 12. Создайте АБ, распечатывающий таблицу SUBJECT с применением
-- явного курсора и WHILE-цикла.
-- Считанные данные должны быть записаны в запись (RECORD), объявленную с применением опции %ROWTYPE.
declare
    cursor cursor_subj is select subject, subject_name, pulpit from subject;
    RECORD subject%rowtype;
begin
    open cursor_subj;
    fetch cursor_subj into RECORD;
    while (cursor_subj%found)
        loop
            dbms_output.put_line(' ' || cursor_subj%rowcount || ' '
                || RECORD.subject || ' '
                || RECORD.subject_name || ' '
                || RECORD.pulpit);
            fetch cursor_subj into RECORD;
        end loop;
    close cursor_subj;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;


-- 14. Создайте АБ, распечатывающий все кафедры (таблица PULPIT)
-- и фамилии всех преподавателей (TEACHER) использовав
-- соединение (JOIN) PULPIT и TEACHER и с применением явного курсора и FOR-цикла.
declare
    cursor curs_pulpit is
        select pulpit.pulpit, teacher.teacher_name
        from pulpit join teacher
            on pulpit.pulpit = teacher.pulpit;
    rec_pulpit curs_pulpit%rowtype;
    txt VARCHAR2(150);
begin
    for rec_pulpit in curs_pulpit
        loop
             txt := ' ' || curs_pulpit%rowcount || ' ' ||
               RTRIM(rec_pulpit.pulpit) || ' ' ||
               LTRIM(rec_pulpit.teacher_name);
            dbms_output.put_line(txt);
        end loop;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

-- 14. Создайте АБ, распечатывающий следующие списки аудиторий:
-- все аудитории (таблица AUDITORIUM) с вместимостью
-- меньше 20, от 21-30, от 31-60, от 61 до 80, от 81 и выше.
-- Примените курсор с параметрами и три способа организации цикла по строкам курсора.
declare
    cursor curs (
        capacity auditorium.auditorium_capacity%type,
        capacity1 auditorium.auditorium_capacity%type)
        is select auditorium, auditorium_capacity, auditorium_type
           from auditorium
           where auditorium_capacity >= capacity
             and auditorium_capacity <= capacity1;
    record curs%rowtype;
begin
    dbms_output.put_line('capacity < 20:');
    open curs(0, 20);
    fetch curs into record;
    --1
    loop
        dbms_output.put_line(record.auditorium || ' ');
        fetch curs into record;
        exit when curs%notfound;
    end loop;
    close curs;

    dbms_output.put_line('21 < capacity < 30:');
    open curs(21, 30);
    fetch curs into record;
    --2
    while curs%found
        loop
            dbms_output.put_line(record.auditorium || ' ');
            fetch curs into record;
        end loop;
    close curs;

    dbms_output.put_line('31 < capacity < 60:');
    --3
    for auditoria in curs(31, 60)
        loop
            dbms_output.put_line(auditoria.auditorium || ' ');
        end loop;

    dbms_output.put_line('61 < capacity < 80:');
    open curs(61, 80);
    fetch curs into record;
    loop
        dbms_output.put_line(record.auditorium || ' ');
        fetch curs into record;
        exit when curs%notfound;
    end loop;
    close curs;

    dbms_output.put_line('81 < capacity:');
    for auditoria in curs(81, 1000)
        loop
            dbms_output.put_line(auditoria.auditorium || ' ');
        end loop;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;








-- 15. Создайте AБ. Объявите курсорную переменную с помощью системного типа refcursor.
-- Продемонстрируйте ее применение для курсора c параметрами.

declare
    type auditorium_ref is ref cursor return auditorium%rowtype;
    xcurs     auditorium_ref;
    xcurs_row xcurs%rowtype;
begin
    open xcurs for select * from auditorium;
    fetch xcurs into xcurs_row;
    loop
        exit when xcurs%notfound;
        dbms_output.put_line(' ' || xcurs%rowcount || ' ' || xcurs_row.auditorium || ' ' || xcurs_row.auditorium_capacity);
        fetch xcurs into xcurs_row;
    end loop;
    close xcurs;

exception
    when others then
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;

-- 16. Создайте AБ. Продемонстрируйте понятие курсорный подзапрос

-- Курсорный подзапрос - это запрос, который используется внутри другого запроса
-- и возвращает набор результатов для дальнейшего использования во внешнем запросе.
-- Курсорный подзапрос может быть использован в различных частях SQL-запроса,
-- таких как предложение SELECT, FROM, WHERE и других.
declare
    cursor curs_aut is
        select auditorium_type,
               cursor
                   (select auditorium
                    from auditorium auditoria
                    where aut.auditorium_type = auditoria.auditorium_type)
        from auditorium_type aut;
    curs_aum sys_refcursor;
    aut auditorium_type.auditorium_type%type;
    txt varchar2(200);
    auditoria auditorium.auditorium%type;
begin
    open curs_aut;
    fetch curs_aut into aut, curs_aum;
    while(curs_aut%found)
        loop
            txt := rtrim(aut) || ': ';
            loop
                fetch curs_aum into auditoria;
                exit when curs_aum%notfound;
                txt := txt || rtrim(auditoria);
            end loop;

            dbms_output.put_line(txt);
            fetch curs_aut into aut, curs_aum;
        end loop;

    close curs_aut;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLCODE || ' ' || SQLERRM);
end;







-- 17. Создайте AБ. Уменьшите вместимость всех аудиторий (таблица AUDITORIUM)
-- вместимостью от 40 до 80 на 10%.
-- Используйте явный курсор с параметрами, цикл FOR, конструкцию UPDATE CURRENT OF.
select * from auditorium where AUDITORIUM_CAPACITY>30 and AUDITORIUM_CAPACITY<80;

declare
    cursor cursor_auditor(
        capacity auditorium.auditorium%type,
        capac auditorium.auditorium%type)
        is
        select auditorium, auditorium_capacity from auditorium
        where auditorium_capacity >= 40
          and AUDITORIUM_CAPACITY <= 80
            for update;
    auditoria auditorium.auditorium%type;
    cty auditorium.auditorium_capacity%type;
begin
    open cursor_auditor(40, 80);
    fetch cursor_auditor into auditoria, cty;

    while(cursor_auditor%found)
        loop
            cty := cty * 0.9;

            update auditorium set auditorium_capacity = cty
            where current of cursor_auditor;

            dbms_output.put_line(' ' || auditoria || ' ' || cty);
            fetch cursor_auditor into auditoria, cty;
        end loop;

    close cursor_auditor;
    rollback;
exception
    when others then
        dbms_output.put_line(sqlerrm);
end;






-- 18. Создайте AБ. Удалите все аудитории (таблица AUDITORIUM) вместимостью от 0 до 20.
-- Используйте явный курсор с параметрами, цикл WHILE, конструкцию UPDATE CURRENT OF.
insert into AUDITORIUM VALUES ('133-1', '133-1', 10, 'ЛК-К');

DECLARE
    CURSOR cursor_auditor (MINcapacity auditorium.auditorium_capacity%type,
        MAXcapacity auditorium.auditorium_capacity%type) IS
        SELECT auditorium, auditorium_capacity
        FROM auditorium
        WHERE auditorium_capacity >= MINcapacity AND AUDITORIUM_CAPACITY <= MAXcapacity
        FOR UPDATE;

    auditoria auditorium.auditorium%TYPE;
    cty auditorium.auditorium_capacity%TYPE;
BEGIN
    OPEN cursor_auditor(0,20);
    FETCH cursor_auditor INTO auditoria, cty;

    WHILE cursor_auditor%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE('Del ' || auditoria || '  ' || cty);
        DELETE auditorium WHERE CURRENT OF cursor_auditor;
        FETCH cursor_auditor INTO auditoria, cty;
    END LOOP;
    rollback;

    CLOSE cursor_auditor;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

select * from AUDITORIUM;

-- 19. Создайте AБ. Продемонстрируйте применение псевдостолбца ROWID
-- в операторах UPDATE и DELETE.
DECLARE
    CURSOR cur(capacity auditorium.AUDITORIUM_CAPACITY%TYPE) IS
        SELECT auditorium, auditorium_capacity, rowid
        FROM auditorium
        WHERE auditorium_capacity >= capacity FOR UPDATE;

BEGIN
    FOR xxx IN cur(80)
    LOOP
        IF xxx.auditorium_capacity >= 90 THEN
            DBMS_OUTPUT.PUT_LINE('Del ' || xxx.auditorium || ' ' || xxx.auditorium_capacity);
            DELETE auditorium WHERE rowid = xxx.rowid AND xxx.auditorium_capacity >= 90;
        ELSIF xxx.auditorium_capacity >= 40 THEN
            DBMS_OUTPUT.PUT_LINE('Upd' || xxx.auditorium || ' ' || xxx.auditorium_capacity || ' to ' || (xxx.auditorium_capacity + 3));
            UPDATE auditorium
            SET auditorium_capacity = auditorium_capacity + 2
            WHERE rowid = xxx.rowid;
        END IF;
    END LOOP;

    FOR yyy IN cur(80)
    LOOP
        DBMS_OUTPUT.PUT_LINE(yyy.auditorium || ' ' || yyy.auditorium_capacity);
    END LOOP;

    ROLLBACK;
END;


-- 20. Распечатайте в одном цикле всех преподавателей (TEACHER),
-- разделив группами по три (отделите группы линией -------------).
DECLARE
    CURSOR cursor_teach IS SELECT TEACHER, TEACHER_NAME, PULPIT
                             FROM teacher;
    v_teacher teacher.teacher%TYPE;
    v_teacher_name teacher.teacher_name%TYPE;
    v_pulpit teacher.pulpit%TYPE;
    txt VARCHAR2(200);
BEGIN
    OPEN cursor_teach;
    LOOP
        FETCH cursor_teach INTO v_teacher, v_teacher_name, v_pulpit;
        EXIT WHEN cursor_teach%NOTFOUND;

        txt := ' ' || cursor_teach%ROWCOUNT || ' ' || RTRIM(v_teacher) || ' ' || LTRIM(v_teacher_name) ||
                    ' ' || LTRIM(v_pulpit);

        DBMS_OUTPUT.PUT_LINE(txt);

        IF MOD(cursor_teach%ROWCOUNT, 3) = 0 THEN
            DBMS_OUTPUT.PUT_LINE('-----------------------');
        END IF;
    END LOOP;
    CLOSE cursor_teach;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLCODE || ' ' || SQLERRM);
END;








insert into AUDITORIUM VALUES ('112-3', '112-3', 50, 'ЛК');
insert into AUDITORIUM VALUES ('133-1', '133-1', 10, 'ЛК-К');