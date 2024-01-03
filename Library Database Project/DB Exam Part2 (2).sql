Use Library;
Go
-- 1. Write a query that displays Full name of an employee who has more than 3 letters in his/her First Name.

Select Concat(Fname,' ', Lname) As [Employee Name]
from Employee
where Fname like '____%'

-- where len(Fname) > 3

-- 2. Write a query to display the total number of Programming books available in the library with alias name ‘NO OF PROGRAMMING BOOKS’

Select Count(*) As [NO OF PROGRAMMING BOOKS]
From Book B Inner Join Category C on C.Id = B.Cat_id
where Cat_name = 'programming'


-- 3. Write a query to display the number of books published by (HarperCollins) with the alias name 'NO_OF_BOOKS'.

Select Count(*) As [NO_OF_BOOKS]
From Book B Inner Join Publisher P on P.Id = B.Publisher_id
where P.Name = 'HarperCollins'


-- 4. Write a query to display the User SSN and name, date of borrowing and due date of the User whose due date is before July 2022. 

Select SSN , User_Name, Borrow_date, Due_date
From Users U Inner Join Borrowing B on U.SSN = B.User_ssn
where Due_date < '2022-07-01'


-- 5. Write a query to display book title, author name and display in the following format, ' [Book Title] is written by [Author Name]. 

Select Concat(B.Title, ' is written by ', A.Name) As [Book Title and Auther Name]
From Book B, Book_Author BA, Author A
where B.Id = BA.Book_id and A.Id = BA.Author_id


-- 6. Write a query to display the name of users who have letter 'A' in their names. 

Select User_name 
From Users where User_Name like '%A%'

-- 7. Write a query that display user SSN who makes the most borrowing

Select Top(1) User_ssn
From Borrowing
Group By User_ssn
Order By Count(*) Desc


-- Another solution (Slower)
Select Top(1) User_ssn 
from (
	Select User_ssn, Count(User_ssn) [count]
	From Borrowing
	Group By User_ssn
	) T
order By T.[count]  Desc

-- 8. Write a query that displays the total amount of money that each user paid for borrowing books.

Select User_ssn, USER_NAME, Sum(Amount) As [Total Amount Paied]
From Borrowing B Inner Join Users U on U.SSN = B.User_ssn
Group By User_ssn, USER_NAME


-- 9. write a query that displays the category which has the book that has the minimum amount of money for borrowing.

Select Top(1) Cat_name As [Category Name], B.Id As [Book Id], Title As [Book Title], Sum(Amount) As [Total Amount Paid]
From Borrowing Br, Book B, Category C
where B.Id = Br.Book_id and C.Id = b.Cat_id
Group By Book_id, Cat_name, Title, B.Id, Title
Order By Sum(Amount) ASC 


-- 10.	write a query that displays the email of an employee 
		-- if it's not found, 	display address 
		-- if it's not found, display date of birthday.

Select Coalesce(Email, Address, isnull(Cast(DOB As Varchar), 'No Data')) [Employee Info]
From Employee 


-- 11. Write a query to list the category and number of books in each category with the alias name 'Count Of Books'.

Select Cat_name, Count(B.Id) As [Count Of Books]
From Book B Inner Join Category C on C.Id = B.Cat_id
Group By Cat_name


-- 12. Write a query that display books id which is not found in floor num = 1 and shelf-code = A1.

Select B.Id [Book ID ]
From Floor F Inner Join Shelf sh on F.Number = sh.Floor_num 
			 Inner Join  Book B on sh.Code = B.Shelf_code
where Floor_num <> 1 and Shelf_code <> 'A1' 
-- We don't need to check for shelf code because if the book is not in floor 1 it is not in shelf 'A1' 


-- 13. Write a query that displays the floor number , Number of Blocks and number of employees working on that floor.

 Select Floor_no, Num_blocks, Count(Id) As [Num Of Employees]
 From Employee E Inner Join Floor F on F.Number = E.Floor_no
 Group By Floor_no, Num_blocks

 -- 14.Display Book Title and User Name to designate Borrowing that occurred within the period ‘3/1/2022’ and ‘10/1/2022’.

 Select B.Title, U.User_Name
 From Book B, Borrowing Br, Users U
 where B.Id = Br.Book_id and U.SSN = Br.User_ssn 
 and Borrow_date between '2022-03-01' and '2022-10-01' -- Assuming the format for the given date is "Month/Day/Year" 


