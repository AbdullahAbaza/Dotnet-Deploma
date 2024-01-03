using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_System
{

    abstract class Exam
    {
        #region 6.Design a Base class Exam describe the common attributes concerning the exam:
        //a.Time of exam
        //b.Number of Questions
        //c.Show Exam Functionality that it’s implementations will be different for each exam based to its type.
        #region Attrbiutes
        public int Time { get; set; }
        public int NumberOfQuestions { get; set; }
        public Question[] ListOfQuestions { get; set; }

        #endregion
        #region Constructor
        public Exam(int time, int numberOfQuestions)
        {
            Time = time;
            NumberOfQuestions = numberOfQuestions;
        }
        #endregion
        #region Methods
        public abstract void ShowExam();
        public abstract void CreateListOfQuestions();
        #endregion

        #endregion
    }
}
