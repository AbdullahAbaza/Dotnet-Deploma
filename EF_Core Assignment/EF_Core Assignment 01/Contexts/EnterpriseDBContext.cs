using EF_Core_Assignment_01.Configuration;
using EF_Core_Assignment_01.Entities;
using Microsoft.EntityFrameworkCore;

namespace EF_Core_Assignment_01.Contexts
{
    internal class EnterpriseDBContext: DbContext
    {
        // Override OnConfiguring: DbContext
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            //    optionsBuilder.UseSqlServer("DataSource=DESKTOP-7RK5GNH\\PROJECTMODELS; " +
            //        "Initial Catalog = EnterpriseDB; Integrated Security = true"); 

            //optionsBuilder.UseSqlServer("Server = DESKTOP-7RK5GNH\\PROJECTMODELS; Database = EnterpriseDB; Trusted_Connection = true;");


            optionsBuilder.UseLazyLoadingProxies().UseSqlServer("Server = DESKTOP-7RK5GNH\\PROJECTMODELS; Database = EnterpriseDB; Trusted_Connection = true;");
        }



        // Fluent APIs
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfiguration<Department>(new DepartmentConfiguration());

            // OneToMany
            #region OneToMany
            modelBuilder.Entity<Department>()
                .HasMany(D => D.Employees)
                .WithOne(E => E.Department)
                .IsRequired(false)
                .HasForeignKey(E => E.DepartmentId)
                .OnDelete(DeleteBehavior.Cascade);
            //.OnDelete(DeleteBehavior.SetNull); 
            //.OnDelete(DeleteBehavior.Restrict); // take no action



            //modelBuilder.Entity<Employee>()
            //    .HasOne(E => E.Department)
            //    .WithMany(D => D.Employees)
            //    .IsRequired(false)
            //    .HasForeignKey(E => E.DepartmentId)
            //    .OnDelete(DeleteBehavior.Cascade);

            #endregion


            #region ManyToMany

            modelBuilder.Entity<Student>()
                .HasMany(C => C.StudentCourses)
                .WithOne(/*SC => SC.Student*/);

            modelBuilder.Entity<Course>()
                .HasMany(S => S.CourseStudents)
                .WithOne(/*SC => SC.Course*/);

            modelBuilder.Entity<StudentCourse>()
                .HasKey(SC => new { SC.StudentId, SC.CourseId });

            #endregion


            base.OnModelCreating(modelBuilder);


            #region FluentAPI No Configuration

            //modelBuilder.Entity<Employee>()
            //    .Property( e => e.Address)
            //    .HasDefaultValue("Cairo")
            //    .IsRequired(true);



            //modelBuilder.Entity<Department>().ToTable("Departments", "dbo");
            //modelBuilder.Entity<Department>().HasKey("Id");
            //modelBuilder.Entity<Department>().HasKey(nameof(Deparment.Id));



            //modelBuilder.Entity<Deparment>(
            //D =>
            //{
            //    D.HasKey(D => D.Id);

            //    D.Property(d => d.Id)
            //    .UseIdentityColumn(10, 10);

            //    D.Property(d => d.Name)
            //    .HasColumnName("DepartmentName")
            //    .HasColumnType("varchar")
            //    .HasMaxLength(50)
            //    .IsRequired(true)
            //    .HasAnnotation("StringLength", "(50, MinimumLength = 10)"); // Use A specific Data Annotation

            //    D.Property(d => d.DateOfCreation)
            //    //.HasDefaultValue(DateTime.Now) // Wrong Will Give Defaul Date of Migration
            //    .HasDefaultValueSql("GetDate()");

            //}
            //);
            #endregion


        }



        public DbSet<Employee> Employees { get; set; }
        public DbSet<Department> Departments { get; set; }
        public DbSet<Student> Students { get; set; }
        public DbSet<Course> Courses { get; set; }
        

    }
}
