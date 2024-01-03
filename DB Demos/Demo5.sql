
--====================================================================
--------------------- Relationship Rules -----------------------------
--- 1. Delete Rule

--- Before Delete Department No (40) With Its Instructors and Students
Delete From Department
	Where Dept_Id = 40

-- Firstly, For Instructors
	-- 1. Transfer Instructors Of Department No (40) to another Department
Update Instructor	
	Set Dept_Id = 10
	Where Dept_Id = 40

	-- 2. Transfer Instructors Of Department No (40) To No Department (Null)
Update Instructor	
	Set Dept_Id = Null
	Where Dept_Id = 40

	-- 3. Transfer Instructors Of Department No (40) To No Department (Null)
Delete From Instructor
	Where Dept_Id = 40

-- Secondly, For Students also The Same Idea

-- 2. Update Rule [The Same Idea Of Delete Rule]

===================================================================
------------------------ Delete Vs Truncate -----------------------
Delete From Student

Truncate Table Student

===================================================================
-------------------------------------------------------------------
------------------------ Stored Procedure -------------------------
-- Benefits Of SP:
-- 1. Performance
-- 2. Security (Hide Meta Data)
-- 3. Network Wise 
-- 4. Hide Business Rules
-- 5. Handle Errors (SP Contain DML)
-- 6. Accept Input And Out Parameteres => Make It More Flexbile 


Create Procedure SP_GetStudentById @StdId int
as
	Select *
	from Student
	Where St_Id =  @StdId

	SP_GetStudentById 1

	declare @X  int = 1 
	exec HR.SP_GetStudentById @X



alter schema hr 
transfer SP_GetStudentById



Delete From Topic
	Where Top_Id = 1

Alter Proc SP_DeleteTopicById @TopicId int
With Encryption
as
	Begin Try
		Delete From Topic
			Where Top_Id = @TopicId
	End Try 
	Begin Catch
		Select 'Error'
	End Catch

DeleteStudent 6


Sp_HelpText 'SP_DeleteTopicById'


Alter Procedure SP_SumData @X int = 2, @Y varchar(10) = '8'
as
	Select @X + @Y

SP_SumData 3,7			-- Passing Parameters by Position
SP_SumData @y=7,@x=3    -- Passing Parameters by name
SP_SumData 6			-- Default Values
SP_SumData				-- Default Values
--------------------------------------------------------------------

---Dynamic Query
Create OR Alter Proc SP_GetData @TableName varchar(20), @ColumName varchar(20)
With Encryption
As
	--Select @ColumName from @TableName
	execute('Select ' +  @ColumName + ' From ' + @TableName)

SP_GetData 'Department', '*'


---------------------------------------



Create Proc SP_GetStudentByAddress @StdAddress varchar(20)
With Encryption
As
	Select St_Id, St_FName, St_Address
	From Student
	Where St_Address = @StdAddress

	SP_GetStudentByAddress 'Alex'


Create Table StudentsWithAddresss
(
StdId int Primary Key,
StdName varchar(20),
StdAddress varchar(20)
)

-- Insert Based On Execute
Insert Into StudentsWithAddresss
exec SP_GetStudentByAddress 'Alex'


---------------------------------------
-- Return Of SP

Create Proc SP_GetStudentNameAndAgeByIdV02 @Data int output, @Name varchar(20) output
With Encryption
As
	Select @Name = St_FName, @Data = St_Age -- [Output]
	from Student
	Where St_Id = @Data -- 10 [Input]

	declare @StudentName varchar(20), @Data int = 10
	exec SP_GetStudentNameAndAgeByIdV02 @Data output, @StudentName output
	Select @StudentName, @Data

