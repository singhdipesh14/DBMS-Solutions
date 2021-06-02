-- 1
select bdate,
	address
from employee
where fname = 'Dipesh'
	and minit = 'S'
	and lname = 'Chauhan';
select fname,
	minit,
	lname,
	address
from employee
	natural join department
where name = 'Web Development';
-- 2
select project_code,
	p.dept_no,
	lname,
	address,
	bdate
from employee e,
	(
		select *
		from projects
			inner join department using(dept_no)
		where location = 'Winterfell'
	) p
where manager = ssn;
-- 3
select distinct salary
from employee;
-- 4
select a.fname,
	a.lname,
	b.fname,
	b.lname
from employee a,
	employee b
where a.supervisor = b.ssn;
-- 5
select distinct project_code
from projects
where project_code in (
		select project_code
		from works
			natural join employee
		where lname = 'Chauhan'
	)
	or project_code in (
		select project_code
		from projects
			inner join (
				select d.dept_no,
					lname
				from department d,
					employee e
				where manager = ssn
			) using(dept_no)
		where lname = 'Chauhan'
	);
-- 6
select *
from employee
where address = 'Arryn';
-- 7
select fname,
	lname,
	salary * 1.01
from employee e,
	works w,
	projects p
where e.ssn = w.ssn
	and w.project_code = p.project_code
	and p.name = 'Web Scraper';
-- 8
select *
from employee
where dept_no = 11111111
	and salary >= 30000
	and salary <= 40000;
-- 9
select fname,
	lname,
	project_code,
	dept_no
from employee
	natural join works
order by dept_no,
	lname,
	fname;
-- 10
select *
from employee
where supervisor is null;
-- 11
select fname,
	lname
from employee e
	inner join dependents d using(ssn)
where fname = name
	and d.sex = e.sex;
-- 12
select fname,
	lname
from employee
	left outer join dependents using(ssn)
where name is null;
-- 13
select distinct fname,
	lname
from (
		select *
		from employee,
			department
		where manager = ssn
	)
	left outer join dependents d using(ssn)
where d.name is not null;
-- 14
select ssn
from works
where project_code = 123
	or project_code = 1234
	or project_code = 123456;
-- 15
select max(salary) as maximum,
	min(salary) as minimum,
	avg(salary) as average,
	sum(salary) as summation
from employee;
-- 16
select max(salary),
	min(salary),
	avg(salary),
	sum(salary)
from (
		select *
		from employee
			inner join department using(dept_no)
	)
group by name
having name = 'Web Development';
-- 17
with suum(project_code, no_of_emp) as (
	select project_code,
		count(*)
	from works
	group by project_code
)
select project_code,
	name,
	no_of_emp
from suum
	inner join projects using(project_code);
-- 18
with suum(project_code, no_of_emp) as (
	select project_code,
		count(*)
	from works
	group by project_code
)
select project_code,
	name,
	no_of_emp
from suum
	inner join projects using(project_code)
where no_of_emp > 2;
-- 19
with one(dept_no, no) as (
	select dept_no,
		count(*)
	from employee
	group by dept_no
),
two(dept_no, no) as (
	select dept_no,
		count(*)
	from employee
	where salary > 40000
	group by dept_no
)
select a.dept_no,
	b.no
from one a,
	two b
where a.dept_no = b.dept_no
	and a.no > 5;