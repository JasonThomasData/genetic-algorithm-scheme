### Run

Get the compiler at ```http://code.call-cc.org/releases/current/```

    sudo chicken-install args
    csc run.scm
    ./run

### Tests

    sudo chicken-install test
    csc test.scm
    ./test

### Project idea

SBS used to run a show called "Letters and Numbers". The trick was you had to use given numbers and then use arithmetic to derive a given random number.

The numbers segment had this format:
- Players choose 6 numbers to use with arithmetic
- The target number is a random 3-digit number
- Large numbers include 25, 50, 75, 100
- Small numbers include 1:10 inclusive
- One of each number may be chosen

For example, if the target number is 525 and the 6 chosen numbers are 2,5,7,10,25,75, then a solution that is somewhat close would be:

    (75*10)-(25*5*2)+7 = 507

This project seeks to solve these problems.

Here's the process:

- Pass target number and numbers to use to the program
- Generate some binary-expression-trees that operate on the numbers using the binary operators (+,-,*,/)
- Then:
    - For each tree measure its fitness in a greedy, naive way: how far is it from the target. This means the solution will reach local optimums
    - Select the best of those and let them breed a-sexually. This is achieved by copying those more-fit algorithms and then applying a mutation to each copy.
    - Then kill off half the population.

### Example

Running:

    ./run --small 1,4,5,6 \
          --large 25,50 \
          --target 400 \
          --pop 20 \
          --gen 125 \
          -e

Produces different results:

Three attempts after 125 generations:

    Tree: / + 6 + 25 / 1 5 / 4 50 
    Evaluation: 390
    Error: 10

    Tree: * - + 25 6 - - 4 50 1 5 
    Evaluation: 390
    Error: 10

    Tree: * + 25 - 50 + 5 - 4 1 6 
    Evaluation: 402
    Error: 2

And this one reaches a desirable result before the others at just 14 generations:

    Tree: + 25 * 50 / 5 / 1 / 6 4 
    Evaluation: 400
    Error: 0

The genetic programming approach means that the process is greedy and won't necessarily reach the global optimum. Often the program will reach and then get stuck at some kind of local optimum.

#### Further ideas

This project will only generate algorithms of a fixed length. It would be good to not include all numbers as an option.

For example if you have 6 numbers, then the binary expression tree will have 5 operators. If you make the naive assumption that all permutations are possible, then the number of permutations is (in the area of) ```11! = 39,916,800```. You would further increase the numbers of solutions by allowing solutions with fewer numbers: ```11! + 9! + 7! + 5! + 3! + 1! = 40284847```, but of course the before-mentioned assumption is wrong and the actual numbers are lower than the roughly ```40``` million number suggested above.

You could potentially allow for solutions with fewer numbers by removing a branches from trees by replacing them with symbols, and then just neglect to evaluate the symbol during the fitness function. Then you could rearrange the symbol and even reintroduce those removed terms if you want to.

It would be useful to not have to do anything twice. When generating an algorithm, why not create a string representation and then put that in a hash table. When the table reaches the theoretical maximum size then the solution space is exhausted. Hopefully this won't be needed and the solution will perform better than brute-force method.

It would be interesting to see the progress over time, so you could take the error of the top-performing tree/algorithm in each generation and then plot that against the number of generations. 

#### Some interesting results from real humans

https://www.youtube.com/watch?v=pfa3MHLLSWI
https://www.youtube.com/watch?v=_JQYYz92-Uk

### Choice of language

I think Scheme (Lisp) is the most appropriate, for a few reasons:
- Functions are first-class citizens and can be stored in lists for use later.
- Linked lists are the standard data type and this project uses insertion and swaps etc. This is faster than using arrays.
- Chicken Scheme compiles rather than requiring an interpreter, which I think MIT Scheme does.
- Scheme handles functions in a way very similar to how binary expression trees are written, eg: (+ 1 2) is a Scheme function but also ```+ 1 2``` is a tree with two leaf nodes. This is easy to recursively evaluate.

### Licence

MIT Licence
