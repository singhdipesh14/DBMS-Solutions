(
	select course_id
	from section
	where semester = 'Fall'
		and year = 2009
)
union
(
	select course_id
	from section
	where semester = 'Spring'
		and year = 2010
);
(
	select course_id
	from section
	where semester = 'Fall'
		and year = 2009
)
intersect
(
	select course_id
	from section
	where semester = 'Spring'
		and year = 2010
);
(
	select course_id
	from section
	where semester = 'Fall'
		and year = 2009
)
minus
(
	select course_id
	from section
	where semester = 'Spring'
		and year = 2010
);
select title
from course
where course_id not in (
		select unique course_id
		from takes
	);
select course_id
from section
where semester = 'Fall'
	and year = 2009
	and course_id in (
		select course_id
		from section
		where semester = 'Spring'
			and year = 2010
	);
select count(unique C.ID) as cnt
from takes C
where course_id in (
		select course_id
		from teaches T
		where T.ID = 10101
	);
select course_id
from section
where semester = 'Fall'
	and year = 2009
	and course_id not in (
		select course_id
		from section
		where semester = 'Spring'
			and year = 2010
	);
select name
from student S
where name in (
		select all name
		from instructor I
		where I.name = S.name
	);
select name
from instructor
where salary > some(
		select salary
		from instructor
		where dept_name = 'Biology'
	);
select name
from instructor
where salary > all(
		select salary
		from instructor
		where dept_name = 'Biology'
	);
with avg_sal(dept_name, val) as (
	select dept_name,
		avg(salary)
	from instructor
	group by dept_name
),
max_avg(val) as (
	select max(val)
	from avg_sal
)
select dept_name
from avg_sal a,
	max_avg b
where a.val = b.val;
select dept_name
from department
where budget < all(
		select avg(salary)
		from instructor
	);
select course_id
from section S
where semester = 'Spring'
	and year = 2010
	and exists(
		select course_id
		from section T
		where semester = 'Fall'
			and year = 2009
			and T.course_id = S.course_id
	);
select distinct S.ID,
	S.name
from student S
where not exists(
		(
			select course_id
			from course
			where dept_name = 'Biology'
		)
		minus
		(
			select T.course_id
			from takes T
			where S.ID = T.ID
		)
	);
select course_id
from (
		select course_id,
			count (*) count
		from section
		where section.year = 2009
		group by course_id
	)
where count = 1;
select ID
from (
		select ID,
			count(*) as c
		from takes
			natural join course
		where dept_name = 'Comp. Sci.'
		group by ID
	)
where c >= 2;
select dept_name,
	average
from (
		select dept_name,
			avg(salary) as average
		from instructor
		group by dept_name
	)
where average > 42000;
create view all_courses as (
	select course.course_id,
		sec_id,
		building,
		room_number
	from course,
		section
	where course.course_id = section.course_id
		and course.dept_name = 'Physics'
		and section.semester = 'Fall'
		and section.year = 2009
);
select *
from all_courses;
create view department_total_salary as (
	select dept_name,
		sum(salary) as total_sal
	from instructor
	group by dept_name
);
select *
from department_total_salary;