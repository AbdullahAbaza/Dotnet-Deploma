using System.Collections.Generic;
using static LINQ_Assignment02.ListGenerator;

namespace LINQ_Assignment02
{
    internal class Program
    {
        static void Main(string[] args)
        {
            #region LINQ - Element Operators
            Console.WriteLine("           =============== Element Ops ==============");

            //// Q1. Get first Product out of Stock 
            ///
            var firstOutOFStock = ProductsList.First(P => P.UnitsInStock == 0);

            Console.WriteLine(firstOutOFStock);

            //// Q2. Return the first product whose Price > 1000, unless there is no match, in which case null is returned.

            var firstPriceGrt1000 = ProductsList.FirstOrDefault(P => P.UnitPrice > 1000);
            Console.WriteLine(firstPriceGrt1000);

            //// Q3. Retrieve the second number greater than 5 
            ///
            int[] Arr = { 5, 4, 1, 3, 9, 8, 6, 7, 2, 0 };

            int secGrt5 = Arr.Where(n => n > 5).Where((n, i) => i > 0).FirstOrDefault();

            secGrt5 = Arr.Where(n => n > 5).Skip(1).FirstOrDefault();

            Console.WriteLine(secGrt5);

            #endregion

            #region Aggregate Operators
            Console.WriteLine("========================= Aggregate ==========================");

            //// Q1. Uses Count to get the number of odd numbers in the array

            int oddCount = Arr.Where(n => n % 2 == 1).Count();
            Console.WriteLine($"oddCount = {oddCount}");


            //// Q2. Return a list of customers and how many orders each has.
            ///
            var customerOrders = CustomersList.Select(C => new
            {
                C.CustomerName,
                orderCount = C.Orders.Count()
            });


            //// Q3. Return a list of categories and how many products each has
            ///
            var categoryWithProdCount = ProductsList.GroupBy(P => P.Category)
                .Select(C => new
                {
                    CategoryName = C.Key,
                    ProductCount = C.Count()
                });

            //// Q4. Get the total of the numbers in an array.
            ///

            int sum = Arr.Sum();


            //// Q5. Get the total number of characters of all words in dictionary_english.txt(Read
            /// dictionary_english.txt into Array of String First).

            List<string> EnglishDict = 


            foreach (var item in categoryWithProdCount) Console.WriteLine(item);


            #endregion


        }
    }
}