-- 15.Display Employee Full Name and Name Of his/her Supervisor as Supervisor Name.

Select Concat(E.Fname, E.Lname) As [Employee Name], Concat(Supp.Fname, Supp.Lname) As [Suppervisor Name]
From Employee E Inner Join Employee Supp 
On Supp.Id = E.Super_id 


-- 16.Select Employee name and his/her salary but if there is no salary display Employee bonus. 

Select CONCAT(Fname, Lname) As [Employee Name], Coalesce(Salary, Bouns) As Salary
From Employee E


-- 17.Display max and min salary for Employees 

Select Max(Salary) [Max Salary], Min(Salary) [Min Salary]
From Employee


-- 18.Write a function that take Number and display if it is even or odd

Create Or Alter Function Check_Even_Odd(@InputNum int)
Returns Varchar(10)
As
Begin
	Declare @Status Varchar(10)
	If @InputNum % 2 = 0
		Set @Status = 'Even'
	Else
		Set @Status = 'Odd'
	Return @Status
End


Select dbo.Check_Even_Odd(484) AS [Is_Even_Or_Odd]


-- 19.write a function that take category name and display Title of books in that category.

Create Function GetTitlesByCategoryName( @CategoryName Varchar(50) )
Returns Table 
With Encryption
As 
	Return(
		Select Title As [Book Title]
		From Book B Inner Join Category C on C.Id = B.Cat_id
		where C.Cat_name = @CategoryName
	)

Select * From GetTitlesByCategoryName('programming')


-- 20. write a function that takes the phone of the user and displays Book Title , user-name, amount of money and due-date.


Create Function GetBorrowDateByUserPhoneNumber(@PhoneNumber varchar(11))
Returns Table 
With Encryption
As 
	Return(
		Select B.Title As [Book Title], U.User_Name As [User Name], Br.Amount As [Amount Paid], Br.Due_date As [Due Date]
		From Users U, Borrowing Br, User_phones ph, Book B
		where U.SSN = Br.User_ssn  and U.SSN = ph.User_ssn and B.Id = Br.Book_id
		and ph.Phone_num = @PhoneNumber	
	)


Declare @Ph_Num Varchar(11) = '0120321455'
Select * From GetBorrowDateByUserPhoneNumber( @Ph_Num )


-- 21.Write a function that take user name and check if it's duplicated
	-- return Message in the following format ([User Name] is Repeated [Count] times) 
	-- if it's not duplicated display msg with this format [user name] is not duplicated,
	-- if it's not Found Return [User Name] is Not Found


Create Function ChechDuplicateUserNamesByName( @Name varchar(20))
Returns Varchar(100)
As
Begin 
	Declare @Message Varchar(100)
	Declare @Count int

	Select @Count = Count(User_Name) 
	From Users
	where User_Name = @Name
	Group By User_Name

	If @Count > 1 
		Set @Message = Concat(@Name, ' is Repeated ', @Count, ' times')
	Else If @Count = 1
		Set @Message = @Name + ' is not duplicated'
	Else 
		Set @Message = @Name + ' is Not Found'
	
	Return @Message
End


Declare @Uname varchar(20) = 'Amr Ahmed'
Select dbo.ChechDuplicateUserNamesByName(@Uname) As Message


-- 22.Create a scalar function that takes date and Format to return Date With That Format.

Create Or Alter Function FormatDate(@Date datetime, @Format Varchar(50))
Returns Varchar(50)
As 
Begin
	Declare @FormattedDate Varchar(50) = Format(@Date, @Format)
	Return @FormattedDate
End


Select dbo.FormatDate('1998-06-09', 'dddd MMMM yyyy') AS FormattedDate;

-- 23.Create a stored procedure to show the number of books per Category

