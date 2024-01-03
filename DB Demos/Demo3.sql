 ------------------------------------------------------------
---------------------- 2. Null Functions -------------------
------- 1. IsNull
select st_Fname
from Student

select st_Fname
from Student
where St_Fname is not null

select isnull(st_Fname, '')
from Student

select isnull(st_Fname, 'Student Has No FName')
from Student

select isnull(st_Fname, St_Lname) as NewName
from Student

------- 2. Coalesce
select coalesce(st_Fname, St_Lname, St_Address, 'No Data')
from Student


---------------------------------------------------------
---------------------- 3. Casting Functions -------------

select St_Fname +' '+ St_Age
from student

------- 1. Convert [Convert From Any DateType To DateType]
select St_Fname +' '+ Convert(varchar(2), St_Age)
from student

select 'Student Name= ' + St_Fname + ' & Age= '+ Convert(varchar(2), St_Age)
from student

select IsNull(St_Fname,'')+' '+ Convert(varchar(2), IsNull(St_Age, 0))
from student

-- Concat => Convert All Values To String Even If Null Values (Empty String)
select Concat(St_Fname, ' ', St_Age)
from student


------- 2. Cast [Convert From Any DateType To DateType]
select cast(getdate() as varchar(50))

-- Convert Take Third Parameter If You Casting From Date To String
-- For Specifying The Date Format You Need
select convert(varchar(50),getdate(),101)
select convert(varchar(50),getdate(),102)
select convert(varchar(50),getdate(),110)
select convert(varchar(50),getdate(),111)

------- 3. Format [Convert From Date To String]

select format(getdate(),'dd-MM-yyyy')
select format(getdate(),'dddd MMMM yyyy')
select format(getdate(),'ddd MMM yy')
select format(getdate(),'dddd')
select format(getdate(),'MMMM')
select format(getdate(),'hh:mm:ss')
select format(getdate(),'hh tt')
select format(getdate(),'HH')
select format(getdate(),'dd MM yyyy hh:mm:ss')
select format(getdate(),'dd MM yyyy hh:mm:ss tt')
select format(getdate(),'dd')

---------------------------------------------------------
------------------- 4. DateTime Functions ---------------

select getdate()
select day(getdate())
select Month(GETDATE())
select eomonth(getdate())
select eomonth('1/1/2000')
select format(eomonth(getdate()),'dd')
select format(eomonth(getdate()),'dddd')

---------------------------------------------------------
------------------- 5. String Functions -----------------

select lower(st_fname),upper(st_lname)
from Student

select substring(st_fname,1,3)
from Student

select len(st_fname),st_fname
from Student

---------------------------------------------------------
--------------------- 6. Math Functions -----------------

select power(2,2)


-- log sin cos tan

---------------------------------------------------------
--------------------- 7. System Functions ---------------

select db_name()

select suser_name()

select @@ServerName


==============================================================
---------------------- Sub Query -----------------------------
-- Output Of Sub Query[Inner] As Input To Another Query[Outer]
-- SubQuery Is Very Slow (Not Recommended Except Some Cases)

/* 
select *
from student
where st_age > avg(st_age) => Not Valid
*/

select *
from student
where st_age > (select avg(st_age) from student) --23 just value

/*
select *, count(st_id)
from student => Not Valid
*/
select *,(select count(st_id) from student) --14
from student

-- SubQuery Vs Join

-- Get Departments Names That Have Students

select distinct D.Dept_Name
from Department D inner join Student S
on D.Dept_Id = S.Dept_Id

select dept_name
from Department
where Dept_Id in (	select distinct(Dept_Id)
					from Student
					where Dept_Id is not null
				)

-- SubQuery With DML
--------- SubQuery With Delete

--Delete Students Grades Who Are Living in Cairo
delete from Stud_Course
where St_Id in (
				Select St_Id from Student 
				where St_Address = 'Cairo'
				)
delete SC
from Student S inner join Stud_Course SC
on S.St_Id = SC.St_Id 
where S.St_Address = 'Cairo'

==========================================================
------------------------- Top ----------------------------

-- First 5 Students From Table
select top(5)*
from  student

select top(5)st_fname
from  student

-- Last 5 Students From Table
select top(5)*
from  student
order by st_id desc

-- Get The Maximum 2 Salaries From Instractors Table
select Max(Salary)
from Instructor

select Max(Salary)
from Instructor
where Salary <> (Select Max(Salary) from Instructor)

select top(2)salary
from Instructor
order by Salary desc


-- Top With Ties, Must Make Order by
select top(5) st_age
from student 
order by st_age desc

select top(5) with ties st_age
from student
order by st_age  desc


-- Randomly Select
select newid()   -- Return GUID Value (Global Universal ID)

select St_Fname, newid()
from Student

select top(3)*
from student
order by newid()
============================================================
------------------------------------------------------------
------------------- Ranking Function -----------------------



-- 1. Row_Number()
-- 2. Dense_Rank()
-- 3. Rank()

select Ins_Name, Salary,
	Row_Number() over (Order by Salary desc) as RNumber,
	Dense_Rank() over (Order by Salary desc) as DRank,
	Rank()       over (Order by Salary desc) as R
from Instructor


-- 1. Get The 2 Older Students at Students Table

-- Using Ranking 
select *
from (select St_Fname, St_Age, Dept_Id,
		Row_number() over(order by St_Age desc) as RN
	from Student) as newtable
where RN <= 2

-- Using Top(Recommended)
Select top(2) St_Fname, St_Age, Dept_Id
from Student
Order By St_Age Desc

-- 2. Get The 5th Younger Student 

-- Using Ranking (Recommended)
select * from 
(select St_Fname, St_Age, Dept_Id,
		row_number() over(order by St_age desc) as RN
from Student) as newtable
where RN = 5

-- Using Top
select top(1)* from
(select top(5)*
from Student
order by St_Age desc) as newTable
order by St_Age

-- 2. Get The Younger Student At Each Department

-- Using Ranking Only
select * from 
(select Dept_Id, St_Fname, St_Age, 
		row_number() over(partition by Dept_id order by St_age desc) as RN
from Student) as newtable
where RN = 1



-- 4.NTile

-- We Have 15 Instructors, and We Need to Get The 5th Instructors Who Take the lowest salary
select *
from
(
select Ins_Name, Salary, Ntile(3) over(order by Salary) as G
from Instructor
) as newTable
where G = 3


