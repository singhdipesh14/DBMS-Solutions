DECLARE roll studenttable.rollno %TYPE;
gp studenttable.gpa %TYPE;
BEGIN roll := '&r';
select gpa into gp
from studenttable
where rollno = roll;
DBMS_OUTPUT.PUT_LINE(
	'The gpa for roll number : ' || TO_CHAR(roll) || ' is : ' || gp
);
END;
/
declare roll studenttable.rollno %type;
gp studenttable.gpa %type;
grade varchar(2);
begin roll := '&r';
select gpa into gp
from studenttable
where rollno = roll;
if gp > 0
and gp <= 4 then grade := 'F';
elsif gp > 4
and gp <= 5 then grade := 'E';
elsif gp > 5
and gp <= 6 then grade := 'D';
elsif gp > 6
and gp <= 7 then grade := 'C';
elsif gp > 7
and gp <= 8 then grade := 'B';
elsif gp > 8
and gp <= 9 then grade := 'A';
else grade := 'A+';
end if;
dbms_output.put_line(
	'The grade for the roll number : ' || to_char(roll) || ' is : ' || grade
);
end;
/
declare issue varchar(20);
retur varchar(20);
days number(5);
fine number(5);
begin issue := '&i';
retur := '&r';
days := to_date(retur, 'dd/mm/yy') - to_date(issue, 'dd/mm/yy');
dbms_output.put_line('The number of days is : ' || days);
if days <= 7 then fine := 0;
elsif days >= 8
and days <= 15 then fine := days;
elsif days >= 16
and days <= 30 then fine := 2 * days;
else fine := 5 * days;
end if;
dbms_output.put_line('The fine is : ' || fine);
end;
/
declare gp studenttable.gpa %type;
grade varchar(2);
begin for i in 1..5 loop
select gpa into gp
from studenttable
where rollno = i;
if gp > 0
and gp <= 4 then grade := 'F';
elsif gp > 4
and gp <= 5 then grade := 'E';
elsif gp > 5
and gp <= 6 then grade := 'D';
elsif gp > 6
and gp <= 7 then grade := 'C';
elsif gp > 7
and gp <= 8 then grade := 'B';
elsif gp > 8
and gp <= 9 then grade := 'A';
else grade := 'A+';
end if;
dbms_output.put_line(
	'The grade for the roll number : ' || to_char(i) || ' is : ' || grade
);
end loop;
end;
/
alter table studenttable
add lettergrade varchar(2);
declare gp studenttable.gpa %type;
grade varchar(2);
begin for i in 1..5 loop
select gpa into gp
from studenttable
where rollno = i;
if gp > 0
and gp <= 4 then grade := 'F';
elsif gp > 4
and gp <= 5 then grade := 'E';
elsif gp > 5
and gp <= 6 then grade := 'D';
elsif gp > 6
and gp <= 7 then grade := 'C';
elsif gp > 7
and gp <= 8 then grade := 'B';
elsif gp > 8
and gp <= 9 then grade := 'A';
else grade := 'A+';
end if;
dbms_output.put_line(
	'The grade for the roll number : ' || to_char(i) || ' is : ' || grade
);
update studenttable
set lettergrade = grade
where rollno = i;
end loop;
end;
/
declare mx studenttable.gpa %type;
cur studenttable.gpa %type;
mxr studenttable.rollno %type;
begin
select gpa into mx
from studenttable
where rollno = 1;
mxr := 1;
for i in 1..5 loop
select gpa into cur
from studenttable
where rollno = i;
if cur > mx then mx := cur;
mxr := i;
end if;
end loop;
dbms_output.put_line(
	'The maximum gpa is of roll no : ' || mxr || ' and the gpa is : ' || mx
);
end;
/
DECLARE gp studenttable.gpa %TYPE;
grade varchar(2);
BEGIN for i in 1..5 loop
select gpa into gp
from studenttable
where rollno = i;
if (
	gp >= 9
	and gp <= 10
) then goto ap;
elsif (
	gp >= 8
	and gp < 9
) then goto aa;
elsif (
	gp >= 7
	and gp < 8
) then goto bb;
elsif (
	gp >= 6
	and gp < 7
) then goto cc;
elsif (
	gp >= 5
	and gp < 6
) then goto dd;
elsif (
	gp >= 4
	and gp < 5
) then goto ee;
else goto ff;
end if;
<< ap >> grade := 'A+';
goto prnt;
<< aa >> grade := 'A';
goto prnt;
<< bb >> grade := 'B';
goto prnt;
<< cc >> grade := 'C';
goto prnt;
<< dd >> grade := 'D';
goto prnt;
<< ee >> grade := 'E';
goto prnt;
<< ff >> grade := 'F';
<< prnt >> dbms_output.put_line(
	'The roll number is :  ' || i || ' and the grade is :  ' || grade
);
end loop;
END;
/
declare row instructor %rowtype;
names instructor.name %type;
begin names := '&n';
select * into row
from instructor
where name = names;
dbms_output.put_line(
	row.id || ' ' || row.name || ' ' || row.salary || ' ' || row.dept_name
);
exception
when TOO_MANY_ROWS then dbms_output.put_line('Multiple values with same name exist');
when NO_DATA_FOUND then dbms_output.put_line('Name not found');
end;
/
declare incorrectGpa exception;
gp studenttable.gpa %type;
grad varchar(2);
begin for i in 1..6 loop
select gpa into gp
from studenttable
where rollno = i;
if gp<0 or gp>10 then raise incorrectGpa;
elsif gp > 0
and gp <= 4 then grad := 'F';
elsif gp > 4
and gp <= 5 then grad := 'E';
elsif gp > 5
and gp <= 6 then grad := 'D';
elsif gp > 6
and gp <= 7 then grad := 'C';
elsif gp > 7
and gp <= 8 then grad := 'B';
elsif gp > 8
and gp <= 9 then grad := 'A';
else grad := 'A+';
end if;
dbms_output.put_line(
	'The grade for the roll number : ' || to_char(i) || ' is : ' || grad
);
update studenttable
set grade = grad
where rollno = i;
end loop;
exception when incorrectGpa then dbms_output.put_line('INcorrect gpa');
end;