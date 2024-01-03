using EF_Core_Assignment_01.Contexts;
using EF_Core_Assignment_01.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query.Internal;

namespace EF_Core_Assignment_01
{
    internal class Program
    {
        static void Main(string[] args)
        {
            //EnterpriseDBContext dBContext = new EnterpriseDBContext(); // Open Connection


            //try
            //{
            //    // CRUD Operations => Query Object Model
            //}
            //finally
            //{
            //    // Deallocate | Free | Close | Dispose [ Database Connection ]
            //    dBContext.Dispose();

            //}

            // using() --> syntax suger for try{}finally{}
            //using(EnterpriseDBContext dBContext = new EnterpriseDBContext())
            //{

            //}

            using EnterpriseDBContext dBContext = new EnterpriseDBContext();

            Employee Emp1 = new Employee()
            {
                Name = "Ahmed",
                Age = 25,
                Salary = 3_000,
                Email = "Ahmed@gmail.com"
            };
            Employee Emp2 = new Employee()
            {
                Name = "Abdullah",
                Age = 21,
                Salary = 6_000,
                Email = "Abdullah@gmail.com"
            };
            Employee Emp3 = new Employee()
            {
                Name = "Yassmine",
                Age = 18,
                Salary = 8_000,
                Email = "Yassmine@gmail.com"
            };


            #region Add - Create
            //// Track Object State
            //Console.WriteLine(dBContext.Entry(Emp1).State); // Detached

            //// Add To Local Sequence
            //dBContext.Employees.Add(Emp1);
            //dBContext.Set<Employee>().Add(Emp2);
            //dBContext.Add(Emp3); // EF Core 3.1 feature
            //dBContext.Entry(Emp2).State = EntityState.Added;

            //Console.WriteLine(dBContext.Entry(Emp1).State); // Added


            // Add To Remote 

            //dBContext.SaveChanges();

            //Console.WriteLine(dBContext.Entry(Emp1).State); // Unchanged

            //Console.WriteLine("====================================================");

            #endregion


            #region Select

            //dBContext.ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.TrackAll;



            //var Abdullah = (from E in dBContext.Employees
            //                where E.EmpId == 4
            //                select E)/*.AsNoTracking()*/.FirstOrDefault();


            //Console.WriteLine(Abdullah?.Name ?? "NA");

            //Console.WriteLine(dBContext?.Entry(Abdullah)?.State); // Unchanged

            //Console.WriteLine("===========================================================");
            #endregion

            #region Update

            //Abdullah.Name = "Abdullah Abaza";

            //Console.WriteLine(dBContext.Entry(Abdullah).State); // Modified

            //// Update Remote
            //dBContext.SaveChanges();
            //Console.WriteLine(dBContext.Entry(Abdullah).State); // Unchanged

            //Abdullah = dBContext.Employees.FirstOrDefault(e => e.EmpId == 4);
            //Console.WriteLine(Abdullah?.Name ?? "NA");

            //Console.WriteLine(dBContext.Entry(Abdullah).State); // Unchanged


            //Console.WriteLine("============================================================");
            #endregion


            #region Remove - Delete
            ////Remove From Local
            //dBContext.Employees.Remove(Abdullah);
            //Console.WriteLine(dBContext.Entry(Abdullah).State); // Deleted

            ////Remove From Remote
            //dBContext.SaveChanges();
            //Console.WriteLine(dBContext.Entry(Abdullah).State); // Detached



            #endregion


            #region Ensure App Is Migrated
            // 
            // 1. 
            //dBContext.Database.Migrate();

            // 2. Package Manager Console
            // --> must install Microsoft.EntityFramworkCore.Tools

            // Add-Migration "Initial Create"

            // Update Database --> Apply Up() In All not updated Migrations

            // Remove-Migration 
            // Update-Database 


            // Update-Database -Migration "InitialCreate" --> revert to last good Migration
            // Remove-Migration --> Last Migration


            // revert to No Migration --> state 0

            // Update-Database -Migration 0
            // Remove-Migration 



            // Crud WithProp
            // dBContext.Employees.Add();

            // FluentAPIs
            //dBContext.Set<Deparment>().Add();

            #endregion



            Department dept1 = new Department() { Name = "Sales", DateOfCreation = DateTime.Now };
            Department dept2 = new Department() { Name = "Training", DateOfCreation = DateTime.Now };

            //dBContext.Add(dept1);
            //dBContext.Add(dept2);

            //dBContext.SaveChanges();

            //var employees = dBContext.Employees.Select(e => e);

            //foreach (var item in employees) 
            //    Console.WriteLine($"EmpId: {item.EmpId} ::: EmpName: {item.Name} ::: Salary: {item.Salary} ::: DeptId: {item.DepartmentId}");

            //foreach (var employee in employees)
            //{
            //    if (employee.EmpId < 3) employee.DepartmentId = 10;
            //    else employee.DepartmentId = 20;
            //}
            //dBContext.SaveChanges();



            #region Explicit Loading .Vs Eager Loading .Vs Loading


            //var department = (from D in dBContext.Departments
            //                 where D.DeptId == 10
            //                 select D).FirstOrDefault();

            //Console.WriteLine($"DeptId: {department.DeptId} :::: DeptName: {department.Name} :::: DateOfCreation: {department.DateOfCreation}");

            //foreach(var employee in department.Employees)
            //    Console.WriteLine($"EmpId: {employee.EmpId} ::: EmpName: {employee.Name} ::: Salary: {employee.Salary} ::: DeptId: {employee.DepartmentId}");


            //var employees = from E in dBContext.Employees where E.DepartmentId == 10 select E;

            //foreach(var employee in employees) 
            //    Console.WriteLine(employee.Department.Name); // Null Reference Exception


            #region Exceplicit Loading

            // Get the department 10 with its Employees

            //var department = dBContext.Departments.Where(D => D.DeptId == 10).FirstOrDefault();
            //Console.WriteLine($"DeptId: {department.DeptId} :::: DeptName: {department.Name} :::: DateOfCreation: {department.DateOfCreation}");


            // Explicit load
            //dBContext.Entry(department).Collection(D => D.Employees).Load(); // load employees in this department

            //foreach (var employee in department.Employees)
            //    Console.WriteLine($"------------> EmpId: {employee.EmpId} ::: EmpName: {employee.Name} ::: Salary: {employee.Salary} ::: DeptId: {employee.DepartmentId}");


            //var employee = dBContext.Employees.Where(E => E.EmpId == 1).FirstOrDefault();

            //dBContext.Entry(employee).Reference(E => E.Department).Load();

            //Console.WriteLine($"DeptId: {employee.Department.DeptId} :::: DeptName: {employee.Department.Name}");
            //Console.WriteLine($"------------> EmpId: {employee.EmpId} ::: EmpName: {employee.Name} ::: Salary: {employee.Salary} ");



            #endregion

            #region Eager Loading 

            //var department = (from D in dBContext.Departments.Include(D => D.Employees)/*.ThenInclude()*/
            //                  where D.DeptId == 10
            //                  select D).FirstOrDefault();

            //department = dBContext.Departments.Where(D => D.DeptId == 10).Include(D => D.Employees).FirstOrDefault();


            //Console.WriteLine($"DeptId: {department.DeptId} :::: DeptName: {department.Name} :::: DateOfCreation: {department.DateOfCreation}");

            //foreach (var employee in department.Employees)
            //    Console.WriteLine($"------------> EmpId: {employee.EmpId} ::: EmpName: {employee.Name} ::: Salary: {employee.Salary} ::: DeptId: {employee.DepartmentId}");


            //var employee = dBContext.Employees.Where(E => E.EmpId == 1).Include(E => E.Department).FirstOrDefault();

            //Console.WriteLine($"DeptId: {employee.Department.DeptId} :::: DeptName: {employee.Department.Name}");
            //Console.WriteLine($"------------> EmpId: {employee.EmpId} ::: EmpName: {employee.Name} ::: Salary: {employee.Salary} ");


            #endregion


            #region Lazy Loading 
            // 1. Should prepare the environment first --> Install EF Core Proxies
            // 2. On Configuring -->optionsBuilder.UseLazyLoadingProxies().UseSqlServer(......);
            // 3. Any Navigational Property --> Must Be public virtual
            // 4. Make the class public public,
            //      or internal and mark your assembly with [assembly: InternalsVisibleTo("DynamicProxyGenAssembly2")] attribute


            //var department = dBContext.Departments.Where(D => D.DeptId == 10).FirstOrDefault();

            //Console.WriteLine($"DeptId: {department.DeptId} :::: DeptName: {department.Name} :::: DateOfCreation: {department.DateOfCreation}");

            //foreach (var employee in department.Employees)
            //    Console.WriteLine($"------------> EmpId: {employee.EmpId} ::: EmpName: {employee.Name} ::: Salary: {employee.Salary} ::: DeptId: {employee.DepartmentId}");


            #endregion




            #endregion




        }
    }
}