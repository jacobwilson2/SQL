--Collection of PL/SQL blocks that transform company data.

--1
DECLARE
    empSal emp.sal%TYPE;
    totalSal emp.sal%TYPE := 0;
    empCount INT := 0;
    CURSOR salCurs IS SELECT sal FROM emp;
BEGIN
    OPEN salCurs;
    LOOP
        FETCH salCurs INTO empSal;
        EXIT WHEN salCurs%NOTFOUND;
            IF ( empSal < 1000 ) THEN
                totalSal := totalSal + 1000;
            ELSE
                totalSal := totalSal + empSal;
            END IF;

        empCount := empCount + 1;
    END LOOP;
    CLOSE salCurs;
    DBMS_OUTPUT.PUT_LINE('Average salary: ' || ROUND(totalSal / empCount, 2));
END;
/

--2
DROP TABLE temp_emp;
CREATE TABLE temp_emp AS SELECT * FROM emp;

DECLARE
    raiseDept emp.deptno%TYPE := 10;
    deleteDept emp.deptno%TYPE := 20;

BEGIN
    UPDATE temp_emp
        set sal = sal * 1.10
            WHERE deptno = raiseDept;


    DBMS_OUTPUT.PUT_LINE('Number of employees recieving raise: ' || TO_CHAR(SQL%ROWCOUNT));

    DELETE FROM temp_emp
    WHERE deptno = deleteDept;

    DBMS_OUTPUT.PUT_LINE('Number of rows deleted: ' || TO_CHAR(SQL%ROWCOUNT));
END;
/

--3
DECLARE
    CURSOR c1 IS
    SELECT last_name FROM employees;
    ename     employees.last_name%TYPE;

BEGIN
    OPEN c1;
    FETCH c1 INTO ename;
    IF c1%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Yes, curse c1 is found');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No, curse c1 is NOT found');
    END IF;
    CLOSE c1;
END;
/

--4
DECLARE
    CURSOR cemp  IS
     	SELECT   ename, sal
    	FROM     emp
        WHERE	 deptno = 10
    	ORDER BY sal DESC;

    --Emp_name   	emp.ename%TYPE;
    --salary   	emp.sal%TYPE;

BEGIN
    --OPEN cemp;
    FOR indx IN cemp LOOP
     	--FETCH cemp INTO Emp_name, salary;
        --EXIT WHEN cemp%NOTFOUND;
        DBMS_OUTPUT.put_line ('current row number is: '|| cemp%ROWCOUNT ||
   ':  ' || RPAD (indx.ename, 10) || ': ' ||indx.sal ||'.');
    END LOOP;
    --CLOSE cemp;
END;
/

--5
DECLARE
    CURSOR cemp  IS
     	SELECT   *
    	FROM     employees
    	ORDER BY salary DESC;

    v_employees employees%ROWTYPE;
    counter INT := 0;

BEGIN
    OPEN cemp;
    LOOP
        FETCH cemp INTO v_employees;
        EXIT WHEN counter = 5;
        DBMS_OUTPUT.PUT_LINE(v_employees.employee_id || ' : ' || v_employees.first_name || ',' || v_employees.last_name || ' : ' || v_employees.salary);
        counter := counter + 1;
    END LOOP;
    CLOSE cemp;
END;
/

--6
DECLARE
    CURSOR cemp  IS
     	SELECT   employee_id, first_name, last_name, salary
    	FROM     employees
    	ORDER BY salary DESC;

    empID employees.employee_id%TYPE;
    empFirst employees.first_name%TYPE;
    empLast employees.last_name%TYPE;
    empSal employees.salary%TYPE;

    counter INT := 0;

BEGIN
    OPEN cemp;
    LOOP
        FETCH cemp INTO empID, empFirst, empLast, empSal;
        EXIT WHEN counter = 5;
        DBMS_OUTPUT.PUT_LINE(empID || ' : ' || empFirst || ',' || empLast || ' : ' || empSal);
        counter := counter + 1;
    END LOOP;
    CLOSE cemp;
