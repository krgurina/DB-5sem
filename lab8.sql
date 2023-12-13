--SET serveroutput ON;
-- 1. Разработайте простейший анонимный блок PL/SQL (АБ), не содержащий операторов.
begin
    null;
end;

-- 2. Разработайте АБ, выводящий «Hello World!». Выполните его в SQLDev и SQL+.
declare
begin
    DBMS_OUTPUT.PUT_LINE('Hello World!');
end;
/

-- 3. Продемонстрируйте работу исключения и встроенных функций sqlerrm, sqlcode.
declare
  num NUMBER;
begin
  num := 1/0;
exception
  when others then
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    DBMS_OUTPUT.PUT_LINE('Error code: ' || SQLCODE);
end;

-- 4. Разработайте вложенный блок. Продемонстрируйте принцип обработки исключений во вложенных блоках.
DECLARE
    num NUMBER;
begin
    begin
        num := 1/0;
    exception
    when others then
        dbms_output.put_line('Error: ' || sqlerrm);
        dbms_output.put_line('Error code: ' || sqlcode);
    end;
  dbms_output.put_line('Внешний блок');
end;

--system
-- 5. Выясните, какие типы предупреждения компилятора поддерживаются в данный момент.
--show parameter plsql_warnings;
select name, type, value from v$parameter where name = 'plsql_warnings';

-- 6. Разработайте скрипт, позволяющий просмотреть все спецсимволы PL/SQL.
select keyword from V$RESERVED_WORDS
    where LENGTH = 1 and KEYWORD != 'A';

-- 7. Разработайте скрипт, позволяющий просмотреть все ключевые слова PL/SQL.
select keyword from V$RESERVED_WORDS
    where LENGTH > 1 and keyword != 'A'
    order by keyword;

-- 8. Разработайте скрипт, позволяющий просмотреть все параметры Oracle Server, связанные с PL/SQL.
-- Просмотрите эти же параметры с помощью SQL+-команды show.
select name, value from v$parameter
where name like 'plsql%';

show parameter plsql;

-- 9. Разработайте анонимный блок, демонстрирующий (выводящий в выходной серверный поток результаты):
-- 10. объявление и инициализацию целых number-переменных;
-- 9-17
declare
    n9 number := 2;
    n10 number(3) := 12;
    n12 number(10, 2) := 3.33;
    n13 number(10, -3) := 999.44;
    n14 binary_float := 1234578911.12345678911;
    n15 binary_double := 12345678911.12345678911;
    n16 number(38, 10) := 12345E+10;
    n17 boolean := true;
begin
    dbms_output.put_line('n9 = ' || n9);
    dbms_output.put_line('n11:+ = ' || (n9+n10));
    dbms_output.put_line('n11:- = ' || (n9-n10));
    dbms_output.put_line('n11:* = ' || (n9*n10));
    dbms_output.put_line('n11:/ = ' || (n9/n10));
    dbms_output.put_line('n11:/ = ' || mod(n9, n10));
    dbms_output.put_line('fixed = ' || n12);
    dbms_output.put_line('rounded = ' || n13);
    dbms_output.put_line('binary float = ' || n14);
    dbms_output.put_line('binary double = ' || n15);
    dbms_output.put_line('E+10 = ' || n16);
    if n17 then
        dbms_output.put_line('boolean = ' || 'true');
    else
        dbms_output.put_line('boolean = ' || 'false');
    end if;
end;

-- 18. Разработайте анонимный блок PL/SQL содержащий объявление констант (VARCHAR2, CHAR, NUMBER).
-- Продемонстрируйте возможные операции константами.
declare
    const_varchar CONSTANT VARCHAR2(20) := 'CONSTANT VARCHAR2';
    condt_char CONSTANT CHAR(20) := 'CONSTANT CHAR';
    const_number CONSTANT NUMBER := 1;
begin
    dbms_output.put_line(const_varchar);
    dbms_output.put_line(condt_char);
    dbms_output.put_line(const_number);
END;

-- 19. Разработайте АБ, содержащий объявления с опцией %TYPE. Продемонстрируйте действие опции.
declare
    faculty gks.faculty.faculty%type;
begin
    faculty :='ИТ';
    dbms_output.put_line(faculty);
end;

-- 20. Разработайте АБ, содержащий объявления с опцией %ROWTYPE. Продемонстрируйте действие опции.
declare
    faculty gks.faculty%rowtype;
begin
    faculty.faculty := 'ИТ';
    faculty.faculty_name := 'Факультет информационных технологий';
    dbms_output.put_line(faculty.faculty || faculty.faculty_name);
end;

-- 21-22. Разработайте АБ, демонстрирующий все возможные конструкции оператора IF.
declare
  num NUMBER := 1;
begin
  IF num < 10 THEN
    DBMS_OUTPUT.PUT_LINE('num < 10');
  ELSIF num > 2 THEN
    DBMS_OUTPUT.PUT_LINE('num > 2');
  ELSIF num is null THEN
    DBMS_OUTPUT.PUT_LINE('num is null');
  ELSE
    DBMS_OUTPUT.PUT_LINE('num');
  END IF;
END;


-- 23. Разработайте АБ, демонстрирующий работу оператора CASE.
declare
  num NUMBER := 1;
begin
  case num
    WHEN 1 THEN
      DBMS_OUTPUT.PUT_LINE('num = 1');
    WHEN 2 THEN
      DBMS_OUTPUT.PUT_LINE('num = 2');
    WHEN 3 THEN
      DBMS_OUTPUT.PUT_LINE('num = 3');
    ELSE
      DBMS_OUTPUT.PUT_LINE('num is null');
  END CASE;
END;

-- 24. Разработайте АБ, демонстрирующий работу оператора LOOP.
declare
    i NUMBER := 0;
begin
    loop
        i := i + 2;
        dbms_output.put_line(i);
        exit when i >= 10;
    end loop;
end;

-- 25. Разработайте АБ, демонстрирующий работу оператора WHILE.
declare
  i NUMBER := 0;
begin
  WHILE i <= 10 LOOP
    i := i + 2;
    DBMS_OUTPUT.PUT_LINE(i);
  END LOOP;
END;

-- 26. Разработайте АБ, демонстрирующий работу оператора FOR.
declare
  i NUMBER := 1;
begin
  FOR i IN 4..10 LOOP
    DBMS_OUTPUT.PUT_LINE(i);
  END LOOP;
END;