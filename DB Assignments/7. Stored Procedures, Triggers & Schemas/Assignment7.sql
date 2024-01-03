-- ======================================= Part 01 ================================================ 

-- 1.	Create a stored procedure to show the number of students per department.[use ITI DB] 
Use ITI

Create or Alter Procedure SP_Show#StudentPerDept
with Encryption
As
	Select Dept_Id, Count(*) [Num Of Students]
	From Student 
	Group By Dept_Id


SP_Show#StudentPerDept



-- 2.	Create a stored procedure that will check for the Number of employees in the project 100 if they are more than 3 
-- print message to the user “'The number of employees in the project 100 is 3 or more'” 
-- if they are less display a message to the user “'The following employees work for the project 100'” 
-- in addition to the first name and last name of each one. [MyCompany DB] 

Use MyCompany 

Create Proc SP_Check#EmployeeForProj100
With Encryption
As  
	Declare @EmpCount int 
	Select @EmpCount = Count(*) from Works_for where Pno = 100
	
	If @EmpCount >= 3 
		Print 'The following employees work for the project 100'
	Else  
		Begin 
			Print 'The following employees work for the project 100'
			Select E.Fname, E.Lname
			from Employee E, Works_for ws 
			where E.SSN = ws.ESSn and Pno = 100
		End

SP_Check#EmployeeForProj100



-- 3.	Create a stored procedure that will be used in case an old employee has left the project and a new one becomes his replacement. 
-- The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) 
-- and it will be used to update works_on table. [MyCompany DB]


Create Proc SP_UpdateEmployeeWorksOnProject @OldEmp int, @NewEmp int, @ProjectNo int
with Encryption
As 
	Update Works_for
	Set ESSn = @NewEmp 
	where ESSn = @OldEmp and Pno = @ProjectNo


Select * from Works_for 
Declare @NewEmp int = 968574
Execute SP_UpdateEmployeeWorksOnProject 112233, @newEmp, 100



-- 4.	Create an Audit table 
Use [SD32-Company]

Create Table AuditTable1 (
ProjectNo int,
UserName varchar(50),
ModifiedDate date,
Budget_Old  Money,
Budget_New Money
)


Create Trigger Proj_Trigger
On [HR].[Project] 
After Update
As 
	If Update(Budget)
		Begin 
			Declare @old money, @new money, @Pno int
			Select @old = Budget from deleted
			Select @new = Budget from inserted
			Select @Pno = ProjectNo from inserted
			
			Insert Into AuditTable values(@Pno, SUSER_NAME(), GETDATE(), @old, @new)
		End

--Drop Trigger [HR].[tri1]
--Drop Trigger HR.Proj_Trigger1

Update HR.Project 
	Set Budget = 2000
	where ProjectNo = 1


--=============================================== Part 02 ==============================================

--1.	Create a stored procedure that calculates the sum of a given range of numbers

CREATE PROCEDURE CalculateSum @StartNumber INT, @EndNumber INT, @SumResult INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SET @SumResult = 0;

    DECLARE @CurrentNumber INT = @StartNumber;

    WHILE @CurrentNumber <= @EndNumber
    BEGIN
        SET @SumResult = @SumResult + @CurrentNumber;
        SET @CurrentNumber = @CurrentNumber + 1;
    END
END 

DECLARE @Result INT;
EXEC CalculateSum @StartNumber = 1, @EndNumber = 10, @SumResult = @Result OUTPUT;
SELECT @Result AS SumResult;



-- 2.	Create a stored procedure that calculates the area of a circle given its radius

Create Procedure CalculateAreaOfaCircleGivenRaduis  @Radius float, @Area float output
As Begin
	Set @Area = Pi() * (@Radius * @Radius)
	End;

Declare @ResultArea float
Execute CalculateAreaOfaCircleGivenRaduis 3, @ResultArea output
Select @ResultArea As Area


-- 3.	Create a stored procedure that calculates the age category based on a person's age 
--( Note: IF Age < 18 then Category is Child and if  Age >= 18 AND Age < 60 
-- then Category is Adult otherwise  Category is Senior)


