2)
DECLARE
    dID departments.department_id%TYPE := 299;
    dName departments.department_name%TYPE := 'Future';
    mgrID departments.manager_id%TYPE := 145;
    locID departments.location_id%TYPE := 1700;

BEGIN
    INSERT INTO departments
    VALUES (dID, dName, mgrID, locID);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('New record department with ID = ' || dID || ' ; Name = ' || dName || ' ; Manager ID = ' || mgrID || ' ; Location ID = ' || locID || '.');
END;
/


3)
DECLARE
    dName departments.department_name%TYPE;
    mgrID departments.manager_id%TYPE;

BEGIN
    DELETE FROM departments WHERE department_id = 299
    RETURNING department_name, manager_id
    INTO dName, mgrID;

    DBMS_OUTPUT.PUT_LINE('After DELETION: the record deleted had Department_Name = ' || dName || ', Manager_ID = ' || mgrID || '.');

END;
/


4)
DECLARE
    empID employees.employee_id%TYPE;
    lastName employees.last_name%TYPE;
    countNO NUMBER;

BEGIN
    SELECT COUNT(employee_id)
    INTO countNO
    FROM employees
    WHERE department_id IS NULL;

    SELECT employee_id, last_name
    INTO empID, lastName
    FROM employees
    WHERE department_id IS NULL;

    if countNO = 1 THEN
        UPDATE employees
        SET department_id = 60
        WHERE department_id IS NULL;

        DBMS_OUTPUT.PUT_LINE('Employee ID = ' || empID || ', Last Name = ' || lastName);

    else
        DBMS_OUTPUT.PUT_LINE('Not 1 employee with NULL dept');

    end if;

END;
/


5)
DECLARE
    avgSal EMPLOYEES.salary%TYPE;

BEGIN
    SELECT AVG(salary)
    INTO avgSal
    FROM Employees
    GROUP BY department_id
    HAVING department_id = 50;

    CASE
        WHEN avgSal > 3500 THEN DBMS_OUTPUT.PUT_LINE('High');
        WHEN avgSal <= 3500 AND avgSal >= 2500 THEN DBMS_OUTPUT.PUT_LINE('OK');
        ELSE DBMS_OUTPUT.PUT_LINE('Low');
    END CASE;
END;
/


6)
DECLARE
    bonus employees.salary%TYPE := 500;

    empID employees.employee_id%TYPE;
    empSal employees.salary%TYPE;
    empTen employees.hire_date%TYPE;

    CURSOR sal IS SELECT employee_id, salary, hire_date FROM employees;

BEGIN
    OPEN sal;
    LOOP
        FETCH sal INTO empID, empSal, empTen;
        IF (sal%FOUND) THEN
            IF(FLOOR(MONTHS_BETWEEN(sysdate, empTen)/12) >= 24) THEN
                bonus := bonus + 240;
            END IF;

            IF(empSal > 10000) THEN
                bonus := bonus + 200;
            ELSIF(empSal <= 10000 AND empSal >= 6000) THEN
                bonus := bonus + 400;
            ELSE
                bonus := bonus + 800;
            END IF;

            DBMS_OUTPUT.PUT_LINE('EMP ID = ' || empID);
            DBMS_OUTPUT.PUT_LINE('SALARY = ' || empSal);
            DBMS_OUTPUT.PUT_LINE('YEARS = ' || FLOOR(MONTHS_BETWEEN(sysdate, empTen)/12));
            DBMS_OUTPUT.PUT_LINE('BONUS = ' || bonus);
            DBMS_OUTPUT.PUT_LINE(' ');

        END IF;
        bonus := 500;
    END LOOP;
END;
/
