--============================= Part 01 =====================================

Use ITI 

-- 1.	Display student with the following Format (use isNull function)
--			Student ID	Student Full Name	Department name
		
Select  St_Id As [Student ID], 
		coalesce(St_Fname, St_Lname, St_Address, ' ') +' '+  isnull(St_Lname, '') As [Student Full Name], 
		D.Dept_Name As [Department Name]
from Student S, Department D
where D.Dept_Id = S.Dept_Id

-- 2.	Select instructor name and his salary but if there is no salary display ‘0000’ . 
--		(use one of Null Function)

Select Ins_Name, isnull(Salary, 0000) As [Salary]
from Instructor


-- 3.	Display instructors who have salaries less than the average salary of all instructors.
-- Subquery

Select *
from Instructor 
where Salary < (Select AVG(Salary) from Instructor)


-- 4.	Display the Department name that contains the instructor who receives the minimum salary.
 
 -- Sub Query
Select Dept_Name
from Department D
Where D.Dept_Id = ( Select Dept_Id from Instructor 
					Where Salary = (Select Min(Salary) from Instructor)
					)


Select Dept_Name
from Department D
Where D.Dept_Id in (Select Top(1) Dept_Id from Instructor
					where Salary is not null 
					Order By Salary)

-- Best Performance  (Inner Join)
Select Top(1) D.Dept_Name 
from Department D 
Inner Join Instructor Ins on D.Dept_Id = Ins.Dept_Id
Where Ins.Salary Is Not Null
Order By Ins.Salary ASC



-- 5.	 Select max two salaries in the instructor table. 

Select Top(2) Salary [Max two Salaries]
from Instructor
Order By Salary Desc

-- SubQuery + Ranking
Select Salary [Max Two Salaries]
from (	Select Salary, row_number() over (order by Salary desc) AS RN 
		from Instructor
		where Salary is not null) As NewTable
where RN <= 2



-- 6.	Write a query to select the highest two salaries in Each Department 
--		for instructors who have salaries. “using one of Ranking Functions”

Select * from (
		Select Dept_Id, Salary, 
		Row_Number() over(Partition By Dept_Id Order By Salary Desc) AS RN
		From Instructor
		where Dept_Id is not null and Salary is not null
) As RankedSalary
Where RN <= 2;


-- 7.	Write a query to select a random  student from each department.  
--		“using one of Ranking Functions)

Select [Student Name]  , [Department]
from (Select 
		Coalesce(St_Fname, St_Lname, St_Address, '')+ ' ' +
		iSNull(St_Lname, '') As [Student Name], 
		Dept_Id [Department],
		Row_Number() Over (Partition By Dept_Id Order By NEWID() ) As [RN]
		From Student 
		where Dept_Id is not Null
) As RandomRank
Where RN = 1 ;

--=================================== Part 2 ===================================
Use MyCompany 
GO

select CONCAT(Fname, Lname, SSN)
from Employee


-- 1.	Display the data of the department which has the smallest employee ID 
--		over all employees' ID.

Select Top(1) D.* , E.SSN
from Departments D Inner Join Employee E on D.Dnum = E.Dno
Order By E.SSN asc


-- 2.	For each department
--		if its average salary is less than the average salary of all employees
--		display its number, name and number of its employees.
Select AVG(Salary) [Emp AVG(Salary)]from Employee

Select D.Dnum, D.Dname, COUNT(SSN) [Num Of Students], Avg(Salary) [AVG(Salary)]
from Departments D Inner Join Employee E on D.Dnum = E.Dno 
Group By D.Dnum, D.Dname
Having AVG(Salary) < (Select AVG(Salary) from Employee)


-- 3.	Try to get the max 2 salaries using (subquery)

-- 
Select (Select Max(Salary) from Employee) [Max Salary] , 
		Max(Salary) [Seconed Max Salary]
from Employee where Salary <> (Select Max(Salary) from Employee)


Select Salary [Max Two Salaries]
from ( Select Salary , Row_Number() Over (Order By Salary Desc) [RN] 
		from Employee ) As Ranked_Salary
where RN <= 2


Select Top(2) Salary [Max Two Salaries]
from Employee
Order By Salary Desc


-- 4.	Display the employee number and name if at least one of them has dependents 
--		(use exists keyword) self-study.

-- The Original Inner Join of the Table --- Same employee have multiple dependents
Select E.SSN, CONCAT(E.Fname, ' ' ,E.Lname) [Emp Name] , D.Dependent_name
From Employee E Inner Join Dependent D on E.SSN = D.ESSN


-- The EXISTS command tests for the existence of any record in a subquery, 
-- and returns true if the subquery returns one or more records.

Select E.SSN, CONCAT(E.Fname, ' ' ,E.Lname) [Emp Name]
From Employee E
Where EXISTS ( Select * from Dependent D Where E.SSN = D.ESSN)

