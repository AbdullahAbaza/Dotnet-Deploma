
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