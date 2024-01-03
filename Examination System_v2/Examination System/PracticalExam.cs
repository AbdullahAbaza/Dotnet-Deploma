using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_System
{
    internal class PracticalExam : Exam
    {
        #region 3.We want the application to accept different Question Types:
        //For Practical Exam:
        //a.MCQ
        #region Constructor
        public PracticalExam(int time, int numberOfQuestions) : base(time, numberOfQuestions)
        {
        }
        #endregion

        #region Overriding on Create List Of Questions Function
        public override void CreateListOfQuestions()
        {
            ListOfQuestions = new MCQQuestion[NumberOfQuestions];
            for (int i = 0; i < ListOfQuestions?.Length; i++)
            {
                ListOfQuestions[i] = new MCQQuestion();
                ListOfQuestions[i].AddQuestion();
                Console.Clear();
            }
        }
        #endregion

        #region Overriding in Show Exam Function
        public override void ShowExam()
        {
            // Show Exam And Take Answers From user
            foreach (var Question in ListOfQuestions)
            {
                //Question
                Console.WriteLine(Question);

                //Answers Of Question
                for (int i = 0; i < Question.AnswerList?.Length; i++)
                    Console.WriteLine(Question.AnswerList[i]);
                Console.WriteLine("---------------------------");

                //User Answer
                int UserAnswerId;
                do
                {
                    Console.WriteLine("Please Enter Number of your answer : ");
                } while (!int.TryParse(Console.ReadLine(), out UserAnswerId) && UserAnswerId < 1 || UserAnswerId > 3);

                Question.UserAnswer.AnswerId = UserAnswerId;
                Question.UserAnswer.AnswerText = Question.AnswerList[UserAnswerId - 1].AnswerText;
                Console.WriteLine("*********************************************************** \n");
            }
            Console.Clear();

            #region Practical Exam Shows the right answer after finishing the Exam

            Console.WriteLine("Right Answers: \n");
            for (int i = 0; i < ListOfQuestions?.Length; i++)
            {
                Console.WriteLine($"Question ({i + 1}) : {ListOfQuestions[i].Body}");
                Console.WriteLine($"Right Answer => {ListOfQuestions[i].RightAnswer.AnswerText}");
                Console.WriteLine("-----------------------------------------------------------");
            }
            #endregion

        }

        #endregion
        #endregion
    }
}
