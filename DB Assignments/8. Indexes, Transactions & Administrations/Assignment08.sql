--========================================== Part 01 =========================================

Use ITI;
Go


-- •	Create a trigger to prevent anyone from inserting a new record in the Department table 
-- ( Display a message for user to tell him that he can’t insert a new record in that table )


Create Trigger Tr01 
on dbo.Department
Instead Of Insert 
As 
	Select 'You Cannot Insert a New Record in This Table.' As [Warning]

Insert Into Department(Dept_Name, Dept_Location) Values('TestDept', 'Space')


-- •	Create a table named “StudentAudit”. Its Columns are (Server User Name , Date, Note) 

Create Table StudentAudit (
	[Server User Name] varchar(Max),
	[Date] Datetime,
	Note varchar(200),
)


Create or Alter Trigger Tr_StudentAudit
On Student 
After Insert
As 
	Declare @S_ID int
	Select @S_ID = St_Id from inserted
	Insert Into dbo.StudentAudit
	Select SUSER_NAME(), getdate(), 
	concat(SUSER_NAME(), ' inserted a new row with key = ', @S_ID, ' in Table Student')


Insert Into Student(St_Id, St_Fname, St_Lname, St_Age, St_Address) 
	Values(20, 'Abdullah', 'Abaza', 21, 'Cairo')

Select * from StudentAudit


-- Create a trigger on student table instead of delete to add Row in StudentAudit table 
--	○	The Name of User Has Inserted the New Student
--	○	Date
--	○	Note that will be like “try to delete Row with id = [Student Id]” 

Create Trigger TR_Delete 
On dbo.Student
Instead Of Delete
As
	Declare @del_sid int
	Select @del_sid = St_id from deleted
	Insert Into dbo.StudentAudit
	Select SUSER_NAME(), getdate(), concat('tried to delete Row with id = ', @del_sid)

Delete from Student where St_Id = 20
Select * from StudentAudit

--================================== Part 02 =========================================

Use MyCompany;
Go

-- •	Create a trigger that prevents the insertion Process for Employee table in March.

Create Trigger Tr01_insert 
On Employee
After Insert
As
	If format(getdate(), 'MMMM') = 'March'
		Begin
		Delete from Employee
		where SSN in (Select SSN from inserted)
		End

Alter Table Employee 
Enable Trigger Tr01_insert

Insert Into Employee(SSN ,Fname) Values(222, 'Phoenix')
Select * from Employee



-- •	Create an Audit table with the following structure 

--ProjectNo	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
--p2	Dbo	2008-01-31	95000	200000

--This table will be used to audit the update trials on the Budget column (Project table, Company DB)


Use [SD32-Company];
Go

Create Table AuditTable2(
	ProjectNo varchar(10),
	UserName varchar(50),
	ModifiedDate datetime,
	Budget_Old money,
	Budget_New money
)

Create Trigger TR02_Audit
On HR.Project
After Update
As 
	 
	If Update(Budget)
		Begin
		Declare @ProjNo varchar(10), @OldBudget money, @NewBudget money
		
		Select @ProjNo = ProjectNo from inserted
		Select @OldBudget = Budget from deleted
		Select @NewBudget = Budget from inserted

		insert into dbo.AuditTable2
		Values(@ProjNo, SUSER_NAME(), getdate(), @OldBudget, @NewBudget)

		End

Insert Into HR.Project values('p10', 'FID', '10000')
Select * From AuditTable2 -- No change in AuditTable

Update HR.Project
Set ProjectName = 'iot01' where ProjectNo = 'p10'  
Select * From AuditTable2  -- Nochange in Audit Table Because the Update is not on the Budget Col

Update HR.Project
Set Budget = 20000 where ProjectNo = 'p10'
Select * from AuditTable2 -- Change added to the AuditTable


--================================== Part 03 ======================================

Use ITI;
Go

-- •	Create an index on column (Hiredate) that allows you to cluster the data in table Department. What will happen?

Create Clustered Index i01 
On Department(Manager_hiredate)
-- 'Error'
-- 'Cannot create more than one clustered index on table 'Department'. 
-- Drop the existing clustered index 'PK_Department' before creating another.'

Create Unique NonClustered Index i01 
On Department(Manager_hiredate)

-- ERROR 'Duplicate Values Found'
/* The CREATE UNIQUE INDEX statement terminated because a duplicate key was found for the object name 'dbo.Department' 
and the index name 'i01'. The duplicate key value is (<NULL>). */


-- •	Create an index that allows you to enter unique ages in the student table. What will happen?
Create Unique Index I_Age
On Student(St_Age)

-- ERROR 'Duplicate Values Found'
/*The CREATE UNIQUE INDEX statement terminated because a duplicate key was found for the object name 'dbo.Student' 
and the index name 'I_Age'. The duplicate key value is (<NULL>).*/


-- •	Try to Create Login Named(RouteStudent) who can access Only student and Course tables from ITI DB 
-- then allow him to select and insert data into tables and deny Delete and update

Create Login RouteStudent
With Password = 'RSpass2023@' , Check_Policy = OFF, Check_Expiration = OFF;
-- the login can view the databases but cannot access any database

-- create a user for the login in the ITI DB
Use ITI;
GO

Create User routestudent
For Login RouteStudent; 
-- now the user for this login in the iti DB can access the DB but cannot access any tables and other database objects

-- now we need to grant the user some permissions

Grant Select, Insert
On Student
To routestudent

Grant Select, Insert
On Course
To routestudent

Deny Update, Delete
On Student To routestudent

Deny Update, Delete 
On Course To routestudent






-- To view all the logins of an SQL Server instance, you use the following query:
SELECT
  sp.name AS login,
  sp.type_desc AS login_type,
  CASE
    WHEN sp.is_disabled = 1 THEN 'Disabled'
    ELSE 'Enabled'
  END AS status,
  sl.password_hash,
  sp.create_date,
  sp.modify_date
FROM sys.server_principals sp
LEFT JOIN sys.sql_logins sl
  ON sp.principal_id = sl.principal_id
WHERE sp.type NOT IN ('G', 'R')
ORDER BY create_date DESC;