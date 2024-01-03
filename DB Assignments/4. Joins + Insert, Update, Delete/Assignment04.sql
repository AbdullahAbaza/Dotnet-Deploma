--==================== Joins With Insert and Delete ======================

Use ITI
Go

Create table TopStudents(
 St_Id int ,
 St_Name varchar(25),
 Crs_Id int ,
 Grade int,
 Primary Key (St_Id, Crs_Id)
)


Insert Into TopStudents(St_Id, St_Name, Crs_Id, Grade)

Select SC.St_Id, S.St_Fname+' '+S.St_Lname, SC.Crs_Id, SC.Grade
from Student S, Stud_Course SC
where S.St_Id = SC.St_Id and SC.Grade > 100
Select * from TopStudents



-- Join + Delete
Begin Tran Temp

Delete S
	From Student S Inner Join Stud_Course Sc 
	on S.St_Id = Sc.St_Id 
	where Grade < 85

Select * from Stud_Course


-- ============================ Part 1 ===================================

Use MyCompany;
GO

-- 1.	Display the Department id, name and id and the name of its manager.
Select D.Dnum, D.Dname, D.MGRSSN, E.Fname+' '+ E.Lname  As [Manager Name]
from Departments D, Employee E
where E.SSN = D.MGRSSN;

-- 2.	Display the name of the departments and the name of the projects under its control.

Select D.Dname, P.Pname
from Departments D, Project P
where D.Dnum = P.Dnum;

-- 3.	Display the full data about all the dependence associated 
--		with the name of the employee they depend on .

Select E.Fname+' '+ E.Lname AS [Emp_Name], D.* 
From Dependent D, Employee E
where E.SSN = D.ESSN;

-- 4.	Retrieve the names of all employees in department 10 
--		who work more than or equal 10 hours per week on the "AL Rabwah" project.

Select [Employee_Name] = E.Fname+' '+ E.Lname, E.Dno, WF.Hours, P.Pname
from Employee E, Works_for WF, Project P
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno
		and WF.Hours >= 10 and P.Pname = 'AL Rabwah' ;

-- 5. Find the names of the employees who were directly supervised by Kamel Mohamed.
-- Self Join

Select [Emp_Name] = E.Fname+' '+ E.Lname,
Supper.Fname+ ' '+ Supper.Lname As SuperVisor
from Employee E, Employee Supper
where Supper.SSN = E.Superssn and
		Supper.Fname+ ' '+ Supper.Lname = 'Kamel Mohamed' ;

-- 6.	Retrieve the names of all employees and the names of the projects 
--		they are working on, sorted by the project name.

Select [Emp_Name] = E.Fname+' '+ E.Lname, P.Pname As [Project Name]
from Employee E, Works_for WF, Project P
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno
Order By [Project Name] ;


-- 7.	For each project located in Cairo City , find the project number, 
--		the controlling department name ,the department manager last name, 
--		address and birthdate.

Select P.Pnumber, P.Plocation, D.Dname As [Controlling Department], 
		E.Lname As [Dept Manager LName], E.Address As [MGR Address], E.Bdate [MGR BirthDate]
from Project P, Departments D, Employee E
where E.SSN = D.MGRSSN and D.Dnum = P.Dnum
		and
		P.City = 'Cairo' ;


-- 8.	Display All Data of the managers

Select E.*
from Employee E, Departments D
where E.SSN = D.MGRSSN

-- 9.	Display All Employees data and the data of their dependents 
--		even if they have no dependents. (left Outer Join)

Select E.*, D.*
from Employee E left Outer Join Dependent D
on  E.SSN = D.ESSN ;


-- 10.	Display all the projects names, locations and the department 
--		which is responsible for it.

Select P.Pname [Project Name], P.Plocation [Proj Location] , D.Dname [Department]
from Project P, Departments D
where D.Dnum = P.Dnum ;


-- ================================= Part 2 ================================

Use ITI 
Go

