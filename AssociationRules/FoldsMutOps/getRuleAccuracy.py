#/bin/python

import argparse
import os
import xml.etree.ElementTree
import subprocess
import sys
import shutil
import time
import re

fullyCoveredInstances=0
partiallyCoveredInstances=0
nonCoveredInstances=0
instanceCount=0
ruleCount=0

w,h = 19,100000
editMap = {
"Replacements":0, 
"Append":1,
"Delete":2,
"Template1":3,
"Template2":4,
"Template3":5,
"Template4":6,
"Template5":7,
"Template6":8,
"Template7":9,
"Template8":10,
"Template9":11,
"Template10":12,
"Template11":13,
"Template12":14,
"Template13":15,
"Template14":16,
"Template15":17,
"Template16":18
}
rulesMatrix = [['?' for x in range(w)] for y in range(h)] 

def getStats(args):

	global fullyCoveredInstances
	global partiallyCoveredInstances
	global nonCoveredInstances
	global instanceCount
	global ruleCount
	#cmd = "rm -f "+ args.outputCsvFile
	#subprocess.call(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) 
	
	with open(args.instancesCsvFile) as fIns:
		for lineIns in fIns:
			ruleCount=0
			#print "\nINSTANCE: "
			#print str(lineIns.strip())
			coveredEdits = [0 for x in range(w)]
			numberOfEditsInInstance = 0
			for i in range(len(lineIns.strip().split(','))):
				if lineIns.strip().split(',')[i] != '?':
					numberOfEditsInInstance+=1
				
			with open(args.rulesCsvFile) as fRules:
				for lineRules in fRules:
					
					lineApplies=True
					for i in range(len(lineRules.strip().split(','))):
						if lineRules.strip().split(',')[i] != '?' and lineIns.strip().split(',')[i] == '?':
							#print "Rule Doesnt Apply: instance: "+str(lineIns) +" rule: "+ str(lineRules)
							lineApplies=False
							break
					if lineApplies:
						#print "Applies! rule: "+ str(lineRules.strip())
						for i in range(len(lineRules.strip().split(','))):
							if lineRules.strip().split(',')[i] != '?':
								coveredEdits[i] = 1
					#lineApplies=True
					ruleCount+=1
					
			#evaluate if all edits were covered
			numberOfEditsCovered=0
			for i in range(len(lineIns.strip().split(','))):
				if coveredEdits[i] == 1:
					numberOfEditsCovered+=1
			
			#print "Edits in instance: "+str(numberOfEditsInInstance) + " How many edits are covered by the rules: " +str(numberOfEditsCovered) 
			if numberOfEditsCovered==0:
				nonCoveredInstances+=1
				#print "Non covered"
			elif numberOfEditsCovered == numberOfEditsInInstance:
				fullyCoveredInstances+=1
				#print "Fully covered"
			else:
				partiallyCoveredInstances+=1
				#print "Partially covered"
				
			instanceCount+=1

def getOptions():
        parser = argparse.ArgumentParser(description="Example of usage: python getRuleAccuracy.py ComplementRulesLB0.001C1NR10000/Complement10RulesLB0.001C1NR10000.csv UsefulFold10.csv")
        parser.add_argument("rulesCsvFile", help="file with rules")
        parser.add_argument("instancesCsvFile", help="file with instances")
        return parser.parse_args()

def main():
	args=getOptions()
	getStats(args)
	print "fullyCoveredInstances," + str(fullyCoveredInstances)
	print "partiallyCoveredInstances," + str(partiallyCoveredInstances)
	print "nonCoveredInstances," + str(nonCoveredInstances)
	print "instanceCount," + str(instanceCount)
	print "ruleCount," + str(ruleCount)

main()