using System.Collections.Generic;
using System.Reflection.Metadata;
using System.Threading;
using System.Xml.Linq;
using static LINQ_Assignment01.ListGenerator;

namespace LINQ_Assignment01
{
    internal class Program
    {
        static void Main(string[] args)
        {

            #region LINQ - Restrection Operators
            Console.WriteLine("\n========================= Resterction Op =========================");

            //// 1. Find all products that are out of stock.

            var outOfStock = ProductsList.Where(p => p.UnitsInStock == 0); //fluent

            outOfStock = from p in ProductsList where p.UnitsInStock == 0 select p; //query

            //foreach (var item in outOfStock) Console.WriteLine(item);

            

            //// 2. Find all products that are in stock and cost more than 3.00 per unit.

            var inStock = ProductsList.Where(p => p.UnitsInStock > 0 && p.UnitPrice > 3.00M);

            inStock = from p in ProductsList where p.UnitsInStock > 0 && p.UnitPrice > 3.00M select p;

            //foreach (var item in inStock) Console.WriteLine(item);

            

            //// 3. Returns digits whose name is shorter than their value.

            string[] arr = { "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };

            // Indexed Where
            var shorterThanValue = arr.Where((d, I) => d.Length < I);

            

            #endregion


            #region LINQ - Element Operators
            Console.WriteLine("\n========================= Element Operators ==================");

            //// 1. Get first Product out of Stock

            var firstOutOfStock = ProductsList.FirstOrDefault(p => p.UnitsInStock == 0);

            firstOutOfStock = (from p in ProductsList where p.UnitsInStock == 0 select p).FirstOrDefault(); //Hybrid Syntax

            Console.WriteLine(firstOutOfStock is null ? "NA" : firstOutOfStock);

            

            //// 2. Return the first product whose Price > 1000, unless there is no match, in which case null is returned.

            var firstWithPrice = ProductsList.FirstOrDefault(p => p.UnitPrice > 1000);
            firstWithPrice = (from p in ProductsList where p.UnitPrice > 1000 select p).FirstOrDefault();

            Console.WriteLine(firstWithPrice is null ? "NA" : firstWithPrice);

            

            //// 3. Retrieve the second number greater than 5 

            int[] arrNum = { 5, 4, 1, 3, 9, 8, 6, 7, 2, 0 };

            //int firstGrt5 = ArrNum.FirstOrDefault
            
            //foreach (var item in firstGrt5) Console.WriteLine(item);

            #endregion


            #region LINQ - Aggregate Operators 
            Console.WriteLine("\n========================== Aggregate Operators ===================");

            //// 1. Uses Count to get the number of odd numbers in the array
            int[] arr2 = { 5, 4, 1, 3, 9, 8, 6, 7, 2, 0 };

            int oddCount = arr2.Count(n => n % 2 == 1);
            Console.WriteLine($"OddCount: {oddCount}");

            

            //// 2. Return a list of customers and how many orders each has.

            var customersOrders = CustomersList.Select(c => new {
                CustomerID = c.CustomerId, c.CustomerName, OrderCount = c.Orders.Length
            });

            customersOrders = from c in CustomersList
                              select new {
                                  CustomerID = c.CustomerId, 
                                  c.CustomerName,
                                  //OrderCount = Enumerable.Count<Order>(c.Orders) 
                                  OrderCount = c.Orders.Length
                              };

            //foreach (var item in customersOrders) Console.WriteLine(item);

            

            //// 3. Return a list of categories and how many products each has

            // Group products by category and count the products in each category

            var categoryWithCountProd = ProductsList.GroupBy(p => p.Category)
                .Select(group => new
                {
                    CategoryName = group.Key,
                    ProductCount = group.Count()

                });
            // Query Expression
            categoryWithCountProd = from p in ProductsList
                                    group p by p.Category into categoryGroup
                                    select new
                                    {
                                        CategoryName = categoryGroup.Key,
                                        ProductCount = categoryGroup.Count()
                                    };
                                    


            foreach (var item in categoryWithCountProd)
            {
                Console.WriteLine($"CategoryName: {item.CategoryName}, ProductCount: {item.ProductCount}");
            }


            //Dictionary<string, int> categoryCounts = new Dictionary<string, int>();

            //foreach (var product in ProductsList)
            //{
            //    if (categoryCounts.ContainsKey(product.Category))
            //    {
            //        categoryCounts[product.Category]++;
            //    }
            //    else
            //    {
            //        categoryCounts[product.Category] = 1;
            //    }
            //}

            //// Print the results
            //foreach (var kvp in categoryCounts)
            //{
            //    Console.WriteLine($"CategoryName: {kvp.Key}, ProductCount: {kvp.Value}");
            //}



            

            //// 4. Get the total of the numbers in an array.

            int[] arr3 = { 5, 4, 1, 3, 9, 8, 6, 7, 2, 0 };

            Console.WriteLine(arr3.Count());

            

            //// 5.Get the total number of characters of all words in dictionary_english.txt(Read dictionary_english.txt into Array of String First).

            string[] englishDict = File.ReadAllLines("dictionary_english.txt");

            //Console.WriteLine($"Dictionary Length: {EnglishDict.Length}");
            Console.WriteLine($"Dictionary Length: {englishDict.Count()}");

            long totalNumCharInEngDict = 0;

            //foreach (var word in EnglishDict) totalNumCharInEngDict += word.Length;

            // Don't Run this --> Tooooo Sloooow
            //totalNumCharInEngDict = EnglishDict.Aggregate((word1, word2) => word1 + word2).Length;

            // Best Solution
            totalNumCharInEngDict = englishDict.Sum(w => w.Length);

            Console.WriteLine($"totalNumCharInEngDict: {totalNumCharInEngDict}");

            

            //// 6. Get the length of the shortest word in dictionary_english.txt

            int lengthShortestWord = englishDict.Min(w =>  w.Length);

            Console.WriteLine($"LengthShortestWord: {lengthShortestWord}");

            

            //// 7. Get the length of the longest word in dictionary_english.txt 

            int lengthLongesttWord = englishDict.Max(w => w.Length);

            Console.WriteLine($"LengthLongesttWord: {lengthLongesttWord}");




            //// 8. Get the average length of the words in dictionary_english.txt 

            double avgLengthOfWord = englishDict.Average(w => w.Length);

            Console.WriteLine($"AvgLengthOfWord: {avgLengthOfWord}");


            #endregion


            #region LINQ - Ordering Operators
            Console.WriteLine("\n======================== Ordering Operators =======================");

            //// 1. Sort a list of products by name

            var productsSortedByName = ProductsList.OrderBy(p => p.ProductName).Select(p => new { p.ProductName });

            productsSortedByName = from p in ProductsList
                                   orderby p.ProductName
                                   select (new { p.ProductName });

            //foreach (var product in productsSortedByName) Console.WriteLine(product);



            //// 2. Uses a custom comparer to do a case-insensitive sort of the words in an array.

            string[] strArr = { "aPPLE", "AbAcUs", "bRaNcH", "BlUeBeRrY", "ClOvEr", "cHeRry" };

            //Array.Sort(strArr, StringComparer.OrdinalIgnoreCase);

            var sortedWords = strArr.OrderBy(w => w, StringComparer.OrdinalIgnoreCase);

            foreach (string str in sortedWords) Console.WriteLine(str);

            Console.WriteLine();



            //// 3. Sort a list of products by units in stock from highest to lowest.

            var sortedProductByUnits = ProductsList.OrderByDescending(p => p.UnitsInStock)
                .Select(p => new { ProductID = p.ProductId, p.UnitsInStock });

            //foreach (var product in sortedProductByUnits) Console.WriteLine(product);



            //// 4. Sort a list of digits, first by length of their name, and then alphabetically by the name itself.
            Console.WriteLine();

            string[] digitArr = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"};

            var sortedDigits = digitArr.OrderBy(w => w.Length).ThenBy(w => w, StringComparer.OrdinalIgnoreCase);

            foreach (var digit in sortedDigits) Console.WriteLine(digit);




            //// 5. Sort first by-word length and then by a case-insensitive sort of the words in an array. 
            ///
            Console.WriteLine();
            sortedWords = strArr.OrderBy(w => w.Length).ThenBy(w => w, StringComparer.OrdinalIgnoreCase);

            foreach (string str in sortedWords) Console.WriteLine(str);



            //// 6. Sort a list of products, first by category, and then by unit price, from highest to lowest.
            ///
            Console.WriteLine("\n");
            var sortedProductByCategPrice = ProductsList.OrderBy(p => p.Category)
                .ThenByDescending(p => p.UnitPrice);

            //foreach(var item in sortedProductBy_Categ_Price) Console.WriteLine(item);




            //// 7. Sort first by-word length and then by a case-insensitive descending sort of the words in an array.
            ///
            Console.WriteLine("\n");

            sortedWords = strArr.OrderBy(w => w.Length)
                .ThenByDescending(w => w, StringComparer.OrdinalIgnoreCase);
            foreach (string str in sortedWords) Console.WriteLine(str);




            //// 8. Create a list of all digits in the array whose second letter is 'i' that is reversed from the order in the original array.
            ///
            Console.WriteLine("\n");
            var digitsSecLetterI = digitArr.Where(w => w[1] == 'i').Reverse();

            foreach(var digit in digitsSecLetterI) Console.WriteLine(digit);


            #endregion


            #region LINQ – Transformation Operators
            Console.WriteLine("\n============================== Transformation Operators =============================\n");

            //// 1. Return a sequence of just the names of a list of products.

            var productNames = ProductsList.Select(p => p.ProductName);


            //// 2. Produce a sequence of the uppercase and lowercase versions of each word in the original array (Anonymous Types).

            string[] words = { "aPPLE", "BlUeBeRrY", "cHeRry" };

            var upperLower = words.Select(w => $"{w.ToUpper()},  {w.ToLower()}");
            foreach(string word in upperLower) Console.WriteLine(word);



            //// 3. Produce a sequence containing some properties of Products, including UnitPrice which is renamed to Price in the resulting type.

            var modefiedProducts = ProductsList.Select(p => new
            {
                ProductID = p.ProductId, p.ProductName, Price = p.UnitPrice
            });



            //// 4. Determine if the value of int in an array match their position in the array.
            ///
            Console.WriteLine("\n");
            int[] intArr = { 5, 4, 1, 3, 9, 8, 6, 7, 2, 0 };

            var valueMatching = intArr.Select((n, I) => $"{n}: {n == I}");
            Console.WriteLine("Number: In-Place?");
            foreach(var value in valueMatching) Console.WriteLine(value);



            //// 5. Returns all pairs of numbers from both arrays such that the number from numbersA is less than the number from numbersB.
            ///

            int[] numbersA = { 0, 2, 4, 5, 6, 8, 9 };
            int[] numbersB = { 1, 3, 5, 7, 8 };

            //var pairs = numbersB.Select(B => B).Where(numbersA.Select(A => $"{A}")

            var pairs = numbersA.SelectMany(a => numbersB, (a, b) => new { A = a, B = b }).
                Where(pair => pair.A < pair.B);

            Console.WriteLine("\nPairs Where A < B: ");
            foreach (var pair in pairs) Console.WriteLine($"{pair.A} is less than {pair.B}");



            //// 6. Select all orders where the order total is less than 500.00.
            ///
            Console.WriteLine("\n");
            var ordersLessThan500 = CustomersList.Select(c => c)
                .SelectMany(cOrders => cOrders.Orders)
                .Where(o => o.Total < 500.00M);

            ordersLessThan500 = from c in CustomersList
                                 from o in c.Orders
                                 where o.Total < 500.00M
                                 select o;


            //foreach (var order in ordersLessThan_500) Console.WriteLine(order);




            //// 7. Select all orders where the order was made in 1998 or later.
            ///

            var ordersMadeAfter1998 = CustomersList.Select(c => c)
                .SelectMany(cOrders => cOrders.Orders)
                .Where(o => o.OrderDate >= new DateTime(1998, 1, 1));


            foreach(var order in ordersMadeAfter1998) Console.WriteLine(order);




            #endregion

        }



    }
}