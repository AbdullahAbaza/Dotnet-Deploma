-- 4.	Display the Department name that contains the instructor who receives the minimum salary.

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

Select Top(1) Dept_Name
from (	Select Dept_Name, Min(Salary) [Salary]
		from Department D, Instructor S
		where D.Dept_Id = S.Dept_Id and S.Salary is not Null
		Group By Dept_Name) As DS
Order By DS.Salary


-- Best Performance
SELECT TOP(1) D.Dept_Name
FROM Department D
INNER JOIN Instructor I ON D.Dept_Id = I.Dept_Id
WHERE I.Salary IS NOT NULL
ORDER BY I.Salary
