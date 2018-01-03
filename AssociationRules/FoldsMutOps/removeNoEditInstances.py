#/bin/python

import argparse
import os
import xml.etree.ElementTree
import subprocess
import sys
import shutil
import time
import re

def removeEmptyOnes(args):
	tmpFile = "Useful"+args.instancesCsvFile
	cmd = "rm "+ str(tmpFile)
	subprocess.call(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) 
	numberOfUselessInstances=0
	numberOfInstances=0
	with open(args.instancesCsvFile) as fIns:
		for lineIns in fIns:
			numOfEdits=0
			numberOfInstances+=1
			for i in range(len(lineIns.strip().split(','))):
				if lineIns.strip().split(',')[i] != '?':
					numOfEdits+=1
			if numOfEdits >= 3 :
				cmd = "echo \""+ str(lineIns.strip())+ "\" >> " + str(tmpFile)
				subprocess.call(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE) 
			else:
				#print "numOfEdits: "+str(numOfEdits)
				#print lineIns
				numberOfUselessInstances+=1
				
	print "numberOfUselessInstances: "+ str(numberOfUselessInstances)
	print "numberOfInstances: "+ str(numberOfInstances)
	
def getOptions():
        parser = argparse.ArgumentParser(description="Example of usage: python removeNoEditInstances.py Fold10.csv")
        parser.add_argument("instancesCsvFile", help="file with instances")
        return parser.parse_args()

def main():
	args=getOptions()
	removeEmptyOnes(args)
	
main()