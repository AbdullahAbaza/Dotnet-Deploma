using InheritanceMapping.Contexts;
using InheritanceMapping.Entities;

namespace InheritanceMapping
{
    internal class Program
    {
        static void Main(string[] args)
        {
            using InheritanceTestDbContext dbContext = new InheritanceTestDbContext();

            FullTime fullTime = new FullTime()
            {
                Name = "Ahmed",
                Address = "Cairo",
                Age = 20,
                Salary = 5_000,
                StartDate = DateTime.Now,
            };

            PartTime partTime = new PartTime()
            {
                Name = "Abdullah",
                Address = "Alexandria",
                Age = 26,
                HoureRate = 100,
                CountHours = 120

            };

            //dbContext.Employees.Add(fullTime);
            //dbContext.Employees.Add(partTime);

            //dbContext.SaveChanges();

            foreach(var full in dbContext.Employees.OfType<FullTime>())
            {

                Console.WriteLine($"EmployeeName: {full.Name}, Salary: {full.Salary}");
            }            
            foreach(var part in dbContext.Employees.OfType<PartTime>())
            {
                Console.WriteLine($"EmployeeName: {part.Name}, HourRate: {part.HoureRate}");
            }
        }
    }
}