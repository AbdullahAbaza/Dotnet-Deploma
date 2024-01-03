
using Demo.Files;
using System.Text.RegularExpressions;
using static Demo.Files.ListGenerator;

namespace Demo
{
    internal class Program
    {
        static void Main()
        {

            #region Implicitly Typed Local Variable [ var , dynamic ]
            {
                // local variable between { } accessed only within it's scope
                // implicitly typed --> CLR responsiple for knowing the type
            }

            var name = "Abdullah";
            // Compiler will detect the variable dataType based on its initial value ->> In compilation time
            // Must be Initialized 
            // Cann't be initialized with Null 
            // After Initialization, we Can't Change the Variable DataType  
            name = null;

            // Dynamic --> can be thought of as var in JS
            // CLR Will Detect the Variablr Datatype based on its Last Assigned Value in Runtime.
            // May Not be Initialized
            // Can be Initialized with null
            // After Initialization, we Can Change The Variable Datatype
            dynamic name2;
            dynamic name3 = null;
            name3 = "Abdo";
            name3 = 100;



            #endregion

            #region Extention Method
            int x = 12345;
            int y = IntExtentions.Reverse(x);

            y = x.Reverse();

            Console.WriteLine(y);


            #endregion

            #region Anonymous Type --> if i want to create an object from an unknown datatype
            //Employee Emp1 = new Employee() { Id = 1, Name = "Abdullah", Salary = 5000 };

            var emp1 = new { Id = 1, Name = "Abdullah", Salary = 5_000 };

            var emp2 = new { Id = 2, Name = "Osama", Salary = 3_000.0 };
            // The Same AnonymousType As Long As:
            // 1. The Same Properties Naming [Case Sensetive]
            // 2. The Same Properties Order

            Console.WriteLine(emp1.GetType().Name, "ToString: ", emp1.ToString());
            Console.WriteLine(emp2.GetType().Name, "ToString: ", emp2.ToString()); // <>f_AnonymousType0`3 --> 3 attributes

            // The Object that Created from AnonymousType => Is an Immutable Object [Can't Be Changed]
            //Emp2.Id = 3; // Invalid
            emp2 = new { Id = 3, Name = emp2.Name, Salary = emp2.Salary };
            emp2 = emp2 with { Id = 4 }; // C# 10.0 Feature int .Net 6.0 (2021)

            // Func<double, double> Salary_Raise = (Salary) => Salary += Salary * 0.1;
            var salaryRaiseFunc = (double salary) => salary += salary * 0.1;

            var emp3 = new { Id = 1, Name = "Abdullah", Salary = 5_000, SalaryRaise = salaryRaiseFunc };

            Console.WriteLine(emp3.SalaryRaise(emp3.Salary));


            #endregion


            #region  LINQ Intro
            //LINQ --> Language Integrated Query --> SQL DQL -> Integrated [implemented] in C#
            // LINQ : +40 Extention Methods [For All Collections --> Implementing Built-In Interface "IEnumerable"]
            //      :: Named As [LINQ Operators] 
            //      :: and Categorized into 13 Categories

            // We Use LINQ Operators against Data(Stored in a Sequence), Regardless Data Store (SQL  Server, Oracle, Postgres, etc...)
            // Sequence : the object created from class Implementing IEnumerable interface like[Array, List, Dictionary]
            //  1. Local Sequence --> Data inside program or from XML file : [L2O, L2XML]
            //  2. Remote Sequence --> data coming from remote connection :  [L2EF]


            List<int> numbers = Enumerable.Range(0, 100).ToList(); //List<T> implements IReadOnlyList<T> which implements IEnumerable 
                                                                   //List<int> OddNumbers = Numbers.Where( (N) => N % 2 == 1).ToList();

            var oddNumbers = numbers.Where((n) => n % 2 == 1);

            //foreach(int odd in OddNumbers) // foreach can iterate over IEnumerable Type
            //    Console.Write($"{odd}, ");
            //Console.WriteLine();

            #endregion


            #region LINQ Syntax [Fluent Syntax (C#), Query Syntax]
            // 1. Fluent Syntax
            // 1.1 Use LINQ Operator as => static method through "Enumerable" Class

            var evenNumbers = Enumerable.Where(numbers, (n) => n % 2 == 0);
            Console.WriteLine("\nEvenNumbers: ");
            foreach (int even in evenNumbers)
                Console.Write($"{even}, ");

            Console.WriteLine("\n");

            // 1.2 Use LINQ Operator as => Extention Method [Recommended]

            var divisableBySeven = numbers.Where((n) => n % 7 == 0);
            Console.WriteLine("\nDivisable By Seven");
            foreach (int seven in divisableBySeven)
                Console.Write($"{seven}, ");

            Console.WriteLine("\n");

            // 2. Query Syntax: Query Expression (like SQL server style)
            // Start with keyword "From", introducing Range Variable(N): Represents each element in the sequence 
            // End with "Select" or "GroupBy"


            /*
             *  Select N
             *  From Numbers 
             *  Where N % 3 == 0;
             */

            var divByThree = from n in numbers // [More Readable]
                             where n % 3 == 0
                             select n;

            Console.WriteLine("Div By Three: ");
            foreach (int three in divByThree)
                Console.Write($"{three}, ");

            Console.WriteLine("\n");



            #endregion

            #region LINQ Excution Ways [Differed, Immediate]
     
            // 1. Differed Excution  ( 10 categories ): (Latest Version Of data when accessed)

            List<int> numbersToTen = new List<int>() { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };

            var oddNums = numbersToTen.Where((n) => n % 2 == 1);

            numbersToTen.AddRange(new int[] { 11, 22, 13, 14, 15 });

            Console.WriteLine("\nDiffered Excution: "); 
            foreach(int odd in oddNums)
                Console.Write($"{odd}, ");


            // 2. Immediate Excution: ( Elements Operator, Casting Operator, Aggregate Operators)

            var evenNums = numbersToTen.Where((n) => n % 2 == 0).ToList(); // Casting Operator -->  2,4,6,8,10,12,14

            var last = evenNums.Last(); // Element Operator --> 14
            Console.WriteLine($"\nLastElement: {last}");
            var count = evenNums.Count(); // Aggregate Operator --> 7
            Console.WriteLine($"CountElements: {count}");

            numbersToTen.AddRange(new int[] {16, 17, 18, 19 , 20});

            Console.WriteLine("\nImmediate Excution: ");
            foreach (int even in evenNums)
                Console.Write($"{even}, ");

            #endregion

            #region LINQ test loading data
            Console.WriteLine("\n================================================================\n");

            Console.WriteLine(ProductsList[0]);
            Console.WriteLine(CustomersList[0]);

            #endregion

            #region Filteration (Restriction) Operators - Where

            //Console.WriteLine("\n================== Products With No Stock ====================");

            //// Fluent Syntax
            var outOfStock = ProductsList.Where((x) => x.UnitsInStock == 0);

            //// Query Syntax
            outOfStock = from p in ProductsList
                             where p.UnitsInStock == 0
                             select p;

            //foreach (var item in OutOfStock)
            //    Console.WriteLine(item);

            Console.WriteLine("\n======================= Products In Meat Category And Has Stock ===================");

            var inStockMeat = ProductsList.Where((p) => p.UnitsInStock != 0 && p.Category == "Meat/Poultry");

            inStockMeat = from p in ProductsList
                                 where p.UnitsInStock > 0
                                 && p.Category == "Meat/Poultry"
                                 select p;

            //foreach (var item in  InStockMeat)
            //    Console.WriteLine(item);


            // Indexed Where
            // [valid only in fluent syntax]. Cann't be written using Query Expression.

            // Get from the first 10 products, the products that are outofstock
            var inStockMeatIndexed = ProductsList.Where((p, index) =>
            index < 10 && p.UnitsInStock == 0);

            foreach (var product in inStockMeatIndexed)
                Console.WriteLine(product);

            #endregion

            #region Transformation (Projection) Operators - Select / SelectMany

            Console.WriteLine("\n=================Select / Select Many ====================");
            // select
            var productNames = ProductsList.Select((p) => p.ProductName);
            // Query Expression
            productNames = from p in ProductsList
                        select p.ProductName;
            //foreach(var item in ProductNames) Console.WriteLine( item);


            // SelectMany
            var orders = CustomersList.SelectMany(c => c.Orders);

            orders = from c in CustomersList
                     from o in c.Orders
                     select o;

            //var ProductWithId = ProductsList.Select(
            //    P => new Product { ProductID = P.ProductID, ProductName = P.ProductName });

            // return an object from anonymous type

            var productWithId = ProductsList.Select(
                p => new { Id = p.ProductId, Name = p.ProductName });

            productWithId = from p in  ProductsList
                select new { Id = p.ProductId, Name = p.ProductName };



            // get products in stock an apply a discount on price
            var discountedList = ProductsList.Where(p => p.UnitsInStock > 0)
                                            .Select(p => new 
                                            {
                                                Id = p.ProductId,
                                                Name = p.ProductName,
                                                NewPrice = p.UnitPrice - (p.UnitPrice * 0.1M)
                                            });

            discountedList = from p in ProductsList 
            where p.UnitsInStock > 0 
            select new {
                Id = p.ProductId, Name = p.ProductName, NewPrice = p.UnitPrice - (p.UnitPrice * 0.1M)
            };



            // Indexed Select --> Valid Only with Fluent Syntax
            var discountListWithIndex = ProductsList.Where(p => p.UnitsInStock > 0)
            .Select((p, I) =>  new {
                Index = I, Name = p.ProductName
            });


            // foreach (var item in DiscountListWithIndex) Console.WriteLine(item);



            #endregion

            #region Ordering Operators

            // Order By Num Items in stock Asc
            var orderedProducts = ProductsList.OrderBy(p => p.UnitsInStock); //ASC
            
            orderedProducts = ProductsList.OrderByDescending(p => p.UnitsInStock); //DESC

            orderedProducts = from p in ProductsList 
                            orderby p.UnitsInStock descending
                            select p;
                            
            var orderedProductsByUnitsThenPrice = ProductsList.OrderBy(p => p.UnitsInStock)
            .ThenByDescending(p => p.UnitPrice);

            orderedProductsByUnitsThenPrice = from p in ProductsList 
            orderby p.UnitsInStock ascending, p.UnitPrice descending 
            select p;


            var outOfStockReversed = ProductsList.Where(p => p.UnitsInStock == 0).Reverse();



            #endregion

            #region Element Operators --> Immediate Execution [Fluent Syntax]

            Console.WriteLine("\n=================== Element Operators ==============");
            var firstProduct = ProductsList.First();
            Console.WriteLine($"First: {firstProduct?.ProductName ?? "NA"}");

            var lastProduct = ProductsList.Last();
            Console.WriteLine($"Last: {lastProduct?.ProductName ?? "NA"}");

            var emptyList = new List<Product>();
            var result = emptyList.LastOrDefault();
            Console.WriteLine(result?.ProductName ?? "NA");


            var lastOutOfStock = ProductsList.LastOrDefault(p => p.UnitsInStock == 0);
            Console.WriteLine(lastOutOfStock?.ProductName ?? "NA");


            // ==> (Predicate, DefualtValue) 
            var firstOutOfStockDefualtValue = ProductsList.FirstOrDefault(
                p => p.UnitsInStock == 0 && p.UnitPrice > 1000M,
                /* Defualt value */ new Product()
                ); 


            // ==> Element At Index
            result = ProductsList.ElementAtOrDefault(new Index(1000));
            result = ProductsList.ElementAtOrDefault(1000); // same

            var singleProduct = new List<Product>() { ProductsList[0] };
            var isSingle = singleProduct.Single();

            //// If Sequence Contains Just Only One Element, it will return it
            //// Else will Throw Exeception (Sequence is Empty Or Contains More than One Element)

            // is_Single = ProductsList.SingleOrDefault(); -> will throw exception
            // is_Single = ProductsList.SingleOrDefault(new Product() { ProductName = "Hamada"} );

            //// will throw Execption  when Contains More than One Element


            result = ProductsList.SingleOrDefault(p => p.ProductId == 1);


            // Hybrid Syntax: (QueryExpression).FluentSyntax
            result = (from p in ProductsList
                      where p.UnitsInStock == 0
                      select p).FirstOrDefault();

            Console.WriteLine(result?.ProductName ?? "NA");

            #endregion


            #region Aggregate Operators - Immediate Execution 

            Console.WriteLine("\n================ Aggregate Operators =============");

            int countProducts = ProductsList.Count(); // LINQ Extenstion Method
            countProducts = ProductsList.Count; // List Property

            countProducts = ProductsList.Where(p => p.UnitsInStock == 0).Count();
            countProducts = ProductsList.Count(p => p.UnitsInStock == 0);

            var productWithMaxPrice = ProductsList.Max();
            //  Object Must Implement IComparable<T>
            //  
            productWithMaxPrice = ProductsList.OrderByDescending(p => p.UnitPrice).FirstOrDefault(); // here i specify how to compare

            // MaxBy(): C# 10.0 -> NEW Feature (.NET 6)
            // 
            productWithMaxPrice = ProductsList.MaxBy(p => p.UnitPrice);


            // MinBy()
            var productWithMaxUnitsInstock = ProductsList.MaxBy(p => p.UnitsInStock);


            int? minLength = ProductsList.Min(p => p.ProductName.Length);

            minLength = ProductsList.MinBy(p => p.ProductName)?.ProductName.Length;

            minLength = ProductsList?.OrderBy(p => p.ProductName.Length)?.FirstOrDefault()?.ProductName?.Length;



            Console.WriteLine("\n================ Max/Min Comparer ==============");
            // Max(), Min() that accepts an object from a class that implements IComparer interface 
            // 

            productWithMaxUnitsInstock = ProductsList.Max(new UnitsInStockComparer());

            var productWithMinUnitsInstock = ProductsList.Min(new UnitsInStockComparer());

            Console.WriteLine(productWithMaxUnitsInstock); // -> Max

            Console.WriteLine(productWithMinUnitsInstock); // -> Min
            Console.WriteLine("\n=======================================");



            // HybridSyntax --> (Query Syntax).FluentSyntax
            //
            result = ( from p in ProductsList
                       where p.ProductName.Length == minLength
                       select p).FirstOrDefault();


            decimal sumPrices = ProductsList.Sum(p => p.UnitPrice);
            decimal avgPrices = ProductsList.Average(p => p.UnitPrice);

            Console.WriteLine(sumPrices);
            Console.WriteLine(avgPrices);

            Console.WriteLine(result?.ProductName);


            //Aggregate : used in specification design pattern

            string[] nameArray = { "Abdullah", "Osama", "Salem", "Abaza" };
            string fullName = nameArray.Aggregate((str1, str2) => $"{str1} {str2}");

            Console.WriteLine(fullName);


            #endregion


            #region Casting Operators - Immediate Execution
            Console.WriteLine("\n=============== Casting Operator ================");

            List<Product> listProd = ProductsList.Where(p => p.UnitsInStock == 0).ToList();
            Product[] arrayProd = ProductsList.Where(p => p.UnitsInStock == 0).ToArray();

            Dictionary<long, Product> dictProd = ProductsList.Where(p => p.UnitsInStock == 0).ToDictionary(p => p.ProductId); 
            
            Dictionary<long, string> dictProdIdNames = ProductsList.Where(p => p.UnitsInStock == 0).ToDictionary(p => p.ProductId, p => p.ProductName);


            HashSet<Product> setProd = ProductsList.Where(p => p.UnitsInStock == 0).ToHashSet();



            foreach(var kv in setProd)
                Console.WriteLine(kv);




            #endregion


            #region Generation Operators
            // The Only Way For Calling These Operators is => as Static Method Through "Enumerable" Class

            Console.WriteLine("\n===============================================");

            var range100 = Enumerable.Range(0, 100);

            var repeat100 = Enumerable.Repeat(new Product(), 100);

            repeat100 = Enumerable.Empty<Product>();


            #endregion


            #region Set Operators - Union Family

            //var seq1 = Enumerable.Range(0, 100);
            //var seq2 = Enumerable.Range(50, 100); // 0 .. 149

            //var union = seq1.Union(seq2); // 0 ... 149 no duplicates

            //var concat = seq1.Concat(seq2); // 0 ...99..50 ..149

            //var distinct = concat.Distinct(); // remove duplicates

            //var except = seq1.Except(seq2); // 0 .. 49


            // new Approch To view Set Operators

            var seq1 = new List<Product>() {
                new Product() {ProductId = 1, ProductName = "Hamada"},
                new Product() {ProductId = 1, ProductName = "Chaixxxxxxxxx", Category = "Beverages",
                    UnitPrice = 18.00M, UnitsInStock = 100},
                new Product{ ProductId = 2, ProductName = "Chang", Category = "Beverages",
                UnitPrice = 19.0000M, UnitsInStock = 17 },
                new Product{ ProductId = 3, ProductName = "Aniseed Syrup", Category = "Condiments",
                UnitPrice = 10.0000M, UnitsInStock = 13 },
            };

            var seq2 = new List<Product>() {
                new Product() {ProductId = 1, ProductName = "Chai", Category = "Beverages",
                    UnitPrice = 18.00M, UnitsInStock = 100},
                new Product{ ProductId = 5, ProductName = "Chef Anton's Gumbo Mix", Category = "Condiments",
                UnitPrice = 21.3500M, UnitsInStock = 0 },
                new Product{ ProductId = 6, ProductName = "Grandma's Boysenberry Spread", Category = "Condiments",
                UnitPrice = 25.0000M, UnitsInStock = 120 },
            };


            var union = seq1.Union(seq2); // check using Equals() --> so we must ovverride
                                          // other wise it compares addresses

            union = seq1.Union(seq2, new MyEqualityComparer());


            // UnionBy, IntersectBy, DistinctBy, ExceptBy, ---> .Net 6.0 feature

            union = seq1.UnionBy(seq2, P => P.ProductId);


            var intersect = seq1.Intersect(seq2);
            intersect = seq1.Intersect(seq2, new MyEqualityComparer());

            intersect = seq1.IntersectBy(seq2.Select(p => p.ProductId) , p => p.ProductId);


            var distinct = seq1.Distinct(new MyEqualityComparer());

            distinct = seq1.DistinctBy(P => P.ProductId);


            var except = seq1.Except(seq2); // 1, 1, 2, 3
            except = seq1.Except(seq2, new MyEqualityComparer()); // 2, 3 

            except = seq1.ExceptBy(seq2.Select(P => P.ProductId) , P => P.ProductId);



            #endregion


            #region Quantifier Operators --> Return Boolean


            Console.WriteLine(

                //ProductsList.Any() // returens true if sequence contains at least one element

                // Any ==> Like Exists() in List<T> generic collections
                //ProductsList.Any( P => P.UnitsInStock == 0) // true if seq contains at least one element matched the condition

                //ProductsList.All(P => P.UnitPrice > 0)  // like --> TrueForAll()

                //seq1.TrueForAll(P => P.UnitsInStock > 0)

                //seq1.SequenceEqual(seq2)
                seq1.SequenceEqual(seq2, new MyEqualityComparer() )

                ); 


            List<int> num = new List<int> { 1, 2, 3, 4, 5, 6 };
            bool res =  num.Exists(n => n == 0);
            res = num.TrueForAll(n => n == 0);



            #endregion

            #region Zipping Operator

            List<string> Words = new List<string> { "Ten", "Twenty", "Thirty", "Fourty" };
            int[] Numbers = { 10, 20, 30, 40, 50, 60 };

            var zippedList = Words.Zip(Numbers, (word, number) => $"{number} - {word}"); ; // 10 -Ten


            #endregion

            #region Grouping Operators
            // List of List , or Array of Groups
            var Categories = from P in ProductsList // return => IEnumerable<IGrouping<string, Product>>
                             group P by P.Category;

            Categories = ProductsList.GroupBy(P => P.Category);



            // Products in stock --> GroupBy(category) --> C.Count(Prod) > 10 -->  C.name , C.count(p)

            //var categoriesInStock = ProductsList.Where(P => P.UnitsInStock > 0)
            //    .GroupBy(P => P.Category)
            //    .Where(category => category.Count() > 10);


            //foreach (var category in categoriesInStock)
            //{
            //    Console.WriteLine(category.Key);
            //    foreach (var product in category)
            //    {
            //        Console.WriteLine($"...............{product}");
            //    }
            //}


            var categoriesInStock = from P in ProductsList
                                    where P.UnitsInStock > 0
                                    group P by P.Category
                         into category
                                    where category.Count() > 10
                                    select new
                                    {
                                        CategoryName = category.Key,
                                        ProductCount = category.Count()
                                    };

            categoriesInStock = ProductsList.Where(P => P.UnitsInStock > 0)
                .GroupBy(P => P.Category)
                .Where(category => category.Count() > 10)
                .Select(category => new
                {
                    CategoryName = category.Key,
                    ProductCount = category.Count()
                });





            #endregion


            #region Partitioning Operators - Take, TakeLast, Skip, SkipLast, TakeWhile, SkipWile

            // used in Pagination in applications

            // First 5 prods out of stock

            var take = ProductsList.Where(P => P.UnitsInStock == 0).Take(5);
            take = ProductsList.Where(P => P.UnitsInStock == 0).Take(new Range(1, 4)); // take using index in range
            var takeLast = ProductsList.Where(P => P.UnitsInStock == 0).TakeLast(5);

            var skip = ProductsList.Where(P => P.UnitsInStock == 0).Skip(3);

            var skipLast = ProductsList.Where(P => P.UnitsInStock == 0).SkipLast(3);

            int[] Nums = { 5, 4, 1, 3, 9, 8, 6, 7, 2, 0 };
            // starting from 0 take the element as long as  > its position

            var takeWhile = Nums.TakeWhile((Number, Index) => Number > Index);

            // skip as long as element in not divisable By 3

            var skipWhile = Nums.SkipWhile(Number => Number % 3 != 0);

            //foreach(int i in skipWhile) Console.WriteLine(i);


            #endregion


            #region let / into

            // Remove Vowls  [aeiouAEIOU] ==> RegularExpression RE
            List<string> Names = new List<string>() { "Ahmed", "Mona", "Mahmoud", "Moamen", "Sally" };

            var noVowls = from N in Names
                          select Regex.Replace(N, "[aeiouAEIOU]", string.Empty) // will no affect Names[]
                          // into : Restart Query With Introducing New Range Variable
                          into noVolName
                          where noVolName.Length > 3
                          select noVolName;

            noVowls = from N in Names
                      let noVol = Regex.Replace(N, "[aeiouAEIOU]", "")
                      // let : Continue Query With Adding New Range Variable(noVol)
                      where noVol.Length > 3
                      select noVol;

            noVowls = Names.Select(N => Regex.Replace(N, "[aeiouAEIOU]", "") )
                .Where(noVol => noVol.Length > 3);


            #endregion


            foreach (var item in noVowls)
                Console.WriteLine(item);





        }
    }
}