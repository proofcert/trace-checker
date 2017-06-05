# trace-checker
a certifier for the trace SAT format

Script files: 
runInfo.sh: input is a single .cnf file. Extracts clause and variable numbers from the .cnf file, makes a Trace with Booleforce, 
    strips the path name and extention to make 
    appropriately named trace and prolog files (which are only temporary, and will later be deleted), finds longest derived clause 
    and chain length, runs the prolog file and writes the result along with all the previous information to 'informe'. 
    Timeout is currently set to 5 minutes, this can be changed on line 27.
list.sh: input is a directory with only .cnf files; runs runInfo.sh on each of them.
trace_checker.sh: takes an already created Trace file, translates it to prolog, and runs the result.


testing with different chain lengths: 
chainOrder.py takes arguments trace_name, prolog_name, number of permutations to try, and timeout. 
    It writes results to informeCadena. There's currently an issue where it's not writing things in the right order, 
    but you can still figure out the results. 
    
list1.sh takes the path of a folder of cnf problems, converts them to trace, and runs chainOrder.py on all of them.
Currently it does this with hardwired 10 permutations and 500 seconds before timeout, I can change this. 

Update: now chainOrder.py and list1.sh take an additional argument (added in last place after the rest), that is either the 
a string beginning with "lex" (non caps sensitive, of course) or something else.
If it is "lex", chainOrder.py uses lexicographic generation starting from ascending order to test permutations.
Otherwise chainOrder.py will use the random shuffle generation method. Because we are not yet dealing with huuge chains,
at the moment I am storing previously checked permutations to avoid checking them twice.
However if working on muuch bigger problems than I currently am, this might not be the best idea. 