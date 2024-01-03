using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace Examination_System
{
    class FinalExam : Exam
    {
        #region 3.We want the application to accept different Question Types:
        //For Final Exam:
        //a.True or False
        //b.MCQ(Choose one answer)
        #region Constructor
        public FinalExam(int time, int numberOfQuestions) : base(time, numberOfQuestions)
        {
        }
        #endregion
        #region Overriding on Create List Of Questions Function
        public override void CreateListOfQuestions()
        {
            ListOfQuestions = new Question[NumberOfQuestions];
            for (int i = 0; i < ListOfQuestions?.Length; i++)
            {
                int choice;
                do
                {
                    Console.Write("Please Enter Type Of Question (1 for MCQ | 2 for True False ): ");
                } while (!int.TryParse(Console.ReadLine(), out choice) && choice < 1 || choice > 2);

                Console.Clear();

                if (choice == 1)
                {
                    ListOfQuestions[i] = new MCQQuestion();
                    ListOfQuestions[i].AddQuestion();

                }
                else
                {
                    ListOfQuestions[i] = new TFQuestion();
                    ListOfQuestions[i].AddQuestion();
                }
            }
        }
        #endregion
        #region Overriding on Show Exam Function
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
                Console.WriteLine("---------------------------------------");

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

            #region Final Exam Shows the Questions, Answers and Grade
            int TotalMarks = 0, Grade = 0;
            Console.WriteLine("Your Answers: \n");

            for (int i = 0; i < ListOfQuestions?.Length; i++)
            {
                TotalMarks += ListOfQuestions[i].Marks;
                if (ListOfQuestions[i].RightAnswer.AnswerId == ListOfQuestions[i].UserAnswer.AnswerId)
                {
                    Grade += ListOfQuestions[i].Marks;
                }
                Console.WriteLine($"Question ({i + 1}) :{ListOfQuestions[i].Body}");
                Console.WriteLine($"Your Answer => {ListOfQuestions[i].UserAnswer.AnswerText}");
                Console.WriteLine($"Right Answer => {ListOfQuestions[i].AnswerList[i].AnswerText}");
                Console.WriteLine("----------------------------------------------------------------");
            }
            Console.WriteLine($"Your Grade Is {Grade} from {TotalMarks}");

            #endregion
        }
        #endregion
        #endregion
    }
}
