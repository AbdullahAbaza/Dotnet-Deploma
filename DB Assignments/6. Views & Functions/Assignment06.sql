-- ============================================= Part 01 ====================================================
-- Restoring adventureworks2012 DB
Use AdventureWorks2012
GO

-- 1.	Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) 
-- to designate SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’

Select SalesOrderID, ShipDate
From Sales.SalesOrderHeader
where ShipDate between '2002-07-28' and '2014-07-29'


--2.	Display only Products(Production schema) with a StandardCost below $110.00 
-- (show ProductID, Name only)

Select ProductID, Name
from Production.Product
where StandardCost < 110.00

-- 3.	Display ProductID, Name if its weight is unknown

Select ProductID, Name
from Production.Product
where Weight is Null 

-- 4.	 Display all Products with a Silver, Black, or Red Color

Select Name [Product Name], Color
from Production.Product
where Color in('Silver', 'Black', 'Red')


-- 5.	 Display any Product with a Name starting with the letter B
Select Name [Product Name]
from Production.Product
where Name like 'B%'

-- 6. Run the following Query
--	Then write a query that displays any Product description with underscore value in its description.

UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

Select Description 
from Production.ProductDescription 
where Description like '%[_]%'

-- 8.	 Display the Employees HireDate (note no repeated values are allowed)

Select Distinct HireDate
from HumanResources.Employee


-- 9. Display the Product Name and its ListPrice within the values of 100 and 120 
--	  the list should have the following format "The [product name] is only! [List price]" 
--    (the list will be sorted according to its ListPrice value)

Select Concat('The ', Name, ' is only! ', ListPrice) As [Products with ListPrice bettween 100 and 200]
from Production.Product
where ListPrice between 100 and 200


-- =================================== Part 02 ===================================

Use ITI
GO

-- 1.	Create a scalar function that takes a date and returns the Month name of that date.

Create Or Alter Function Get_MonthName_BasedOn_Date(@Date date)
returns varchar(20)
With Encryption
Begin
	Declare @MonthName varchar(20)
	Select @MonthName = Format(@Date, 'MMMM')
	return @MonthName
End

-- SP_HelpText 'Get_MonthName_BasedOn_Date'

Select dbo.Get_MonthName_BasedOn_Date(getdate()) As MonthName

-- 2.	 Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
Create Function GetValuesBetween(@Start int, @End int)
Returns @t table ( RangeValues int)
as 
Begin
	Declare @Temp int = @Start

	if @Start = @End
		insert into @t Values(@Start)

	else if @Start < @End
		While @Temp+1 < @End
			Begin
				Set @Temp += 1
				insert into @t Values(@Temp)				
			End	

	else if @Start > @End
		While @Temp-1 > @End
			Begin 
				Set @Temp -= 1
				insert into @t Values(@temp)			
			End
	Return 
End


-- 3.	 Create a table-valued function that takes Student No and returns Department Name with Student full name.

Create Or Alter Function GetDeptNameAndStudentFullNameByStId(@St_id int)
Returns Table 
As 
return (
	Select D.Dept_Name , CONCAT(S.St_Fname , ' ', S.St_Lname) As St_FullName
	from Student S Inner Join Department D on D.Dept_Id = S.Dept_Id
	where S.St_Id = @St_id
)

Select * from GetDeptNameAndStudentFullNameByStId(10)



-- 4.	Create a scalar function that takes Student ID and returns a message to user 
--a.	If first name and Last name are null then display 'First name & last name are null'
--b.	If First name is null then display 'first name is null'
--c.	If Last name is null then display 'last name is null'
--d.	Else display 'First name & last name are not null'

Create Function GetMessageByID(@St_id int)
Returns varchar(Max)
Begin
	Declare @TempMessage varchar(max)
	Declare @FN varchar(25)
	Declare @LN varchar(25)
	
	Select @FN = S.St_Fname , @LN = S.St_Lname from Student S where S.St_Id = @St_id

	if @FN is null and @LN is null
		Set @TempMessage = 'First name & last name are null'
	else if @FN is null 
		Set @TempMessage = 'First name is null'
	else if @LN is null 
		Set @TempMessage = 'Last name is null'
	else 
		set @TempMessage = 'First name & last name are not null'
	
	Return @TempMessage
