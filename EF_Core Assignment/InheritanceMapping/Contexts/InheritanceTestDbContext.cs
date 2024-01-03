using InheritanceMapping.Entities;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InheritanceMapping.Contexts
{
    internal class InheritanceTestDbContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
            => optionsBuilder.UseSqlServer("Server = DESKTOP-7RK5GNH\\PROJECTMODELS; Database = InheritanceTest; Trusted_Connection = True");


        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {

            // Fluent APIs

            // Table Per Hierachy => TPH
            // EF Core Will Generate New Column Named as "Discriminator" of Type "nvarchar(Max)"
            // FullTime | PartTime
            modelBuilder.Entity<FullTime>().HasBaseType<Employee>();
            modelBuilder.Entity<PartTime>().HasBaseType<Employee>();













            modelBuilder.Entity<FullTime>()
                .Property(F => F.Salary)
                .HasColumnType("money");

            modelBuilder.Entity<PartTime>()
                .Property(P => P.HoureRate)
                .HasColumnType("decimal(12, 4)");
                


            base.OnModelCreating(modelBuilder);
        }


        // TPCC  => Table Per Concrete Class

        //public DbSet<FullTime> FullTimeEmployees { get; set;}
        //public DbSet<PartTime> PartTimeEmployees { get; set;}

        public DbSet<Employee> Employees { get; set;}
    }
}