Create Procedure CalculateAgeCategory @Age tinyint 
As Begin 
	Select 
		Case
		when @Age < 18 then 'Child'
		when  @Age > 18 and @Age < 60 then 'Adult'
		when @Age > 60 then 'Senior'
		End
	End;

CalculateAgeCategory 45


-- 4.	Create a stored procedure that determines the maximum, minimum, and average of a given set of numbers 
-- ( Note : set of numbers as Numbers = '5, 10, 15, 20, 25')

Create Procedure CalcMaxMinAngOfGivenSet 
	@InputSetOfNum varchar(MAX), 
	@Max int output, 
	@Min int Output, 
	@Avg decimal(10, 2) output
As 
Begin
	Declare  @t table (val int)  
	
	insert into @t Select cast(value as  int)
	from string_split(@InputSetOfNum, ',')
	where Trim(Value) <> ''

	Select @Max = Max(val), @Min= Min(val), @Avg = Avg(val) from @t
End;

--Drop Procedure dbo.CalcMaxMinAngOfGivenSet;

Declare @input varchar(Max) = '5, 10, 15, 20, 25'
Declare @MaxValue int, @MinValue int, @AvgValue decimal(10, 2)

Exec CalcMaxMinAngOfGivenSet @InputSetOfNum = @input, 
							 @Max = @MaxValue output, 
							 @Min = @MinValue output, 
							 @Avg = @AvgValue output

Select @MaxValue As MaxValue, @MinValue As MinValue, @AvgValue As AvgValue



-- ====================================== Part 03 ==========================================

Create DataBase RouteCompany;
Go;
Use RouteCompany;
Go;

Create Table Department(
	DeptNo varchar(5) primary key,
	DeptName varchar(25),
	Location varchar(5)
)

Create Table Employee(
	EmpNo int primary key,
	EmpFname varchar(25) not null,
	EmpLname varchar(25) not null,
	DeptNo varchar(5) references Department(DeptNo),
	Salary money unique
)

Create Table Project(
	ProjectNo varchar(5) primary key,
	ProjectName varchar(25) not null,
	Budget money
)


Create Table Works_on (
	EmpNo int references Employee(EmpNo) not null,
	ProjectNo varchar(5) references Project(ProjectNo) not null,
	Job varchar(25),
	Enter_Date Date not null default(getdate()),
	primary key(EmpNo, ProjectNo)
)

insert into Department
values
('d1', 'Research', 'NY'),
('d2', 'Accounting', 'DS'),
('d3', 'Marketing', 'KW')


INSERT INTO Employee (EmpNo, EmpFname, EmpLname, DeptNo, Salary)
VALUES
    (25348, 'Mathew', 'Smith', 'd3', 2500),
    (10102, 'Ann', 'Jones', 'd3', 3000),
    (18316, 'John', 'Barrymore', 'd1', 2400),
    (29346, 'James', 'James', 'd2', 2800),
    (9031, 'Lisa', 'Bertoni', 'd2', 4000),
    (2581, 'Elisa', 'Hansel', 'd2', 3600),
    (28559, 'Sybl', 'Moser', 'd1', 2900);


INSERT INTO Project (ProjectNo, ProjectName, Budget)
VALUES
    ('p1', 'Apollo', 120000),
    ('p2', 'Gemini', 95000),
    ('p3', 'Mercury', 185600);

INSERT INTO Works_on (EmpNo, ProjectNo, Job, Enter_Date)
VALUES
    (10102, 'p1', 'Analyst', '2006-10-01'),
    (10102, 'p3', 'Manager', '2012-01-01'),
    (25348, 'p2', 'Clerk', '2007-02-15'),
    (18316, 'p2', NULL, '2007-06-01'),
    (29346, 'p2', NULL, '2006-12-15'),
    (2581, 'p3', 'Analyst', '2007-10-15'),
    (9031, 'p1', 'Manager', '2007-04-15'),
    (28559, 'p1', NULL, '2007-08-01'),
    (28559, 'p2', 'Clerk', '2012-02-01'),
    (9031, 'p3', 'Clerk', '2006-11-15'),
    (29346, 'p1', 'Clerk', '2007-01-04');


