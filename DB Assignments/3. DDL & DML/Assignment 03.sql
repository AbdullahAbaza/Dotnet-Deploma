-- DDL

Create DataBase My_ITI

Use My_ITI


create table Students(
	ID int Primary Key Identity(1, 1),
	Fname nvarchar(25) not null,
	Lname nvarchar(25),
	Age int,
	Address nvarchar(max),
	Dep_ID int		-- TO Do: Alter and Add FK 
)

Create table Departments(
	ID int Primary Key identity(10, 10),
	Name varchar(50) not null,
	Manager_ID int,		-- To Do: Alter and Add FK refrence (Instructors)
	Hiring_Date date 
)

Create table Instructors(
	Ins_ID int Primary Key identity(1, 1),
	Name varchar(50) not null,
	Address varchar(max),
	Hour_Rate money,
	Salary money,
	Bonus money,
	Dep_ID int references Departments(ID) not null
)

Create table Topics(
	Topic_ID int Primary Key,
	Topic_Name varchar(max)
)

Create table Courses(
	Course_ID int Primary Key,
	C_Name varchar(max) not null,
	Duration int,
	Description varchar(max),
	Topic_ID int references Topics(Topic_ID)

)

Create Table Student_Grades(
	Student_ID int references Students(ID),
	Course_ID int references Courses(Course_ID),
	Grade int not null,
	Primary Key(Student_ID, Course_ID)
)


Create table Courses_Instructors(
	Course_ID int references Courses(Course_ID),
	Instructor_ID int references Instructors(Ins_ID),
	Evaluation varchar(max) not null,
	Primary Key(Course_ID, Instructor_ID)
)


-- TO Do: Alter Students and Add FK 
Alter table Students 
	add foreign key (Dep_ID) references Departments(ID)

-- To Do: Alter Depertments and Add FK refrence (Instructors) 

Alter table Departments 
	add foreign key (Manager_ID) references Instructors(Ins_ID)


--------------------------------------------------------------------------------

-- DML

Insert Into Students
	values 
	('Abdullah', 'Abaza', 22, '10th of ramadan', null),
	('Islam', null, 25, 'Cairo', null)

Insert into Departments 
	values
	('Software Engineering', null, null),
	('Data Science', null, null)



Insert Into Instructors 
	values
	('Mohammed Adel', 'Nasr City', 200, 10000, null, 20),
	('Dina Awni', 'New Cairo', 150, 7000, null, 30)

Insert Into Topics
	values
	(100, 'Mathematics'),
	(200, 'Programing Theory'),
	(300, 'Computer Hardware'),
	(400, 'Computer Networking')


Insert Into Courses	
	values
	(101, 'Math1', 120, 'Calculus 1 and Matricies', 100),
	(201, 'Logic Design', 160, null, 200)


Insert Into Courses_Instructors
	values 
	(101, 1, 'Exellent'),
	(201, 2, 'Very Good')

Insert Into Student_Grades
	values 
	(1, 101, 90),
	(1, 201, 100)


--======================================================

-- Restored the MyCompany DB and changed admin to sa

Use MyCompany

-- 1.	Display all the employees Data.

Select * from Employee

--2.	Display the employee First name, last name, Salary and Department number.

Select Fname, Lname, Salary, Dno from Employee

-- 3.	Display all the projects names, locations and the department 
--		which is responsible for it.

Select P.Pname, P.Plocation, D.Dname, P.Dnum
From Project P, Departments D
where D.Dnum = P.Dnum;

/* 4.	If you know that the company policy is to pay an annual commission 
for each employee with specific percent equals 10% of his/her annual salary .
Display each employee full name and his annual commission in an ANNUAL COMM column (alias).
*/

Select 
	[Full Name] = Fname + ' '+ Lname , 
	[ANNUAL COMM] = Salary * 12  * 0.1
from Employee


-- 5.	Display the employees Id, name who earns more than 1000 LE monthly.

Select SSN, Fname, Lname from Employee
	where Salary > 1000


-- 6.	Display the employees Id, name who earns more than 10000 LE annually.

Select SSN, Fname, Lname from Employee
	where Salary * 12 > 10000

-- 7.	Display the names and salaries of the female employees 

Select Fname, Lname, Salary from Employee
	where Sex = 'F'


-- 8.	Display each department id, name 
-- which is managed by a manager with id equals 968574.

Select Dnum, Dname from Departments
	where MGRSSN = 968574

-- 9.	Display the ids, names and locations of  the projects 
-- which are controlled with department 10.

Select Pname, Pnumber, Plocation, City from Project
	where Dnum = 10

 --=============================================================
 
 -- DML

 Insert into Employee (Dno, SSN, Superssn, Salary)
	values	(30, 102672, 112233, 3000)


Insert into Employee (Dno, SSN)
	values	(30, 102660)


Update Employee 
	set Salary += Salary * 0.2 
	where SSN = 102672

select * from Employee where SSN = 102672


--=======================================================
--======================== Part 3 =======================

-- Restoring ITI DB and Set the admin to sa

Use ITI

-- 1.	Get all instructors Names without repetition

Select Distinct Ins_Name from Instructor




/*
Global variables are pre-defined system variables. 
It starts with @@. It provides information about the present user environment for SQL Server. SQL Server provides multiple global variables, which are very effective to use in Transact-SQL. The following are some frequently used global variables –

@@SERVERNAME
@@CONNECTIONS
@@MAX_CONNECTIONS
@@CPU_BUSY
@@ERROR
@@IDLE
@@LANGUAGE
@@TRANCOUNT
@@VERSION

*/

select @@VERSION AS 'Version'
-- Returns system and build information for the current installation of SQL Server.


SELECT @@SERVERNAME AS 'Server Name'
-- Returns the name of the local server that is running SQL Server.


-- ============================== Part 4 ============================

Use MyCompany;
GO


-- 1.	Display the Id, name and location of the projects in Cairo or Alex city.

Select Pnumber As Proj_ID, Pname, Plocation, City
from Project 
where City in ('Cairo', 'Alex')

-- 2.	Display the Projects full data of the projects 
--		with a name starting with "a" letter.

Select * from Project where Pname like 'a%'

-- 3.	display all the employees in department 30 whose salary 
--		from 1000 to 2000 LE monthly

Select * from Employee
where Dno = 30 and  (Salary >= 1000 and Salary <= 2000)

Select * from Employee
where Dno = 30 and Salary between 1000 and 2000