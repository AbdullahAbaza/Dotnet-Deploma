using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.CodeAnalysis;

namespace EF_Core_Assignment_01.Entities
{
    // EF supports 4 ways for Mapping from classes to Database(Tables, Views, Functions )
    // 1. By Convention (Default Behavior)
    // 2. Data Annotation (Set Of Attributes Used For Data Validation)
    // 3. Fluent APIs ( DbContext --> Override OnModelCreating() )
    // 4. Configuration Class Per Entity ( Organize Fluent APIs)



    #region POCO Class
    //  => Plian Old CLR Object 
    //internal class Employee
    //{
    //    public int Id { get; set; } // public Numeric Property named "Id" | "EmployeeId"  \
    //                                // EF => Table ( Id --> PK + Identitiy Constraint

    //    //public string? EmpName { get; set; } // ? Nullable<string> -->  Allow Null
    //    public string Name { get; set; } // Not Null
    //    public decimal Salary { get; set; } // Doesn't Allow Null
    //    public int? Age { get; set; } // Nullable<int> Allow Null

    //    [EmailAddress]
    //    public string Email { get; set; }

    //} 
    #endregion

    [Table("Employees", Schema = "dbo")]
    internal class Employee
    {

        [Key] // Pk
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)] // Identity (1, 1)
        public int EmpId { get; set; }


        [Required] // Not Null
        [Column(TypeName = "nvarchar")]
        //[MaxLength(50)]
        [StringLength(50, MinimumLength = 10)]
        public string Name { get; set; }


        [Column(TypeName = "money")]
        [DataType(DataType.Currency)] // App Validation only
        public decimal Salary { get; set; }


        [Range(18, 60)]
        public int? Age { get; set; }

        [NotMapped]
        //[DataType(DataType.PhoneNumber)]
        [Phone]
        public string? PhoneNumber { get; set; }


        [EmailAddress]
        public string Email { get; set; }

        [NotMapped]
        [PasswordPropertyText]
        //[DataType(DataType.Password)]
        public string Password { get; set; }




        //[AllowNull]
        //[ForeignKey("Department")] // ==> name of the navigation  property 
        public int? DepartmentId { get; set; }  // Foreign Key



        // Navigational Property => ONE 1 

        //[ForeignKey("DeptId")]
        [InverseProperty("Employees")]  // => use it when you have more than one relationship
        public virtual Department Department { get; set; }

    }
}