Create Or Alter Procedure SP_BooksPerCategory 
With Encryption 
As 
Begin
	Select Cat_name, Count(B.Id) As [Number of Books]
	From Book B Inner Join Category C on C.Id = B.Cat_id
	Group By Cat_name
End

SP_BooksPerCategory


-- 24.Create a stored procedure that will be used in case there is an old manager
	--who has left the floor and a new one becomes his replacement. The
	--procedure should take 3 parameters (old Emp.id, new Emp.id and the
	--floor number) and it will be used to update the floor table. 

Create Or Alter Procedure SP_HandleOldManager @old_EmpId int, @new_EmpId int, @floor_number int
With Encryption
As
Begin
	If @new_EmpId in (Select Id from Employee)
		Begin
		Update Floor
		Set MG_ID = @new_EmpId
		where Number = @floor_number and MG_ID = @old_EmpId
		Select 'Successfuly regestered the new manager'
		End
	Else 
		Select 'The new manager must be an Employee first' 
End


Select * from Floor
Exec SP_HandleOldManager 6, 3, 5 


-- 25.Create a view AlexAndCairoEmp that displays Employee data for users who live in Alex or Cairo.

Create View AlexAndCairoEmp
With Encryption
As 
	Select *
	From Employee where Address in('Alex', 'Cairo')
With Check option

Select * from AlexAndCairoEmp


-- 26.create a view "V2" That displays number of books per shelf

Create Or Alter View V2([Shelf Code], [Number Of Books])
With Encryption
As 
	Select Code, Count(B.Id)
	From Book B Inner Join Shelf sh on sh.Code = B.Shelf_code
	Group By Code

Select * From V2


-- 27.create a view "V3" That display the shelf code that have maximum number of books using the previous view "V2" 

Create View V3 ([Shelf with max num of books])
With Encryption
As
	Select Top(1) with ties [Shelf Code]
	From V2 
	Order By [Number Of Books] Desc

Select * From V3


SP_HelpText 'V3'

SELECT @secret = imageval
FROM   sys.sysobjvalues
WHERE  objid = OBJECT_ID(V3);


-- 28.Create a table named ‘ReturnedBooks’ With the Following Structure :
	-- [User] [SSN] [Book Id] [Due Date] [Return Date] [fees]
	--then create A trigger that instead of inserting the data of returned book
	-- checks if the return date is the due date or not if not so the user must pay
	-- a fee and it will be 20% of the amount that was paid before. 


Create Table ReturnedBooks(
	[User SSN] int,
	[Book Id] int,
	[Due Date] date,
	[Return Date] datetime,
	fees int
)

Create Or Alter Trigger T2 On ReturnedBooks
Instead Of Insert 
As
Begin
	
	-- ge the important inserted data
	Declare @inserted_ssn int, @inserted_B_Id int, @returndate datetime
	Select  @inserted_ssn = [User SSN], @inserted_B_Id = [Book Id], @returndate = [Return Date]  
	from inserted

	-- 'get the data from the Borrowing table to validate the enserted data'

	Declare @bid_borrow int, @userssn_borrow int, @Duedate date, @fees int

	Select @Duedate = Due_date, @fees = Amount , @bid_borrow = Book_id, @userssn_borrow = User_ssn
	from (Select * From Borrowing where User_ssn = @inserted_ssn and Book_id = @inserted_B_Id ) As T


	If @userssn_borrow is not null and @bid_borrow is not null 
	Begin 
		If @returndate >= @Duedate
		Begin
			Set @fees *= 1.2
			Insert Into ReturnedBooks Values(@inserted_ssn, @inserted_B_Id, @Duedate, @returndate, @fees)
		End
		Else
			Insert Into ReturnedBooks Values(@inserted_ssn, @inserted_B_Id, @Duedate, @returndate, @fees)

	End
End


Insert Into ReturnedBooks values(1, 2, '2020-02-20', getdate(), Null)

Select * From ReturnedBooks




-- 29.In the Floor table insert new Floor With Number of blocks 2 , employee
--with SSN = 20 as a manager for this Floor,The start date for this manager
--is Now. Do what is required if you know that : Mr.Omar Amr(SSN=5)
--moved to be the manager of the new Floor (id = 6), and they give Mr. Ali
--Mohamed(his SSN =12) His position .


