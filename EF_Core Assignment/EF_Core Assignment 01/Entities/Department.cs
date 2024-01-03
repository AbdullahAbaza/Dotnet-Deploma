
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;
using System.Runtime.CompilerServices;


[assembly: InternalsVisibleTo("DynamicProxyGenAssembly2")]

namespace EF_Core_Assignment_01.Entities
{

    internal class Department
    {
        public int DeptId { get; set; }
        public string Name { get; set; }
        public DateTime DateOfCreation { get; set; }



        // Navigational Property => Many 
        [InverseProperty("Department")]
        public virtual ICollection<Employee> Employees { get; set; } = new HashSet<Employee>();




        //public Department() { 
        //    Employees = new HashSet<Employee>();

        //}

    }
}
