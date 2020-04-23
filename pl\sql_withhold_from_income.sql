
--PL/SQL block that decides how much income tax to withhold
--from employee payroll

declare
    r1 WITHHOLD.Rate1%type;
    r2 WITHHOLD.Rate2%type;
    thresh WITHHOLD.Threshold%type;

    employeeId PAYROLL.EID%type;
    employeeSalary PAYROLL.ESalary%type;
    tax PAYROLL.ESalary%type;
    total PAYROLL.ESalary%type := 0;

    cursor monSalary is SELECT EID, ESalary FROM PAYROLL;

begin

    SELECT rate1, rate2, Threshold INTO r1, r2, thresh
    FROM WITHHOLD;

    DBMS_OUTPUT.PUT_LINE( 'Rates: ' || r1 || ', ' || r2 );
    DBMS_OUTPUT.PUT_LINE( 'Threshold: ' || thresh );
    DBMS_OUTPUT.PUT_LINE('');

    open monSalary;

    loop

        fetch monSalary into employeeID, employeeSalary;
        if (monSalary%found AND employeeSalary <= thresh) then
            tax := (employeeSalary * (r1/100));
            DBMS_OUTPUT.PUT_LINE(employeeID || ': ' || employeeSalary || ' ' || tax || ' ' || (employeeSalary - (employeeSalary * (r1/100))));
            total := total + tax;
        elsif (monSalary%found AND employeeSalary > thresh) then
            tax := (thresh * (r1/100) + ((employeeSalary - thresh) * (r2/100)));
            DBMS_OUTPUT.PUT_LINE(employeeID || ': ' || employeeSalary || ' ' || tax || ' ' || (employeeSalary - (employeeSalary * (r2/100))));
            total := total + tax;
        else
            exit;
        end if;

    end loop;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Total tax: ' || total);
end;
/
