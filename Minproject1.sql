---1
create table lodge_details(
lodge_name varchar2(30) constraint lodgeDetails_lodgeName_pk primary key,
lodge_manager varchar2(30) not null,
lodge_address varchar2(30)
);
------------------------------------------
create table emp_details(
empno integer constraint empDetails_empno_pk primary key,
first_name varchar2(30) not null,
last_name varchar2(30) not null,
lodge_name varchar2(30) constraint empDetails_lodgeName_fk references 
lodge_details (lodge_name)
);
---------------------------------------------
create table skill_details(
skill varchar2(30) constraint skillDetails_skill_pk primary key,
skill_desc varchar2(30)
);
---------------------------------------------
create table emp_skill(
empno integer constraint empSkill_empno_fk references emp_details(empno),
skill varchar2(30) constraint empSkill_skill_fk references skill_details(skill),
grade number(10),
primary key(empno,skill)
);
--------------------------------------------
commit;
desc lodge_details;
--------------------------------------------------------------------------------------------------------
---2
insert into lodge_details values('Jessy Lodge','Rajan','Rakesh Nagar');
insert into lodge_details values('Rajesh Lodge','Rajani','Anna Nagar');
insert into lodge_details values('Gooday Lodge','John','Sea Road');
select * from lodge_details;
commit;
---------------------------------------------
insert into emp_details values(101,'James','Jackson','Rajesh Lodge');
insert into emp_details values(102,'Kalpash','Raj','Gooday Lodge');
insert into emp_details values(103,'Jasmine','Joy','Jessy Lodge');
select * from emp_details;
commit;
---------------------------------------------
insert into skill_details values('Oracle SQL','Oracle Corporation');
insert into skill_details values('Dot Net','Microsoft');
insert into skill_details values('Sybase','SAP Corporation');
select * from skill_details;
commit;
----------------------------------------------
insert into emp_skill values(101,'Oracle SQL',9);
insert into emp_skill values(101,'Sybase',8);
insert into emp_skill values(102,'Dot Net',9);
insert into emp_skill values(103,'Oracle SQL',8);
select * from emp_skill;
commit;
-------------------------------------------------------------------------------------------
select * from emp_details;
---3
update emp_details set lodge_name = 'Gooday Lodge' where empno=101;
commit;
-------------------------------------------------------------------------------------------
alter table emp_details drop constraint empDetails_lodgeName_fk;
alter table emp_details modify lodge_name varchar2(30) constraint empDetails_lodgeName_fk references 
lodge_details (lodge_name) on delete cascade;

alter table emp_skill drop constraint empSkill_empno_fk;
alter table emp_skill modify empno integer constraint empSkill_empno_fk references 
emp_details (empno) on delete cascade;

---4
delete from emp_details where empno=103;
commit;
select * from emp_details;
select * from emp_skill;
-------------------------------------------------------------------------------------------
---5a
select empno,first_name||' '||last_name as employee 
from emp_details join emp_skill using(empno) where lower(skill)=lower('syBASE');

---5b
select n.first_name,s.skill,l.lodge_manager from lodge_details l
join emp_details n using(lodge_name) join emp_skill s using (empno);

---5c
select skill from emp_skill where empno=101;

---5d
select d.first_name from emp_details d join emp_skill s 
using(empno) where s.skill='Oracle SQL';
-----------------------------------------------------------------------------------------------------
---connection made to HR(main) schema
conn HR;
---connected after giving password and seeking grant permission
grant create any view to scott;
---going back to scott schema after grant success
conn scott/tiger;
---6
create or replace view emp_view 
as select d.empno,d.first_name,s.skill,l.lodge_manager 
from emp_skill s join emp_details d on(s.empno=d.empno)
join lodge_details l using(lodge_name);

select * from emp_view;
commit;
-----------------------------------------------------------------------------------------------------
---connection made to HR (main) schema
conn HR;
---connected after giving password and seeking grant permission
grant create any synonym to scott;
---going back to scott schema after grant success
conn scott/tiger;
---7
create or replace synonym empv for scott.emp_view;

select * from empv;
-----------------------------------------------------------------------------------------------------
---8
create index ix_empSkill_skill on emp_skill(skill);
---syntax drop index--> drop index ix_empSkill_skill on emp_skill;