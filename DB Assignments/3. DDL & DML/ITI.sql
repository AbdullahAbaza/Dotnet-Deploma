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