Insert Into Floor Values(7, 2, 20, getdate())

Update Floor 
Set MG_ID = 12
Where MG_ID = 5
Update Floor
Set MG_ID = 5
where Number = 6

Select * from Floor
Select * From Employee


-- 30.Create view name (v_2006_check) that will display Manager id, Floor
--Number where he/she works , Number of Blocks and the Hiring Date
--which must be from the first of March and the May of December
--2022.
	--this view will be used to insert data so make sure that the coming
	--new data must match the condition then try to insert this 2 rows and
	--Mention What will happen



Create View v_2006_check ([Employee Id], [Floor Number], [Num Of Blocks], [Hiring Date])
With Encryption 
As
	Select  MG_ID, Number, Num_blocks, Hiring_Date 
	From Floor 
	Where Hiring_Date between '2022-03-01' and '2022-12-31'
With Check Option

Select * From v_2006_check

Insert Into v_2006_check Values	(2, 8, 2, '2023-08-07')
	-- Duplicate PK , but if we change the floor number to new floor it will not insert also because of the check option 
	-- the inserted hire date must be in the range of the condition
	
	
Insert Into v_2006_check Values (4, 8, 1, '2022-08-04')
	-- the data added succesfuly because the the floor number is not duplicate and the hiring date is in the range 

Select * from Floor


-- 31.Create a trigger to prevent anyone from Modifying or Delete or Insert in
--the Employee table ( Display a message for user to tell him that he can’t
--take any action with this Table)


Create Trigger T1 On Employee 
Instead Of Insert, Update, Delete
As 
	Select 'Sorry '+ SUSER_NAME() +', You can’t take any action with this Table'


Delete from Employee where Id  = 1
Select * From Employee


-- 32.Testing Referential Integrity , Mention What Will Happen When:

--A. Add a new User Phone Number with User_SSN = 50 in
--User_Phones Table {1 Point}
Insert Into User_phones Values(50, '01007543268')
-- conflicted with the FOREIGN KEY constraint because the user with ssn 50 is not in the users table 


--B. Modify the employee id 20 in the employee table to 21 {1 Point}
-- Disable the trigger first 
Alter Table Employee Disable Trigger T1

Update Employee 
Set Id = 21 where Id = 20 -- Cannot update identity column(Primary Key) 'Id'. '


--C. Delete the employee with id 1 {1 Point}

Begin Transaction 

Delete From Employee where Id = 1 
	-- Error: Conflict with the FK in the (Borrowing, Users, Floor, EmployeeSuper) Tables,  we cannot delete A parent with a child ... 
	-- the Employee with Id=1 is must be deleted first from all the Connected FK 


--D. Delete the employee with id 12 {1 Point}


Delete From Employee where Id = 12
	-- The DELETE statement conflicted with the REFERENCE constraint "FK_Borrowing_Employee".
	-- Same Error as before We Cannot Delete A Parent With A Child Unless we deal with all the Fk connected To the Parent


--E. Create an index on column (Salary) that allows you to cluster the data in table Employee.

Create Clustered Index  i01 
On Employee(Salary)  
-- Cannot create more than one clustered index on table 'Employee'.
-- By Default the Clustered Index Is on the PK column

-- or create non clustered index
Create NonClustered Index I01
On Employee(Salary)


-- 33.Try to Create Login With Your Name And give yourself access Only to
--Employee and Floor tables then allow this login to select and insert data
--into tables and deny Delete and update (Don't Forget To take screenshot
--to every step) 

Create Login Abdullah
With Password = 'Abaza123'

Use Library
Go

Create User Abdullah
For Login Abdullah;
-- now the user for this login in the Library DB can access the DB but cannot access any tables and other database objects

Grant Select, Insert 
On Employee 
To Abdullah

Grant Select, Insert 
On Floor
To Abdullah

Deny Update, Delete
On Employee
To Abdullah 

Deny Update, Delete
On Floor
To Abdullah


