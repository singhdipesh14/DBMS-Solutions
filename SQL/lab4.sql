1->
select course_id,
	title,
	count(*)
from takes
	natural join course
group by (course_id, title);
2->with cnt_stu(dept_name, cnt) as (
	select dept_name,
		count(*)
	from student
	group by dept_name
)
select dept_name,
	cnt
from cnt_stu
where cnt > 100;
3->
select dept_name,
	count(*)
from course
group by (dept_name);
4->with avg_sal(dept_name, sal_avg) as (
	select dept_name,
		avg(salary)
	from instructor
	group by dept_name
)
select dept_name,
	sal_avg
from avg_sal
where sal_avg > 100000;
5->
select sec_id,
	semester,
	year,
	count(distinct ID)
from takes
group by (sec_id, semester, year)
having semester = 'Spring'
	and year = 2009;
6->
select *
from prereq
order by course_id asc;
7->
select *
from instructor
order by salary desc;
8->
select max(sal)
from (
		select dept_name,
			sum(salary) as sal
		from instructor
		group by dept_name
	);
9->
select dept_name,
	average
from (
		select dept_name,
			avg(salary) as average
		from instructor
		group by dept_name
	)
where average > 42000;
10->
select sec_id,
	total
from (
		select sec_id,
			count(distinct ID) as total
		from takes
		where semester = 'Fall'
			and year = 2009
		group by (sec_id)
	)
where total >= all(
		select count(distinct ID) as total
		from takes
		where semester = 'Spring'
			and year = 2010
		group by (sec_id)
	);
11->
select distinct name
from instructor
	natural join teaches
where course_id in (
		select distinct course_id
		from takes
			natural join course
		where dept_name = 'Comp. Sci.'
	);
12->
select dept_name,
	total,
	avg_sal
from(
		select dept_name,
			count(*) as total,
			avg(salary) as avg_sal
		from instructor
		group by dept_name
	)
where total > 5
	and avg_sal > 50000;
13->with max_bug(val) as (
	select max(budget)
	from department
)
select dept_name,
	budget
from department,
	max_bug
where budget = val;
14->with tot(dept_name, total) as (
	select dept_name,
		sum(salary) as tot
	from instructor
	group by dept_name
),
avge(val) as (
	select avg(total)
	from tot
)
select dept_name,
	total
from tot,
	avge
where total > val;
15->with totl(sec_id, cnt) as (
	select sec_id,
		count(distinct ID)
	from takes
	where semester = 'Fall'
		and year = 2009
	group by sec_id
),
mx(val) as (
	select max(cnt)
	from totl
)
select sec_id,
	cnt
from totl,
	mx
where cnt = val;
16->with tot_credits(dept_name, credits) as (
	select dept_name,
		sum(tot_cred)
	from student
	group by dept_name
),
fin_tot(val) as (
	select sum(tot_cred)
	from student
	where dept_name = 'Finance'
)
select dept_name,
	credits
from tot_credits,
	fin_tot
where credits > val;
17->savepoint q17;
delete from instructor
where dept_name = 'Finance';
18->
delete from takes
where course_id in (
		select course_id
		from takes
			natural join course
		where dept_name = 'Comp. Sci.'
	);
delete from teaches
where course_id in (
		select course_id
		from teaches
			natural join course
		where dept_name = 'Comp. Sci.'
	);
delete from prereq
where course_id in (
		select course_id
		from prereq
			natural join course
		where dept_name = 'Comp. Sci.'
	)
	or prereq_id in (
		select c.course_id
		from prereq p,
			course c
		where dept_name = 'Comp. Sci.'
			and p.prereq_id = c.course_id
	);
delete from course
where dept_name = 'Comp. Sci.';
19->
update student
set dept_name = 'Physics'
where dept_name = 'Comp. Sci.';
20->
update instructor
set salary = case
		when salary > 100000 then salary * 1.03
		else salary * 1.05
	end;
rollback;
(
	select distinct name
	from instructor
		natural join teaches
	where course_id in (
			select distinct course_id
			from takes
				natural join student
			where dept_name = 'Comp. Sci.'
		)
)
minus
(
	select distinct name
	from instructor
		natural join teaches
	where course_id in (
			select distinct course_id
			from takes
				natural join course
			where dept_name = 'Comp. Sci.'
		)
);
select i.id
from instructor i
where not exists (
		(
			select distinct ID
			from student
			where dept_name = 'Comp. Sci.'
		)
		minus
		(
			select t.ID
			from takes t
				inner join teaches s using(sec_id, course_id, semester, year)
			where s.ID = i.ID
		)
	);
select distinct ID
from student
where dept_name = 'Comp. Sci.'
minus
select distinct t.id
from takes t
	inner join teaches s using(sec_id, course_id, semester, year)
where s.ID = '90376';