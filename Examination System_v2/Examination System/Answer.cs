using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace Examination_System
{

   public class Answer
    {
        #region 4.We need to define a class for the answers(AnswerId, AnswerText).
        #region Attributes
        public int AnswerId { get; set; }
        public string AnswerText { get; set; }
        #endregion
        #region Constructor
        public Answer(int answerID, string answerText)
        {
            AnswerId = answerID;
            AnswerText = answerText;
        }

        public Answer()
        {

        }
        #endregion
        #region Overriding ToString
        public override string ToString()
        {
            return $"{AnswerId} _ {AnswerText}";
        } 
        #endregion
        #endregion
    }
}