End

Select dbo.GetMessageByID(1) As Message


-- Another Good Solution 
CREATE Or Alter FUNCTION GetMessageByID(@St_id int)
RETURNS varchar(Max)
AS
BEGIN
    DECLARE @TempMessage varchar(max)

    SELECT @TempMessage = 
        CASE
            WHEN S.St_Fname IS NULL AND S.St_Lname IS NULL THEN 'First name & last name are null'
            WHEN S.St_Fname IS NULL THEN 'First name is null'
            WHEN S.St_Lname IS NULL THEN 'Last name is null'
            ELSE 'First name & last name are not null'
        END
    FROM Student S
    WHERE S.St_Id = @St_id

    RETURN @TempMessage
END


-- 5.	Create a function that takes an integer which represents the format of the Manager hiring date 
-- and displays department name, Manager Name and hiring date with this format. 


Create Function GetDeptInfoByManagerHiringDate(@Format int)
Returns Table 
As 
	Return 
	(
		Select D.Dept_Name, Ins.Ins_Name [Manager Name], Convert(Varchar(50), D.Manager_hiredate, @Format) 
		From Department D, Instructor Ins 
		Where D.Dept_Id = Ins.Dept_Id 


Select * from Department


-- 6.	Create multi-statement table-valued function that takes a string
--a.	If string='first name' returns student first name
--b.	If string='last name' returns student last name 
--c.	If string='full name' returns Full Name from student table  

Create Function GetStudentNameBasedOnFormat(@format varchar(25))
Returns @t table ( StudentName varchar(50))
As
	Begin 
		Insert Into @t
		Select  
			case 
				when @format = 'first name' then isnull(S.St_Fname, 'No first name')
				when @format = 'last name' then isnull(S.St_Lname, 'No last name')
				when @format = 'full name' then Concat(S.St_Fname, ' ', S.St_Lname)
			End
		from Student S
		Return
End

Select * From dbo.GetStudentNameBasedOnFormat('full name')


-- 7.	Create function that takes project number and display all employees in this project (Use MyCompany DB)

Use MyCompany
Go

Create Function GetEmployeesByProjectNumber(@ProjNum int )
Returns Table 
As Return
	(
		Select E.SSN , E.Fname, E.Lname , P.Pnumber
		From Project P , Works_for Ws, Employee E
		where P.Pnumber = Ws.Pno and E.SSN = Ws.ESSn and P.Pnumber = @ProjNum
	)

Select * from dbo.GetEmployeesByProjectNumber(700)

--============================== Part 03 ====================================

Use ITI

-- 1.	 Create a view that displays the student's full name, course name if the student has a grade more than 50. 

Create View v_StudentCourse([Student Name], [Course Name], Grade)
As 
	Select CONCAT(S.St_Fname, ' ', S.St_Lname), C.Crs_Name, Sc.Grade
	From Student S, Stud_Course Sc, Course C
	where S.St_Id = Sc.St_Id and C.Crs_Id = Sc.Crs_Id and Grade > 50

Select * from v_StudentCourse


-- 2.	 Create an Encrypted view that displays manager names and the topics they teach. 

Create or Alter View v_ManagersTopics([Manager Name], Topic)
with Encryption
As 
	Select Ins.Ins_Name, T.Top_Name
	From Department D, Instructor Ins, Ins_Course Ins_C, Course C, Topic T
	Where Ins.Ins_Id = D.Dept_Manager 
			and Ins.Ins_Id = Ins_C.Ins_Id 
			and C.Crs_Id = Ins_C.Crs_Id 
			and T.Top_Id = C.Top_Id

Select * from v_ManagersTopics


 -- 1.	Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department 
 --		“use Schema binding” and describe what is the meaning of Schema Binding
Create View v_InstructorDepartment_SD_Java([Instructor Name], [Department Name])
With SchemaBinding
As 
	Select Ins.Ins_Name, D.Dept_Desc
	from dbo.Instructor Ins, dbo.Department D 
	where D.Dept_Id = Ins.Dept_Id and D.Dept_Name in('SD', 'Java')

Select * from v_InstructorDepartment_SD_Java

/*
		When a view is schema-bound, it is bound to the schema of the underlying table or view, 
		which means that the schema cannot be modified without modifying the view.
		In other words, schema-bound views are created with the WITH SCHEMABINDING option. 
		This option binds the view to the schema of the underlying table or view, preventing any modifications to the schema 
		that would invalidate the view. It ensures that the view always returns the same data and schema, 
		which can improve query performance and prevent errors.
*/


-- 4.	 Create a view “V1” that displays student data for students who live in Alex or Cairo. 
/*			Note: Prevent the users to run the following query 
			Update V1 set st_address=’tanta’
			Where st_address=’alex’;
*/

Create View V1
As 
	Select *
	from Student
	where St_Address in ('Alex', 'Cairo')
	with Check Option


Update V1 set St_Address = 'tanta' where St_Address = 'alex'	-- xxxxx


-- 5.	Create a view that will display the project name and the number of employees working on it. (Use Company DB)
Use MyCompany

Create View v_ProjectsEmployees([Project Name], [# Employees Assigned])
As 
	Select P.Pname , COUNT(Ws.ESSn)
	from Project P, Works_for Ws, Employee E
	where P.Pnumber = Ws.Pno and E.SSN = Ws.ESSn
	Group By P.Pname


Select * from v_ProjectsEmployees


--===============================================================================================

Use [SD32-Company] 

-- 1.	Create a view named   “v_clerk” that will display employee Number ,project Number, the date of hiring of all the jobs of the type 'Clerk'.

Create or Alter View v_clerk([Employee Number], [Proj Number], [Hiring Date])
As 
	Select EmpNo, ProjectNo, Enter_Date
	From Works_on
	where Job = 'Clerk'
	with Check Option

Select * from v_clerk

-- 2.	 Create view named  “v_without_budget” that will display all the projects data without budget

Create or Alter View v_without_budget
As Select ProjectNo, ProjectName from HR.Project

Select * from v_without_budget


-- 3.	Create view named  “v_count “ that will display the project name and the Number of jobs in it

Create View v_count([Project Name], [Num of Jobs])
As
	Select P.ProjectName, Count(W.Job)
	from HR.Project P, dbo.Works_on W
	where P.ProjectNo = W.ProjectNo
	Group By P.ProjectName

Select * from v_count


-- 4.	 Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ . (use the previously created view  “v_clerk”)

Create Or Alter View v_project_p2
As 
	Select [Employee Number] from v_clerk where [Proj Number] = 2

Select * from v_project_p2


-- 5.	modify the view named  “v_without_budget”  to display all DATA in project p1 and p2.

Alter View v_without_budget 
As 
	Select * from HR.Project where ProjectNo in (1, 2)

Select * from v_without_budget


-- 6.	Delete the views  “v_ clerk” and “v_count”

Drop View v_clerk
Drop View v_count


-- 7.	Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’

Create View v_Emp#_Lname_d2
As
	Select E.EmpNo, EmpLname
	from HR.Employee E, Works_on W , Company.Department D 
	where  E.EmpNo = W.EmpNo and D.DeptNo = E.DeptNo and D.DeptNo = 2

Select * from v_Emp#_Lname_d2


-- 8.	Display the employee  lastname that contains letter “J” (Use the previous view created in Q#7)

Select * from v_Emp#_Lname_d2 
where EmpLname like 'J%' 
		or EmpLname like '%J%'
		or EmpLname like '%J'

-- 9.	Create view named “v_dept” that will display the department# and department name

Create Or Alter View v_dept 
As Select DeptNo, DeptName from Company.Department


Select * from v_dept
-- 10.	using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’

Insert Into v_dept values(4, 'Development')


-- 11.	Create view name “v_2006_check” that will display employee Number, the project Number where he works 
-- and the date of joining the project which must be from the first of January and the last of December 2006.
-- this view will be used to insert data so make sure that the coming new data must match the condition


Create or Alter View v_2006_check ([Employee Num], [Project Num], [Joining Date])
With Encryption
As 
	Select EmpNo, ProjectNo, Enter_Date
	From Works_on where Enter_Date between '2006-01-01' and '2006-12-31'
	With Check Option 


Insert Into v_2006_check values (1, 2, '2006-06-08')

Select * from v_2006_check