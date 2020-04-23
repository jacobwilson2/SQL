--PL/SQL block statement that fires a trigger when an employee's
--salary exceeds a specified salary cap.

CREATE OR REPLACE TRIGGER salaryCapacity AFTER INSERT OR UPDATE ON PAYROLL
declare
 counter INTEGER;

begin

    select count(ESalary) into counter from PAYROLL
    where ESalary > 10000;

    if (counter > 3) then
        RAISE_APPLICATION_ERROR(-20001, 'No more than 3 employees can make over $10,000/Month');
    end if;
end;
/
