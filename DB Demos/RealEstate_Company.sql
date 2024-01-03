
-- DDL => Datat Definition Language 
-- Create

Create DataBase RealEstate_Company;

Use RealEstate_Company;

-- col_name datatype constraints (primary key, refrences, identity, default, not null

Create table Sales_Offices(
	Number int Primary Key identity(1, 1),
	Location varchar(50),
	Manager_ID int  --To Do: add FK form table Employee 
);

Create table Employees(
	EmpID int Primary Key identity(1, 1),
	EmpName varchar(50) not null,
	Office_Number int references Sales_Offices(Number)
);

-- add FK form table Employee 
Alter table Sales_Offices 
	Add foreign key (Manager_ID) references Employees(EmpID);


Create table Property(
	P_ID int Primary Key identity(100, 100),
	Address varchar(50) not null,
	City varchar(50),
	State varchar(50),
	ZipCode int not null ,
	Office_Number int references Sales_Offices(Number)
);

Create table Owners(
	Owner_ID int Primary Key identity(100, 100),
	Owner_Name varchar(50)
);

--Alter table Owners 
--	Alter column Owner_Name varchar(50) not null;
--	--add Constraint [not null] Default '' for [Owner_Name];

Create table Property_Owners(
	Property_ID int references Property(P_ID),
	Owner_ID int references Owners(Owner_ID),
	Percent_Owned decimal(5, 2) default(100.00)
	Primary Key (Property_ID, Owner_ID)
);

Insert into Property 
	values ('20 Neighbouring', '10th Of Ramadan', 
			'Al-Sharqia', 45520, null) ;

Insert into Owners
	values('Abdullah Abaza');
Insert into Owners
	values('Osama Abaza');

Insert into Property_Owners
	values(300, 200, 9.4);

Delete from Property_Owners where Property_ID = 300

select * from Property_Owners