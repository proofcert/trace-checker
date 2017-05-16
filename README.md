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