using System;
using System.Buffers.Text;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.Intrinsics.X86;
using System.Security.Claims;
using System.Xml.Linq;

namespace Examination_System
{
    internal class Program3
    {
        static void Main(string[] args)
        {

            Subject sub1 = new(1, "C#");
            sub1.CreateExam();
            Console.Clear();
            Console.Write("Do You Want To Start Exam ( y | n ) : ");
            char choice  = char.Parse(Console.ReadLine());
            if (choice == 'y' || choice == 'Y')
            {
                Console.Clear();
                Stopwatch sw = new();
                sw.Start();
                sub1.SubjectExam.ShowExam();
                Console.WriteLine($"\nThe Elapsed Time = {sw.Elapsed}");
            }
            else
                Console.WriteLine("Thank You");



        }
    }
}