END;
/

--7
DECLARE
    CURSOR cemp  IS
     	SELECT   salary, commission_pct
    	FROM     employees
        WHERE department_id = 80 OR department_id = 30;

    empSal employees.salary%TYPE;
    empCom employees.commission_pct%TYPE;
    bonus employees.salary%TYPE := 0;

BEGIN
    OPEN cemp;
    LOOP
        FETCH cemp INTO empSal, empCom;
        EXIT WHEN cemp%NOTFOUND;

        CASE
            WHEN empCom >= .2 THEN
                IF empSal >= 10000 THEN
                    bonus := bonus + 500;
                ELSIF empSal < 10000 AND empSal >= 8000 THEN
                    bonus := bonus + 600;
                ElSIF empSal < 8000 AND empSal >= 7000 THEN
                    bonus := bonus + 700;
                ELSE
                    bonus := bonus + 800;
                END IF;

            WHEN empCom < .2 AND empCom > 0 THEN
                IF empSal >= 10000 THEN
                    bonus := bonus + 400;
                ELSIF empSal < 10000 AND empSal >= 8000 THEN
                    bonus := bonus + 500;
                ElSIF empSal < 8000 AND empSal >= 7000 THEN
                    bonus := bonus + 600;
                ELSE
                    bonus := bonus + 700;
                END IF;

            WHEN empCom IS NULL or empCom = 0 THEN
                IF empSal >= 10000 THEN
                    bonus := bonus + 300;
                ELSIF empSal < 10000 AND empSal >= 3000 THEN
                    bonus := bonus + 400;
                ElSIF empSal < 3000 AND empSal >= 2600 THEN
                    bonus := bonus + 500;
                ELSE
                    bonus := bonus + 600;
                END IF;
        END CASE;
    END LOOP;
    CLOSE cemp;
    DBMS_OUTPUT.PUT_LINE('Total bonus : ' || bonus);
END;
/

--8
DECLARE
    CURSOR c_emp(p_deptID number) IS
        SELECT first_name, last_name
        FROM employees
        WHERE department_id = p_deptID;

    empFirst employees.first_name%TYPE;
    empLast employees.last_name%TYPE;

BEGIN
    OPEN c_emp(20);
    LOOP
        FETCH c_emp INTO empFirst, empLast;
        EXIT WHEN c_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(empFirst || ',' || empLast);
    END LOOP;
    CLOSE c_emp;

    DBMS_OUTPUT.PUT_LINE(' ');

    OPEN c_emp(90);
    LOOP
        FETCH c_emp INTO empFirst, empLast;
        EXIT WHEN c_emp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(empFirst || ',' || empLast);
    END LOOP;
    CLOSE c_emp;
END;
/

--9
DECLARE
    CURSOR cemp IS
        SELECT employee_id, last_name, salary, commission_pct
        FROM employees
        FOR UPDATE OF salary;

    empID  employees.employee_id%TYPE;
    empLast employees.last_name%TYPE;
    empSal employees.salary%TYPE;
    empCom employees.commission_pct%TYPE;
    orgSal employees.salary%TYPE;

BEGIN
    OPEN cemp;
    LOOP
        FETCH cemp INTO empID, empLast, empSal, empCom;
        EXIT WHEN cemp%NOTFOUND;
        IF empSal < 2499 AND (empCom IS NULL OR empCom = 0) THEN
            orgSal := empSal;
            empSal := empSal * 1.05;
            UPDATE employees
                SET salary = empSal
                WHERE CURRENT OF cemp;
            DBMS_OUTPUT.PUT_LINE(empID || ', ' || empLast || ' [ Old salary: ' || orgSal || ', New salary: ' || empSal || ' ]');
        END IF;
    END LOOP;
    CLOSE cemp;
ROLLBACK;
END;
/
