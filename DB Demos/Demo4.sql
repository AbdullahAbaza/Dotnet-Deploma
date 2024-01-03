

=========================================================
---------------------------------------------------------
-- Execution Order
Select CONCAT(St_FName, ' ', St_Lname) as FullName
from Student
Where FullName = 'Ahmed Hassan' -- Not Valid


Select CONCAT(St_FName, ' ', St_Lname) as FullName
from Student
Where CONCAT(St_FName, ' ', St_Lname) = 'Ahmed Hassan'

Select *
from  (Select CONCAT(St_FName, ' ', St_Lname) as FullName
	   from Student) as Newtable
Where FullName = 'Ahmed Hassan'

Select CONCAT(St_FName, ' ', St_Lname) as FullName
from Student
Order By FullName


--execution order
----from
----join
----on
----where 
----group by
----having
----select
----order by
----top

=========================================================
---------------------------------------------------------
---------------------------- Schema ---------------------

-- Schema Solved 3 Problems:
-- 1.You Can't Create Object With The Same Name
--	[Table, View, Index, Trigger, Stored Procedure, Rule]
-- 2. There Is No Logical Meaning (Logical Name)
-- 3. Permissions
select *
from Student

-- DBO [Default Schema] => Database Owner
select *
from ServerName.DBName.SchemaName.objectName

select *
from  [DESKTOP-VF50P25].iti.dbo.student

select *
from Company_SD.dbo.Project

Create Schema HR

Create Schema Sales


Alter Schema HR 
Transfer student


select * from Student  -- not valid

select * from Hr.Student -- valid

Alter Schema HR
Transfer Department

Select *
from HR.Department


ALter Schema Dbo
Transfer HR.Department


======================================================
------------------------------------------------------
-- Union Family (union | union all | intersect | except)
-- Have 2 Conditions:
-- 1- The Same Datatype
-- 2- The Same Number Of Selected Columns

Select St_Id, St_FName from Student
-- except --intersect --union all --union
Select Ins_Id, Ins_Name from Instructor

-- Example (Select The Student Names At All Route Branches)

===============================================================
---------------------------------------------------------------
-- DDL [Create, Alter, Drop, Select Into]    
-- Create Physical Table


Select * into NewEmployees
From MyCompany.Dbo.Employee


-- Create Just The Structure Without Data
Select * into NewProjects
From MyCompany.Dbo.Project
Where 1 = 2



-- Take Just The Data Without Table Structure, 
-- but 2 tables must have same structure (Insert Based On Select)
Insert Into NewProjects
Select * from MyCompany.Dbo.Project


=========================================================
---------------------------------------------------------
---------------- User Defined Function ------------------

-- Any SQL Server Function must return value
-- Specify Type Of User Defined Function That U Want Based On The Type Of Return
-- User Defined Function Consist Of
--- 1. Signature (Name, Parameters, ReturnType)
--- 2. Body
-- Body Of Function Must be Select Statement Or Insert Based On Select
-- May Take Parameters Or Not

=================================================================
-- 1. Scalar Fun (Return One Value)


Create Function GetStudentNameByStudentId(@StId int)
returns varchar(20) -- Function Signature
begin
	declare @StudentName varchar(20)
	Select @StudentName = St_FName
	from Student
	where St_Id = @StId
	return @StudentName
end
     
Select	Dbo.GetStudentNameByStudentId(8)


-----------------------------------------------------

Create Function GetDepartmentManagerNameByDepartmentName(@DeptName varchar(20))
Returns varchar(20) -- Function Signature
begin
	declare @MangerName varchar(20)
	Select @MangerName = E.FName
	From Employee E, Departments D
	where E.SSN = D.MGRSSN and D.DName =  @DeptName
	return @MangerName
end

Select	Dbo.GetDepartmentManagerNameByDepartmentName('DP2')




=================================================================
-- 2. Inline Table Function (Return Table)

Create Function GetDepartmenInstructorsByDepartmentId(@DeptId int)
Returns Table  -- Function Signature
as
	Return
	(
		Select Ins_Id, Ins_Name, Dept_Id
		from Instructor
		Where Dept_Id = @DeptId
	)

	Select * from dbo.GetDepartmenInstructorsByDepartmentId(20)

=================================================================
-- 3. Multistatment Table Fuction
--    => Return Table With Logic [Declare, If, While] Inside Its Body

Alter Function GetStudentDataBasedPassedFormat(@Format varchar(20))
Returns @t table
		(
			StdId int,
			StdName varchar(20)
		)
