#/bin/python

import argparse
import os
import xml.etree.ElementTree
import subprocess
import sys
import shutil
import time
import re

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
rulesMatrix = [["?" for x in range(w)] for y in range(h)] 

def convertToCsv(args):
	cmd = "rm -f "+ args.outputCsvFile
	subprocess.call(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) 
	nextIsConsequent=False
	with open(args.rulesFile) as f:
		lineNum=0
		for line in f:
			if str(line.split('.')[0]).strip().isdigit():
				rule = line.split('.')[1].split('<')[0].strip()
				for s in rule.split(' '):
					if s.endswith("=t"):
						if nextIsConsequent:
							edit=s[:-2]
							rulesMatrix[lineNum][editMap[edit]] = "c"
						else:
							edit=s[:-2]
							rulesMatrix[lineNum][editMap[edit]] = "t"
					if s == "==>":
						nextIsConsequent = True
				ruleInCsv=""
				for i in range(len(rulesMatrix[lineNum])):
					ruleInCsv+= str(rulesMatrix[lineNum][i])+","
				ruleInCsv=ruleInCsv[:-1]
				#print ruleInCsv
				
				#create output csv file
				
				cmd = "echo "+ruleInCsv+ " >> " + args.outputCsvFile
				subprocess.call(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) 
				
				nextIsConsequent=False
				lineNum+=1

def getOptions():
        parser = argparse.ArgumentParser(description="Example of usage: python ARToCSV.py FoldsMutOps/Complement10RulesLB0.001C1NR10000.txt FoldsMutOps/Complement10RulesLB0.001C1NR10000.csv")
        parser.add_argument("rulesFile", help="file with rules")
        parser.add_argument("outputCsvFile", help="output file")
        return parser.parse_args()

def main():
	args=getOptions()
	convertToCsv(args)

main()