-- 1. Select Supervisor first name and the count of students who supervises on them
-- (Self Join Student table)
Select Super.St_Fname [Supervisor Name], Count(Super.St_Fname) As [# Students Supervised]
from Student S, Student Super
where Super.St_Id = S.St_super
Group by Super.St_Fname



-- 2. Display number of courses for each topic name

Select T.Top_Name, count(C.Crs_Id) As [Num of Courses]
from Topic T, Course C
where T.Top_Id = C.Top_Id
Group By T.Top_Name


-- 3. Display max and min salary for instructors

Select Max(Salary) Max_Salary, Min(Salary) Min_Salary
from Instructor

-- 4.	Select Average Salary for instructors 

Select Avg(Salary) As Avg_Salary from Instructor


-- 5. Display instructor Name and Department Name 
--		Note: display all the instructors if they are attached to a department or not

Select Ins.Ins_Name, D.Dept_Name
from Instructor Ins Left Outer Join Department D
on D.Dept_Id = Ins.Dept_Id


-- 6. Display student full name and the name of the course he is taking 
--		For only courses which have a grade 

Select S.St_Fname+' '+ S.St_Lname [Student Name], C.Crs_Name, SC.Grade
from Student S, Stud_Course SC, Course C
where S.St_Id = SC.St_Id and C.Crs_Id = SC.Crs_Id 
		and SC.Grade is not Null;


--================================ Part 3 =================================

Use MyCompany
Go

-- DQL

-- 1.	For each project, list the project name and 
--		the total hours per week (for all employees) spent on that project.

Select P.Pname [Project Name], Sum(Hours) As [Total # Hours Spent]
from Project P , Works_for WF
where P.Pnumber = WF.Pno
Group By P.Pname


-- 2.	For each department, retrieve the department name 
--		and the maximum, minimum and average salary of its employees.

Select D.Dname [Department Name], 
		Max(E.Salary) [Max Salary], MIN(E.Salary) [Min Salary], Avg(E.Salary) [Avg Salary]
from Departments D, Employee E
where D.Dnum = E.Dno
Group By D.Dname


-- 3.	Retrieve a list of employees and the projects they are working on 
--		ordered by department and within each department, 
--		ordered alphabetically by last name, first name.

Select coalesce(E.Fname, E.Lname, E.Address, 'No data') As [Fname], 
		E.Lname, P.Pname [Project Name], D.Dname
from Employee E , Departments D, Project P
where D.Dnum = P.Dnum and D.Dnum = E.Dno
Order By D.Dname, E.Lname, E.Fname



-- 4.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 

-- Display Old Salary
Select E.Fname, E.Salary, P.Pname
from Employee E, Works_for WF, Project P
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno and P.Pname = 'Al Rabwah'


-- Update And Display New Salary
Update Employee
	set Salary += Salary * 0.3
Select E.Fname, E.Salary, P.Pname
from Employee E, Works_for WF, Project P
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno and P.Pname = 'Al Rabwah'



-- DML

-- 1. In the department table insert a new department called "DEPT IT" , 
--	  with id 100, employee with SSN = 112233 as a manager for this department. 
--	  The start date for this manager is '1-11-2006'

Insert Into Departments 
	Values('DEPT IT', 100, 112233, 1-11-2006)


-- 2. Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  
--    moved to be the manager of the new department (id = 100), 
--    and they give you(your SSN =102672) her position (Dept. 20 manager) 

--			a. First try to update her record in the department table

-- Begining a Transaction to insure we can rollback if needed
Declare @TransName  varchar(20)
Select @TransName = 'Updating MyCompany DB'
Begin Transaction @TransName
Use MyCompany


Update Departments
	set MGRSSN = 968574, [MGRStart Date] = '2023-06-21' 
where Dnum = 100

-- b.	Update your record to be department 20 manager.

Update Employee
	set Fname = 'Abdullah', Lname = 'Abaza', Bdate = '2001-06-09', 
	Address = '10th of Ramadan City', Sex = 'M', Salary = 5000
where SSN = 102672

Update Departments
	set MGRSSN = 102672, [MGRStart Date] = '2023-06-21' 
where Dnum = 20


-- checking the new employee Records
Select * From Employee -- all good
Commit Transaction @TransName
GO

-- c. Update the data of employee number=102660 
-- to be in your teamwork (he will be supervised by you) 
-- (your SSN =102672)
Update Employee 
	set Superssn = 102672
where SSN = 102660


-- 3. Unfortunately the company ended the contract with 
-- Mr. Kamel Mohamed (SSN=223344) so try to delete his data 
-- from your database in case you know that you will be 
-- temporarily in his position.
--	Hint: (Check if Mr. Kamel has dependents, works as a department manager, 
--	supervises any employees or works in any projects and handles these cases).

-- replacing him as a super 

Select * from Employee where Superssn = 223344

Update Employee 
	set Superssn = 102672
where Superssn = 223344

Select * from Dependent where ESSN = 223344
Delete from Dependent 
	where ESSN = 223344


Select D.*, P.*
from Departments D , Project P
where D.MGRSSN = 223344 and D.Dnum = P.Dnum

Update Departments
	set MGRSSN = 102672, [MGRStart Date] = '2023-06-21'
where MGRSSN = 223344

Select E.Fname, E.Lname, E.SSN, WF.* 
from Employee E, Works_for WF, Project P
where E.SSN = WF.ESSn and P.Pnumber = WF.Pno and SSN = 223344

Delete From Works_for
	where ESSn = 223344


Delete from Employee
	where ssn = 223344