-- Testing Referential Integrity
	-- 1-Add new employee with EmpNo =11111 In the works_on table [what will happen]
		Insert Into Works_on(EmpNo, ProjectNo) values(11111, 'p1')
	
	/* Error: The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Works_on__EmpNo__44FF419A". 
	The conflict occurred in database "RouteCompany", table "dbo.Employee", column 'EmpNo'. */

	-- 2.Change the employee number 10102  to 11111  in the works on table [what will happen]
		Update Works_on
		Set EmpNo = 11111    -- Error EmpNo 11111 is not int the employee table (pk)
		where EmpNo = 10102
		/*The UPDATE statement conflicted with the REFERENCE constraint "FK__Works_on__EmpNo__44FF419A" */


	-- 3. -Modify the employee number 10102 in the employee table to 22222. [what will happen]
		
		Update Employee 
		set EmpNo = 22222  -- the EmpNo 10102 works_on a project so we can't change it unless we update it in the works_on table first
		where EmpNo = 10102

		/* Error: The UPDATE statement conflicted with the REFERENCE constraint "FK__Works_on__EmpNo__44FF419A" */

		Delete from Employee where EmpNo = 10102

		-- Same Error we cant delete the employee unless we change it's status in the works_on table


-- Table Modification
	-- 1-Add  TelephoneNumber column to the employee table[programmatically]
		Alter Table Employee
			Add  TelephoneNumber varchar(25)
	
	-- 2-drop this column[programmatically]
		Alter Table Employee
			Drop column TelephoneNumber




-- 2.	Create the following schema and transfer the following tables to it 
		--a.	Company Schema 
			--i.	Department table 
			--ii.	Project table 
		--b.	Human Resource Schema
			--i.	  Employee table 

Create schema [Company]

Alter Schema [Company]
	Transfer  dbo.Department
Alter Schema [Company]
	Transfer dbo.Project


Create Schema [Human Resources]

Alter Schema [Human Resources]
	transfer dbo.Employee


-- 3.	Increase the budget of the project where the manager number is 10102 by 10%.

-- 4.	Change the name of the department for which the employee named James works.The new department name is Sales.

Update [Company].Department
Set DeptName = 'Sales'
Where DeptNo in ( Select E.DeptNo 
				  from [Human Resources].Employee E, [Company].Department D 
				  where D.DeptNo = E.DeptNo and E.EmpFname = 'James')



-- 5.	Change the enter date for the projects for those employees who work in project p1 
-- and belong to department ‘Sales’. The new date is 12.12.2007.

Declare @t table(EmpNo int, EmpFName varchar(25), DeptName varchar(25), ProjectNo varchar(5), Enter_Date Date) 
insert into @t
	Select E.EmpNo, E.EmpFname, D.DeptName, ws.ProjectNo, ws.Enter_Date
	from [Human Resources].Employee E, [Company].Department D, [dbo].Works_on ws, [Company].Project P
	where P.ProjectNo = ws.ProjectNo and E.EmpNo = ws.EmpNo and D.DeptNo = E.DeptNo 
		and ws.ProjectNo = 'p1' and D.DeptName = 'Sales'

Update dbo.Works_on
Set Enter_Date = '2007-12-12'
where
	EmpNo in (Select EmpNo from @t) and
	ProjectNo in (Select ProjectNo from @t) 


-- Alternative solution 
UPDATE w
SET w.Enter_Date = '2007-12-12'
FROM dbo.Works_on w
INNER JOIN [Human Resources].Employee e ON w.EmpNo = e.EmpNo
INNER JOIN [Company].Department d ON e.DeptNo = d.DeptNo
INNER JOIN [Company].Project p ON w.ProjectNo = p.ProjectNo
WHERE w.ProjectNo = 'p1' AND d.DeptName = 'Sales';


-- 6.	Delete the information in the works_on table for all employees who work for the department located in KW.
Begin Transaction t1

Delete from Works_on 
where EmpNo in ( Select w.EmpNo
				 from [Company].Department D 
				 INNER JOIN [Human Resources].Employee E on D.DeptNo = E.DeptNo
				 Inner Join Works_on w on E.EmpNo = w.EmpNo
				 where D.Location = 'KW'
				)

Rollback transaction t1



