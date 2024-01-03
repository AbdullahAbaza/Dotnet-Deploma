using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InheritanceMapping.Entities
{
    internal class PartTime : Employee
    {
        public decimal HoureRate { get; set; }
        public int CountHours { get; set; }

    }
}
