
-------------------------------------------------------------------
-- 1) DDL => Data Definition Language
-- 1. Create

Create Database CompanyCycle39

Use CompanyCycle39

create table Employee
(
SSN int primary key identity(1, 1),
FName varchar(15) not null,
LName varchar(15),
Address varchar(20) default 'Cairo',
Salary Money,
Gender char(1),
BDate Date,
DNo int,
SuperSSN int references Employee(SSN)
)
create table Department
(
Number int primary key identity(10, 10),
Name varchar(15) not null,
StarteDate Date,
MGRSSN int references Employee(SSN)
)
create table DeptLocations
(
Number int references Department(Number),
Name varchar(15),
primary key(Number, Name)
)

create table Project
(
PNum int primary key identity, 
PName varchar(20) not null,
Location varchar(20),
DNo int references Department(Number)
)

create table Dependent
(
Name varchar(20) not null,
Gender char(1),
BDate Date,
Relationship varchar(20),
ESSN int references Employee(SSN),
primary key(ESSN, Name)
)

create table Works_On
(
ESSN int references Employee(SSN),
PNo int references Project(PNum),
Hours tinyint ,
primary key(ESSN, PNo)
)

-- 2. ALter [Update]

Alter Table Employees
Add Test int

Alter Table Employees
Alter Column Test bigint

Alter Table Employees
Drop Column Test



alter table Employee
add foreign key (DNo) references Department(Number)
 

-- 3. Drop [Remove]
drop table Employee
=========================================================================
-- 2) DML => Data Manpulation Language

-- 1. Insert

--------- 1.1 Simple Insert (Add Just Only One Row)

Insert Into Employees
Values('Ahmed', 'Nasr', '02-22-1963', 'Alex', 'M', 8000, Null, Null)

Insert Into Employees(Salary, FName, BDate, Gender)
Values(4000, 'Mohamed', '03-22-1999', 'M')

-- 1. Identity Constraint
-- 2. Default Value
-- 3. Allow Null


--------- 1.2 Row Constructor Insert (Add More Than One Row)


Insert Into Employees
Values
('Mona', 'Nasr', '02-22-1963', 'Cairo', 'F', 8000, 1, Null),
('Amr', 'Ibrahim', '02-22-1963', 'Tanta', 'M', 8000, 1, Null),
('Aya', 'Ali', '02-22-1963', 'Giza', 'F', 8000, 1, Null),
('Mohamed', 'Amr', '02-22-1963', 'Mansoura', 'M', 8000, 1, Null)



-- 2. Update

Update Employees
	Set EmpAddress = 'Dokki'
	where Id = 1

Update Employees
	Set FName = 'Hamda', LName = 'Hambozo'
	where Id = 2

Update Employees
	Set Salary += Salary * .1
	where Salary <= 5000 and EmpAddress = 'Cairo'


-- 3. Delete

Delete From Employees



Delete From Employees
	Where Id = 9

=========================================================================
=========================================================================
=========================================================================


use Route

-- 3) DQL => Data Query Language

select *
from Student

select St_Fname +' '+ St_Lname FullName
from Student

select St_Fname +' '+ St_Lname  [Full Name]
from Student

select [Full Name] = St_Fname +' '+ St_Lname  
from Student


select * 
from Student
where St_Age > 23

select * 
from Student
where St_Age between 21 and 25

select *
from Student
where St_Address in ('Alex', 'Mansoura', 'Cairo')


select *
from Student
where St_Address not in ('Alex', 'Mansoura', 'Cairo')

Select * 
from Student
where St_super is not Null

--------------------------
-- like With Some Patterns
/*
_ => one Char
% => Zero or More Chars 

*/ 
select *
from Student
where St_Fname like '_A%' -- Na Fady Kamel Hassan Nada Nadia 

/*

'a%h' 
'%a_' 
'[ahm]%' 
'[^ahm]%'
'[a-h]%'
'[^a-h]%'
'[346]%'
'%[%]'      
'%[_]%' 

'[_]%[_]' 

*/
select *
from Employee
where FName like '[_]A%'


-- Distinct
select distinct FName
from Employee

-- Order By
select St_Id, St_Fname, St_Age
from Student
order by St_Fname, St_Age desc

select St_Id, St_Fname, St_Age
from Student
order by 1, 2 desc

select *
from Student
order by 1
===========================================================
--------------------------- Joins -------------------------

-- 1. Cross join (Cartisian Product)
select S.St_Fname, D.Dept_Name
from Student S, Department D -- ANSI (Cartisian Product)

select S.St_Fname,  D.Dept_Name
from Student S Cross Join Department D -- Microsoft (Cross Join)



-- 2. Inner Join (Equi Join)

-- Equi Join Syntax (ANSI)
select S.St_Fname,  D.Dept_Name
from Student S, Department D
where D.Dept_Id = S.Dept_Id 

select S.St_Fname , D.*
from Student S, Department D
where D.Dept_Id = S.Dept_Id

-- Inner Join Syntax (Microsoft)
select S.St_Fname, D.Dept_Name
from Student S inner join Department D
	on D.Dept_Id= S.Dept_Id


-- 3. Outer Join
-- 3.1 Left Outer Join
select S.St_Fname, D.Dept_Name
from Student S left outer join Department D
	on D.Dept_Id= S.Dept_Id

-- 3.2 Right Outer Join
select S.St_Fname, D.Dept_Name
from Student S right outer join Department D
	on D.Dept_Id= S.Dept_Id

-- 3.3 Full Outer Join
select S.St_Fname, D.Dept_Name
from Student S full outer join Department D
	on D.Dept_Id = S.Dept_Id
