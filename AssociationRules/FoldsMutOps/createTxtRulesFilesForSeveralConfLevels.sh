#!/bin/bash

for confidence in 0.5 0.6 0.7 0.8 0.9 1
do
	#cmdRM="rm -f ComplementRulesLB0.001C"$confidence"NR10000/*"
	#echo $cmdRM
	#eval $cmdRM
	
    for (( complement=1; complement<=10; complement++))
	do
		#cmd="java -cp ../weka-3-8-1/weka-3-8-1/weka.jar weka.associations.Apriori -N 10000 -T 0 -C $confidence -M 0.001 -t Complement"$complement".arff > ComplementRulesLB0.001C"$confidence"NR10000/Complement"$complement"RulesLB0.001C"$confidence"NR10000.txt"
		#echo $cmd
		#eval $cmd
		
		#cmd2="python ARToCSV.py ComplementRulesLB0.001C"$confidence"NR10000/Complement"$complement"RulesLB0.001C"$confidence"NR10000.txt ComplementRulesLB0.001C"$confidence"NR10000/Complement"$complement"RulesLB0.001C"$confidence"NR10000.csv"
		#echo $cmd2
		#eval $cmd2
		
		cmd="python getRuleAccuracy.py ComplementRulesLB0.001C"$confidence"NR10000/Complement"$complement"RulesLB0.001C"$confidence"NR10000.csv UsefulFold"$complement".csv >> 10foldXVal.csv"
		cmd2="echo "$cmd" >> 10foldXVal.csv"
		eval $cmd2
		eval $cmd
		
	done
done
