### Run

    sudo chicken-install args
    csc run.scm
    ./run

### Tests

    sudo chicken-install test
    csc test.scm
    ./test

### Project idea

To build a program that implements a genetic algorithm to solve a numbers problem.

This should be a simple problem to solve but should allow a framework to scale it to larger problems.

SBS used to run a show called "Letters and Numbers". The trick was you had to use given numbers and then use arithmetic to derive a given random number.

The numbers segment had this format:
- Players choose 6 numbers to use with arithmetic
- The target number is a random 3-digit number
- Large numbers include 25, 50, 75, 100
- Small numbers include 1:10 inclusive
- One of each number may be chosen

For example, if the target number is 525 and the 6 chosen numbers are 2,5,7,10,25,75, then a solution that is somewhat close would be:

    (75*10)-(25*5*2)+7 = 507

There are probably better solutions, but why not get software to do this for me?

It would be interesting to see if:
- The GA approach makes sense
- The solution can be found faster than by using a brute-force method

#### Further ideas

This project will only generate algorithms of a fixed length. It would be good to not include all numbers as an option.

For example if you have 6 numbers, then the binary expression tree will have 5 operators. If you make the naive assumption that all permutations are possible, then the number of permutations is (in the area of) ```11! = 39,916,800```. You would further increase the numbers of solutions by allowing solutions with fewer numbers: ```11! + 9! + 7! + 5! + 3! + 1! = 40284847```, but of course the before-mentioned assumption is wrong and the actual numbers are lower than the roughly ```40``` million number suggested above.

You could potentially allow for solutions with fewer numbers by removing a branches from trees by replacing them with symbols, and then just neglect to evaluate the symbol during the fitness function. Then you could rearrange the symbol and even reintroduce those removed terms if you want to.

It would be useful to not have to do anything twice. When generating an algorithm, why not create a string representation and then put that in a hash table. When the table reaches the theoretical maximum size then the solution space is exhausted. Hopefully this won't be needed and the solution will perform better than brute-force method

#### Some interesting results from real humans

https://www.youtube.com/watch?v=pfa3MHLLSWI
https://www.youtube.com/watch?v=_JQYYz92-Uk

#### Evolution!

It would probably be most useful to train a ML algorithm to do this. But it would be more interesting (to me) to make a genetic algorithm.

Here's the process:
- Pass this program the target number and numbers to use
- Generate some functions (as in a maths function) that operate on the numbers using the binary operators (+,-,*,/)
- For each function measure its fitness in a greedy, naive way: how far is it from the target
- Select the best of those and let them breed a-sexually

### Choice of language

I think Scheme (Lisp) is the most appropriate, for a few reasons:
- Functions are first-class citizens and can be stored in lists for use later.
- Linked lists are the standard data type and this project uses insertion and swaps etc. This is faster than using arrays.
- Chicken Scheme compiles rather than requiring an interpreter, which I think MIT Scheme does.

### Licence

MIT Licence
