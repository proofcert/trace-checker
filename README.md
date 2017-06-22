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
chainOrder.py: 
parameters: traceName prologName numPermString timeOut methodString informeFileName allChainsString varNum clauseNum version
traceName -- path to a valid Trace file
prologName -- I usually use TEMP.pl or a variation, so I know to delete it after (the script that calls chainOrder would delete it automatically)
numPermString -- either an integer, number of permutations to be tested, or the string "all" for all permutations
timeOut -- timeout in seconds for each chain order tested
methodString -- "lex" for lexicographic permutation generation, or any other string will result in random shuffle generation.
informeFileName -- again, this parameter is usually managed by a method that calls chainOrder.py. 
    When running chainOrder.py manually, if using the regular, non-fixed order prolog version, please set this to performance/traceName. otherwise set to 
    performanceNew/traceName
allChainsString -- enter "true" or "false"; when this is true, python will test all combinations of all permutations for all chains.
    when false, it will test only permutations of the longest chain.
varNum and clauseNum -- these are only for use when chainOrder is called by another method. you can set them both as None
version -- manages the version of prolog code used in the tests.
    can be "fpc", "order", or "template."
    fpc means the combination of the most recent focSep.pl and fpc.pl files. 
    "order" means all1.pl, the current latest file that tests with fixed order chains.
    "template" refers to the original, non-separated prolog file. I've kept it as an option mainly for debugging, as 
    it works reliably and can be used to figure out what's wrong with the other files. 
For all permutations of a problem you can call the following, changing just the part in all caps: 
python chainOrder.py TRACENAME TEMP.pl all 30 lex performance/TRACENAME false none none fpc

For all combinations of all permutations of all chains, an example that currently doesn't work on any combination, run the following:
python chainOrder.py comp TEMP.pl all 30 lex performanceNew/comp true none none order


list1.sh takes the path of a folder of cnf problems, converts them to trace, and runs chainOrder.py on all of them.
To run overnight: 
bash list1.sh problems/report/notSmall 400 300 rand false fpc



Update: now chainOrder.py and list1.sh take an additional argument (added in last place after the rest), that is either the 
a string beginning with "lex" (non caps sensitive, of course) or something else.
If it is "lex", chainOrder.py uses lexicographic generation starting from ascending order to test permutations.
Otherwise chainOrder.py will use the random shuffle generation method. Because we are not yet dealing with huuge chains,
at the moment I am storing previously checked permutations to avoid checking them twice.
However if working on muuch bigger problems than I currently am, this might not be the best idea. 