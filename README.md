# trace-checker
a certifier for the trace SAT format


## Main components
* Prolog theorem proover code: "regular" version can be found in either fpc.pl and foclist.pl
(here the kernel is separated from the portion dealing with the proof evidence from the Trace) or in 
template.pl (here both parts are together). The "ordered" version, that only succeeds when the antecedent list of 
every chain is in the right order, is at in all1.pl
* Translator from Trace to Prolog code: convertTrace2.py has methods to translate a Trace into a Prolog query,
which can be written onto a Prolog file with the checker code. It also provides methods for getting statistical
information about the Trace like longest, average, and median chain lengths; and allows us to manipulate chains (which we use when testing chain permutations).
ConvertTrace2.py is just a set of methods used by other files. If, however, you want to use convertTrace2 directly to 
create Prolog code for a Trace, you can use ctIndependent.py which is identical except it can be run from the command line:
python ctIndependent.py traceFileName prologFileName, which will copy the FPC and Kernel files to prologFileName, then
translate traceFileName to Prolog and write to prologFileName. 
* Wrapper to do Trace translation and then run resulting Prolog file: trace_checker.sh can be called with 
bash trace_checker.sh traceFileName prologFileName, and prints the runtime of the Prolog file as well as the output. 
It prints 1 if the checker confirmed the Trace to be a valid proof for unsatisfiability, 0 otherwise.


##Test Files
There are several files that can be run to test the efficiency of the checker under different conditions.
* notList.sh takes a problem in CNF form, uses the Booleforce SAT solver to generate a Trace, 
creates the appropriate Prolog code using convertTrace2, and outputs some information about the problem to an output file. 
Then a number of different chain permutations are tested and their performance is recorded in the output file. 

To translate a problem and run all permutations of ONLY its longest chain, run the following: 
bash notList.sh $CNFfile all $timeout lex false fpc
changing only the parameters marked by $ to values of your choice. timeout is in seconds and refers to the amount of time
given each test.
Output will be in a file of the same name as $CNFfile in the "performance" directory. Here you can see the orders of the longest 
chain tested in each test. On the line following the permutation is its index (for internal use), success of the test (1 or 0),
and runtime. If the test timed out before it could succeed or fail, the success and runtime will be replaced by "timeout".

To translate a problem and run only some permutations of only its longest chain, run the following:
bash notList.sh $CNFfile $numberPermutations $timeout rand false fpc
This gives the same output as the previous command, but will not check all permutations of the longest chain, unless 
$numerPermutations is larger than the number of permutations there actually are for the longest chain, in which case it will
default to all permutations. In this case, the permutations are generated by a random shuffle and should therefore be a 
representative sample of all possible permuations. 


To translate a problem and try all permutations of all its chains, run the following: 
bash notList.sh $CNFfile all $timeout lex true order
 For this command, the output will be in a file with the same name as CNFfile, in the "performanceNew" directory.
The first column of output is the index of combination tested, which can be used to see how far through all possible combinations 
the program has gotten. The second column is success or failure of Prolog to derive a proof from proof evidence (denoted by 1 or 0).
Prolog will only return 1 when the ordering of all chains is correct, thus out of hundreds of thousands of order combinations,
only a few may succeed. 
Be aware that the number of combinations of permutations to be tested grows very quickly for large problems.

* list1.sh 
For all three version of the command above, you can substitute notList.sh for list1.sh and change $CNFfile to 
the name of a directory with more than 1 cnf file in it, and the program repeats the same processes described above 
for each cnf file in that directory. 

##Summarizing test results
* Because the tests above give a lot of output for medium and large problems, I've added summary files. 
run the following:
python summarize.py $ReportName $outFile
This is intended to take one of the files produced by the commands above and find the best and worst runtimes. 
The output, obviously, is then stored in $outfile.
As a note; currently running this does not tell you the specific chain orders that produced the best and worst runtimes, but 
the program could be easily modified to include this informtion as well. 

* metaSummarize.py was written to summarize the output for tests of multiple different problems that was all stored in the same file;
now. It has no use on any report file that could be produced now, but I might still need it for summarizing previously generated
data, so that's why it's still in the repository. 