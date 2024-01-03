-- Restored the MyCompany DB and changed admin to sa

Use MyCompany

-- 1.	Display all the employees Data.

Select * from Employee

--2.	Display the employee First name, last name, Salary and Department number.

Select Fname, Lname, Salary, Dno from Employee

-- 3.	Display all the projects names, locations and the department which is responsible for it.

Select Pname, Pnumber, Plocation from Project

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

-- 2.	Display instructor Name and Department Name 
--			- Note: display all the instructors if they are attached to a department or not

Select I.Ins_Name, D.Dept_Name 
	from Instructor I left outer join Department D
	on I.Dept_Id = D.Dept_Id 


-- 3.	Display student full name and the name of the course he is taking
-- For only courses which have a grade  



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



