====================================================================
--------------------------------------------------------------------
-- Types of SP
---- 1. User defined
			Sp_GetStudentNameById   SP_Getdata   SP_Sumdata
---- 2. Built-In SP
			Sp_helptext     Sp_Rename 
---- 3. Trigger (Special Stored Procedure)
----------- Can't Call
----------- Can't take parameters

--- Types of Triggers (Through Its Level)
---------- Server Level
---------- DB Level
---------- Table Level (Our Interest)
----------------- Actions In Table?(Insert   Update   Delete) [Events]
---------------------------------(Select Truncate) Not Logged In Log File

Create Trigger Tri01
on Student
after insert
as
	Select 'Welcome To Route'


	Insert Into Student(St_Id, St_FName)
	Values(23723, 'Amr')

	Alter Schema HR
	Transfer Student 

Alter Trigger HR.Tri02
on HR.Student
after Update
as
	Select GetDate(), SUser_Name()


	Update HR.Student
		Set St_Address = 'Cairo'
		Where St_Id = 23723


Drop Trigger HR.Tri03

Create Trigger Tri03
On HR.Student
Instead of Delete
as
	Select 'U Can Not Delete From This Table'


	Delete From HR.Student
		Where St_Id = 23723


Alter Trigger Tri04
on Department
instead of Delete, Insert, Update
as
	Select 'You Can Not Do Any Operation On This Table  ' + SUser_Name()

	Insert into Department(Dept_Id, Dept_Name)
	Values(8232, 'Test')



-- Drop | Disable | Enable Trigger
Drop Trigger Tri04

Alter Table Department
Enable Trigger Tri04



----------------------------------------------------
-- When You Write Trigger, You Must Write Its Schema (Except Default [dbo])
-- Trigger Take By Default The Schema Of Its Table In Creation
-- When You Change The Schema Of Table, All Its Triggers Will Follow


Alter trigger HR.tri1
on student
after insert
as
	Select 'Welcome To ITI'

--------------------------------------------
--------------------------------------------
-- The Most Important Point Of Trigger 
-- 2 Tables: Inserted & Deleted Will Be Created With Each Fire Of Trigger
-- In Case Of Delete:  Deleted Table Will Contain Deleted Values
-- In Case Of Insert:  Inserted Table Will Contain Inserted Values
-- In Case Of Update:  Deleted Table Will Contain Old Values
--						Inserted Table Will Contain New Values		


-- Error (Have No Meaning Without Trigger): Just Created at RunTime 
Select * from inserted
select * from deleted

-- With Trigger
create trigger tri6
on course
after update
as
	Select * from inserted
	select * from deleted


update course
	set Crs_Name='Cloud'
	where crs_id=200


Create Trigger Tri06
on Course 
Instead OF Delete
as
	Select 'U Can Not Delete From This Table : ' + (Select Crs_Name from deleted)

Delete From Course	
	Where Crs_Id = 900


Alter Trigger HR.Tri07
on HR.Student
Instead OF Delete
as
	if Format( GETDATE(), 'dddd') != 'Wednesday'
		Delete From HR.Student
			Where St_Id in (Select St_Id from deleted)

			
Delete from HR.Student
	Where St_Id = 3242

================================================================
----------------------------------------------------------------
----------------------------- Index -------- -------------------
create clustered index myindex
on student(st_fname) -- Not Valid [Table already has a clustered index on PK]


create nonclustered index myindex
on student(st_fname)

create nonclustered index myindex2
on student(dept_id)

-- Primary Key   ---Constraint   ---> Clustered Index

-- Unique Key    ---Constraint   ---> Nonclustered Index
create table test
(
 X int primary key,
 Y int unique,
 Z int unique
)

create unique index i3
on student(st_age)
-- Will Make 2 Things If There is No Repeated Values
-- 1. Make Unique Constraint On St_Age 
-- 2. Make Non-Clustered Index On St_Age




-- Clustered Index Vs Nonclustered Index
-- Just One							... Many Up To 999
-- Last Level Is The Actual Data	... PreLast Level Is Pointer To Actual Data
-- Faster							...	Slower
-- PK => Clustered					... Unique => Nonclustered


-- How Can I Select The Columns To Make Indexes On It?
-- 1. Analysis
-- 2. Testing (Using SQL Server Profiler and Tuning Advisor)

Alter Schema dbo
Transfer HR.Instructor 






Create View IndexedView
With SchemaBinding
As
	Select S.St_Id, S.St_FName, D.Dept_Id, D.Dept_Name
	from dbo.Student S, dbo.Department D
	Where D.Dept_Id = S.Dept_Id

Create unique clustered Index ii
On IndexedView(St_Id)
===================================================================
------------------------ Delete Vs Truncate -----------------------
Delete From Student

Truncate Table Student

=================================================================
-----------------------------------------------------------------
--------------------------- Transaction -------------------------
-- 1. Implicit Transaction (DML Query [Insert, Update, Delete])

Insert Into Student(St_Id, St_Fname)
Values (100, 'Ahmed'), (101, 'Amr')

Update Student
	set St_Age = 30 
	where St_Age = 20


-- 2. Explicit Transaction (Set Of Implicit Transactions)
create table Parent
(
ParentId int primary key
)
create table Child
(
ChildId int primary key,
ParentId_FK int references Parent(ParentId)
)
insert into Parent values(1)
insert into Parent values(2)
insert into Parent values(3)



begin transaction
insert into Child values(1, 1)
insert into Child values(2, 10)
insert into Child values(3, 2)
commit tran

begin transaction
insert into Child values(4, 1)
insert into Child values(5, 10)
insert into Child values(6, 2)
rollback tran


begin try
	begin transaction
		insert into Child values(7, 1)
		save transaction p01
		insert into Child values(8, 2)
		insert into Child values(9, 10)
		insert into Child values(10, 3)
	commit tran
end try
begin catch
	rollback tran p01
end catch
=================================================================
-----------------------------------------------------------------
--------------------------- DCL ---------------------------------
-- [Login]          Server (Omar)
-- [User]           DB ITI (Omar)
-- [Schema]         HR   [Department, Instructor]
-- Permissions      Grant [select,insert]    Deny [delete Update]

Create Schema HR

alter schema HR
transfer [dbo].[Instructor]

alter schema HR
transfer Department
=================================================================
-----------------------------------------------------------------
--------------------------- Backups -----------------------------

---- Backup Types
------- 1. Full 
------- 2. Differential
------- 3. Transaction Log

Backup Database ITI
to Disk = 'D:\Route\Cycle 39\01 Database\Session 07\Demos\iti.bak'