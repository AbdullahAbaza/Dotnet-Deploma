use Company_SD


-- this is called equi join (ANSI SQL)
Select E.Fname, D.Dname 
	from Employee E, Departments D 
	where D.Dnum = E.Dno ;  -- PK =FK for pefornmance  (not checking nulls or not matching values)


-- Transact SQL same thing inner join on

Select Fname, Dname 
	from dbo.Employee As E inner join Departments As D
	on D.Dnum = E.Dno;

-- this works because the columns in the tables are in different names 
-- if they are the same name we must give the tables aliases to get the correct result
select Fname, Dname from Employee , Departments where Dno = Dnum;


-- From ITI DB Display Student name , course name and grade 
-- joining 3 tables 

Use ITI

Select [St_Name] = St_Fname +' '+ St_Lname  , Crs_Name, Grade
from Student S, Stud_Course SC, Course C
where S.St_Id = SC.St_Id and  -- PK = FK
		C.Crs_Id = SC.Crs_Id 

-- Same thing using inner join

Select [St_Name] = St_Fname +' '+ St_Lname , Crs_Name, Grade, Dept_name

from Student S inner join Stud_Course SC 
	on S.St_Id = SC.St_Id  -- PK = FK "Parent = Child"
	-- the result of the first two table is a new table that we will join with the third table
	inner join Course C
	on C.Crs_Id = SC.Crs_Id
	inner join Department D -- joining with department to get department name
	on S.Dept_Id = D.Dept_Id



------------------------- Outer Join ---------------------------
-- Left Outer Join
-- find all emloyees if they are in a department or not
Use ITI
Select S.St_Fname , D.Dept_Name
from dbo.Student S left outer join dbo.Department D
on D.Dept_Id = S.Dept_Id -- when depid is null dept name is null

-- Right outer Join
--Find student names and department names even department
--has students or not

Select S.St_Fname, D.Dept_Name
from dbo.Student S right outer join dbo.Department D
on D.Dept_Id = S.Dept_Id

-- Full outer Join -- the # of rows = #rows of left Join + # Rows of right Join 
Select S.St_Fname, D.Dept_Name
from dbo.Student S full outer join dbo.Department D
on D.Dept_Id = S.Dept_Id



-- Join DML 
-- Join Update 
Update Stud_Course
	Set Grade += 10

Select St_Fname, Grade
from Student S, Stud_Course SC 
where S.St_Id = SC.St_Id and  S.St_Address = 'Cairo'


Update Stud_Course 
	Set Grade+= 10
Select St_Fname, St_Address, Grade
from Student S, Stud_Course SC 
where S.St_Id = SC.St_Id and S.St_Address = 'Alex' 

-----------------------------------------------------------
-- replace null with an new value
Select S.St_Fname , S.St_Lname
from Student S
where S.St_Lname is null 

Select St_Lname, isnull(St_Lname , '') As 'No Nulls' 
from Student

Select Coalesce(St_Fname, St_Lname, St_Address, 'Has no Data' )
from Student

Update Student
Set St_Fname = 'Ahmed%'
where St_Fname Like '%[['']]'

Select St_Fname
from Student

-- convert 
Select St_Fname + ' ' + CONVERT(varchar(2), St_Age) As St_name_Age
from Student

-- علشان نحل موضوع إن ال نل  لما بتدخل فى أي عمليه بترجع نل 
-- we will use issnull()

Select isnull(St_Fname, '') + ' ' + convert(varchar(2), isnull(St_Age, 0)) As St_name_Age
from Student

-- The simple, fast and efficiant way is to use concat
-- concat() replaces any NULL value with an empty string ''
Select Concat(St_Fname, ' ', St_Age)
from Student


-- Order By 
-- we order by with two two cols or more if the first col has repeated values 
Select St_Fname, Dept_Id, St_Age
from Student
Order By Dept_Id asc ,St_Age desc 






--
Select Super.St_Fname, count(S.St_id) [# Students SupperVised]
from Student S, Student Super
where Super.St_Id = S.St_super
Group By Super.St_Fname
Having Count(S.St_id) > 3
