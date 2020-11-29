#CLASS TABLE
CREATE TABLE Class
(class_id VARCHAR(10) NOT NULL,
class_name VARCHAR(20) NOT NULL,
PRIMARY KEY (class_id)
);

INSERT INTO db_hw.Class
(class_id, class_name)
VALUES 
(101, 'Geometry'),
(102, 'English'),
(103, 'Physics');

INSERT INTO db_hw1.Student
(student_id, first_name, last_name)
VALUES 
(500, 'Robert', 'Smith'),
(762, 'Frank', 'Carter'),
(881, 'Joseph', 'Evans'),
(933, 'Anne',  'Baker');

INSERT INTO db_hw1.Enrollment
(class_id, student_id, semester, grade)
VALUES 
(101, 500, 'Fall 2019', 'A'),
(102, 500, 'Fall 2019', 'B'),
(103, 762, 'Fall 2019', 'F'),
(101, 881, 'Spring 2020', 'B'),
(102, 881, 'Fall 2020', 'B'),
(103, 762, 'Spring 2021', null);


##Prompt1
#Q1
select *
from Enrollment 
where grade in ('A', 'B');

#Q2
select s.first_name, s.last_name
from Student s 
inner join Enrollment e 
on s.student_id = e.student_id
inner join Class c 
on e.class_id = c.class_id
where c.class_name = 'Geometry';

#Q3
select *
from Enrollment
where grade <> 'F' 
	  or grade is null;

#Q4
select first_name
      ,last_name 
      ,sum(class_id) as class_id
      ,group_concat(grade SEPARATOR '') as grade
from(
  select s.first_name
        ,s.last_name
        ,case when e.class_id = 102 then class_id 
         else null
         end as class_id
        ,case when e.class_id = 102 then grade
         else null
         end as grade
  from db_hw1.Student s 
  left join db_hw1.Enrollment e
  on s.student_id = e.student_id
    )a
group by first_name, last_name;
;

#Q5
select class_id 
      ,count(distinct student_id) as student_cnt 
from Enrollment 
group by class_id;

#Q6
UPDATE Enrollment 
SET grade = 'B+'
where student_id = 500
	  and class_id = 102
;

#Q7
UPDATE Enrollment 
SET grade = 'B+'
where class_id = 102
and student_id in 
(select student_id  
 from Student
 where first_name = 'Robert' 
       and last_name = 'Smith'
); 

#Q8
insert into db_hw.Student 
(student_id, first_name, last_name)
VALUES 
(816, 'Michael', 'Cronin');

#Q9
insert into db_hw.Enrollment 
(class_id, student_id, semester)
select (select class_id from2WO Class where class_name = 'Geometry') as c_id
  	  ,(select student_id from Student where first_name = 'Michael' and  last_name = 'Cronin') as s_id
  	  ,'Spring 2020' as semester 
;   

#q10
SELECT  s.first_name
	   ,s.last_name 
from student s 
where s.student_id not in 
(select e.student_id 
 from Enrollment e
 where e.student_id = s.student_id);

#q11
SELECT  s.first_name
 	   ,s.last_name
from student s 
inner join Enrollment e
where s.student_id not in 
(select distinct student_id from Enrollment)
group by s.first_name, s.last_name;

#q12
DELETE FROM Student 
WHERE student_id not in 
(select distinct student_id from Enrollment);


#prompt2

INSERT INTO db_hw.Customer_Order
(order_num, cust_id, order_date)
VALUES
(1, 121, '01-15-2019'),
(2, 234, '07-24-2019'),
(3, 336, '05-02-2020'),
(4, 121, '01-15-2019'),
(5, 336, '03-19-2020'),
(6, 234, '07-24-2019'),
(7, 121, '01-15-2019'),
(8, 336, '06-12-2020');

#Q1
select distinct cust_id 
from Customer_Order;

#Q2
select  cust_id
    ,max(str_to_date(order_date, '%m-%d-%Y')) AS DATE
from customer_order
group by cust_id;

#Q3
select * 
from Customer_Order 
order by str_to_date(order_date, '%m-%d-%Y') DESC, cust_id asc; 

#Q4
select cust_id
from Customer_Order 
group by cust_id
having min(order_num) >=3;

#Q5
select cust_id 
      ,order_date
from Customer_Order 
group by cust_id
		,order_date
having count(*) >= 2;

INSERT INTO db_hw.Customer
(cust_id, cust_name)
VALUES
(121, 'Acme Wholesalers'),
(234, 'Griffin Electric'),
(336, 'East Coast Marine Supplies'),
(544, 'Sanford Automotive');
 
#Q6
select cust_name 
from Customer c
where c.cust_id in 
(select co.cust_id 
 from Customer_Order co
 where co.cust_id = c.cust_id
 having count(*)  = 3
);

#Q7
select cust_name 
from Customer c
where c.cust_id in 
(select cust_id 
from Customer_Order 
group by cust_id
having count(*) = 3
);

#Q8
select c.cust_name 
      ,(select count(*) from Customer_Order co where c.cust_id = co.cust_id) as order_cnt
from Customer c;










