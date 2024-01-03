using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EF_Core_Assignment_01.Entities
{
    internal class StudentCourse
    {
        public int StudentId { get; set; }

        public int CourseId { get; set; }

        public int Grade { get; set; }


        // Navigation Property => ONE
        //public Student Student { get; set; }
        //public Course Course { get; set; }

    }

}
