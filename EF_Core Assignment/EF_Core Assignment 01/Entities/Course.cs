using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EF_Core_Assignment_01.Entities
{
    internal class Course
    {
        public int Id { get; set; }
        public string Title { get; set; }

        // Navigation Property => Many
        //public ICollection<Student> Students { get; set; } = new HashSet<Student>();


        public virtual ICollection<StudentCourse> CourseStudents { get; set; } = new HashSet<StudentCourse>();
    }
}
