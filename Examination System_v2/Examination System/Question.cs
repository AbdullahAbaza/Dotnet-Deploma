using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_System
{
    public abstract class Question
    {
        #region 1.Design a Class to represent the Question Object, Question is consisting of:
        //a.Header of the question
        //b.Body of the question
        //c.Mark 
        #region Class Members
        public abstract string Header { get;}
        public string Body { get; set; }
        public int Marks { get; set; }

        #region 5.Question is associated with an Array of answers and its right answer(Answers[] AnswerList).
        public Answer[] AnswerList { get; set; } 
        public Answer RightAnswer { get; set; }
        public Answer UserAnswer { get; set; }
        #endregion
        #endregion
        #region Constructor
        public Question()
        {
            RightAnswer = new Answer();
            UserAnswer = new Answer();
        } 
        #endregion
        #region Methods
        public abstract void AddQuestion();
        public override string ToString()
        {
            return $"{Header} \t Mark({Marks})\n" +
                "-------------------------------------" +
                $" \n{Body}\n";
        }
        #endregion
        #endregion
    }
}