With Encryption
as
	Begin
		if @format = 'first'
			Insert Into @t
			Select St_Id, St_FName
			from Student
		else if @format = 'last'
			Insert Into @t
			Select St_Id, St_LName
			from Student
		else if @format = 'full'
			Insert Into @t
			Select St_Id, Concat(St_FName, ' ', St_LName)
			from Student
		
		return 
	End

select * from dbo.GetStudentDataBasedPassedFormat	('FIRST')
-----------------------------------------------------------------------------------------
-------------------------------------------------------------
---------------------- Views --------------------------------

-- 1. Standard View (Contains Just Only One Select Statement)


Create View AlexStudentsView
as
	Select St_Id, St_FName, St_Address
	from StudentsView
	Where St_Address = 'Alex'

Select * from AlexStudentsView

Create View CairoStudentsView
as
	Select St_Id, St_FName, St_Address
	from Student
	Where St_Address = 'Cairo'

Select * from CairoStudentsView



---------------------------------------------------------------
-- 2. Partitioned View (Contains More Than One Select Statement)

Create View CairoAlexStudentsView
as
	Select * from CairoStudentsView
	Union
	Select * from AlexStudentsView

Select * from CairoAlexStudentsView

-- Hierarchy Of Database?
/*
 Server Level	=> Databases
 Database Level	=> Schemas
 Schema Level	=> Database Objects (Table, View, SP, and etc)
 Table Level	=> Columns, Constraints
*/

Alter Schema Dbo
Transfer HR.CairoAlexStudentsView


Create View StudentDepartmentDataView(StdId, StdName, DeptId, DeptName)
With Encryption
as
	Select St_Id, St_FName, D.Dept_Id, D.Dept_Name
	from Student S inner join Department D
	on D.Dept_Id = S.Dept_Id

Select * from StudentDepartmentDataView

SP_HelpText 'GetStudentDataBasedPassedFormat'



Create View StudentGradesView (StdName, CrsName, StdGrade)
With Encryption
as
	Select S.St_FName, C.Crs_Name, SC.Grade
	from Student S, Stud_Course SC, Course C
	where S.St_Id = SC.St_Id and C.Crs_Id = SC.Crs_Id

Select * from StudentGradesView



---------------------------------------------------------
-- View + DML
-- View =>  One Table

Create View CairoStudentsView
as
	Select St_Id, St_FName, St_Address
	from StudentsView
	Where St_Address = 'Cairo'

Insert Into CairoStudentsView
Values(323234, 'Pola', 'Cairo')


-- View  =>  Multi Table

Alter View StudentDepartmentDataView(StdId, StdName, FK_DeptId, DeptId, DeptName)
With Encryption
as
	Select St_Id, St_FName, S.Dept_Id, D.Dept_Id, D.Dept_Name
	from Student S inner join Department D
	on D.Dept_Id = S.Dept_Id

Select * from StudentDepartmentDataView
--- DELETE XXXXX
Delete From StudentDepartmentDataView
	Where StdId = 1

-- Insert Update
Insert Into StudentDepartmentDataView(StdId, StdName, FK_DeptId)
Values(9709, 'Ay 7aga', 1000)

Insert Into StudentDepartmentDataView(DeptId, DeptName)
Values(1000, 'Test')



Alter View CairoStudentsView
With Encryption
as
	Select St_Id, St_FName, St_Address
	from StudentsView
	Where St_Address = 'Cairo' -- Make Check Constraint
	With Check Option

Insert Into CairoStudentsView
Values(97397, 'Ronaldo', 'Cairo')




-- Only Use in a Database Created using SQLServer 2022 or a higher Version
Select * from dbo.GetValuesBetween(1, 10)

Create Function GetRangeBetweenTwoIntegers(@Start int, @End int)
Returns @t table( RangeValues int )
as 
	Begin
		If @Start = @End 
			insert into @t Select @Start
		Else if  @Start < @End 
			insert into @t Select Value from generate_series(@Start, @End, 1)
		Else if @End > @Start 
			insert into @t Select Value from generate_series(@End, @Start, 1)
		Return
	End


select * from dbo.GetRangeBetweenTwoIntegers(1, 10)




	Select Ins.Ins_Name, T.Top_Name
	From Instructor Ins Inner Join Department D on Ins.Ins_Id = D.Dept_Manager
	Inner Join Ins_Course Ins_C on Ins.Ins_Id = Ins_C.Ins_Id
	Inner Join Course C on C.Crs_Id = Ins_C.Crs_Id
	Inner Join Topic T on T.Top_Id = C.Top_Id