
using System.Collections;

namespace Demo
{
    public static class IntExtentions
    {
        public static int Reverse(this int number)
        {
            int reversednumber = 0, remainder;

            
            while(number != 0)
            {
                remainder = number % 10;
                reversednumber = reversednumber * 10 + remainder;
                number = number / 10;
            }


            return reversednumber;
        }

    }
}
