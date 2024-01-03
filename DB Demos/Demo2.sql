--------------------------- Joins -------------------------

-- 1. Cross join (Cartisian Product)
select S.St_Fname, D.Dept_Name
from Student S, Department D -- ANSI (Cartisian Product)

select S.St_Fname,  D.Dept_Name
from Student S Cross Join Department D -- Microsoft (Cross Join)



-- 2. Inner Join (Equi Join)

-- Equi Join Syntax (ANSI)
select S.St_Fname,  D.Dept_Name
from Student S, Department D
where D.Dept_Id = S.Dept_Id 

select S.St_Fname , D.*
from Student S, Department D
where D.Dept_Id = S.Dept_Id

-- Inner Join Syntax (Microsoft)
select S.St_Fname, D.Dept_Name
from Student S inner join Department D
	on D.Dept_Id= S.Dept_Id


-- 3. Outer Join
-- 3.1 Left Outer Join
select S.St_Fname, D.Dept_Name
from Student S left outer join Department D
	on D.Dept_Id= S.Dept_Id

-- 3.2 Right Outer Join
select S.St_Fname, D.Dept_Name
from Student S right outer join Department D
	on D.Dept_Id= S.Dept_Id

-- 3.3 Full Outer Join
select S.St_Fname, D.Dept_Name
from Student S full outer join Department D
	on D.Dept_Id = S.Dept_Id
------------------------------------------------------------------------------------
-- 4. Self Join
select S.St_Fname, Super.*
from Student S , Student Super
where Super.St_Id = S.St_Super

select S.St_Fname, Super.*
from Student S inner join Student Super
on Super.St_Id = S.St_Super

-- Multi Table Join
-- Equi Join Syntax
select S.St_Fname, Crs_Name, Grade
from Student S, Stud_Course SC, Course C
where S.St_Id = SC.St_Id and C.Crs_Id = SC.Crs_Id

-- Inner Join Syntax
select S.St_Fname, Crs_Name, Grade
from Student s inner join Stud_Course SC
on S.St_Id = SC.St_Id 
inner join Course C
on C.Crs_Id = SC.Crs_Id
----------------------------------
-- Join + DML
-- Update 

-- Updates Grades Of Student Who 're Living in Cairo
update SC
	set grade += 10
from Student S inner join Stud_Course SC
on  S.St_Id = SC.St_Id and St_Address = 'cairo'

-- Self Study
-- Delete
-- Insert
-----------------------------------------------------------------------
----------------------------------------------------------
--=======================================================--
--------------------- Built-in Functions --------------
--=======================================================--

------------------- 1. Aggregate Functions ---------------
--  Return Just Only One Value (Scalar Functions) 
--  That Value is Not Existed In Database
--	Count, Sum, Avg, Max, Min  

select count(*)
from student

select count(St_Id)
from student

--The Count of Students That have Ages (Not Null)
select count(st_age) 
from student

select count(*) , count(st_id), count(st_lname), count(st_age)
from Student

select sum(salary)
from instructor


select avg(st_age)
from Student

select sum(st_age)/COUNT(*)
from Student
select sum(st_age)/COUNT(st_age)
from Student


select Max(Salary) as MaxSalary, Min(Salary) as MinSalary
from Instructor

-------------------------------------------------------------------------------------------
---Grouping

-- Minimum Salary For Each Department
select Dept_Id, Min(Salary) as MininmumSalary
from Instructor
Group By Dept_Id


-- You Can't Group By With * or PK 
-- We Grouping With Repeated Value Column


Select Dept_Id, St_Address, Count(St_Id) as NumberOfStudents
From Student
Group By Dept_Id, St_Address  -- Will Group Here With Which Column?
-- If You Select Columns With Aggregate Functions, 
-- You Must Group By With The Same Columns 



-- Get Number Of Student For Each Department [that has more than 3 students]
select S.Dept_Id, D.Dept_Name, Count(St_Id) as NumberOfStudents
from Student S, Department D
where D.Dept_Id = S.Dept_Id
group by S.Dept_Id , D.Dept_Name
having Count(St_Id) > 3


-- Get Number Of Student For Each Department [Need Join?]
select Dept_id, Count(St_Id) as NumberOfStudents
from Student
group by Dept_Id
where dept_id is not null

select S.Dept_id, Count(S.St_Id) as NumberOfStudents
from Student S, Department D
where D.Dept_Id = S.Dept_Id
group by S.Dept_Id

-- Get Sum Salary of Instructors For Each  [Which has more than 3 Instructors]
select Dept_Id, Sum(Salary) as SumOfSalary
from Instructor
group by Dept_Id
having Count(Ins_Id) > 3


-- You Can't Use Agg Functions Inside Where Clause (Not Valid)
-- Because Aggreagate Generate Groups That 'Having' Works With it
-- Where Works With Rows => in order to Make Filteration
select Sum(Salary)
from Instructor
where count(Ins_Id) < 100 -- Not Valid

-- You Can Use Having Without Group By Only In Case Of Selecting Just Agg Functions
select Sum(Salary)
from Instructor
having count(Ins_Id) < 100 -- Valid

-- Group By With Self Join
select Super.St_FName, Count(Stud.St_Id)
from Student Stud, Student Super
where Super.St_Id = Stud.St_Super
group by Super.St_FName
------------------------------------------------------------------