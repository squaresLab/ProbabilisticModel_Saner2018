#!/usr/bin/python


#This file exports the commits before and after finding the word fix in the 
#git logs.
#check that the before and after commit outputs are correct. Reading through the file, it seems like I may have switched them for some reason.

import sys
import re

def main(argv=None):
  if len(sys.argv) != 3:
    print "Usage: file_to_read_from output_file_name"
    print "len: ",len(sys.argv)
  else:
    fixCount=0
    totalCount=0
    containsAFixBool = True
    afterIsWaitingForABefore = False
    pattern = re.compile('[Ff]ix(ed|es|ing)?(\s)*([Bb]ug|[Ii]ssue|[Pp]roblem)?(s)?') # - used for gzip, also for libtiff
    #pattern = re.compile('([Bb]ug|[Ii]ssue)(s)?')
    #pattern = re.compile('#\d+')
    #pattern = re.compile('[Bb]ug #\d+')
    #pattern = re.compile('[Ff]ix(ed|es|ing)? [Bb]ug #\d+') # - used for php
    fin = open(sys.argv[1],'r')
    fout = open(sys.argv[2],'w')
    hashArray = []
    for line in fin:
      commitSearch = re.search('commit (.*)',line)
      if commitSearch:
        totalCount=1+totalCount
        commitName = commitSearch.group(1)
        if containsAFixBool and ' ' not in commitName and len(commitName) ==40:
          #containsAFixBool = False
          
          if afterIsWaitingForABefore:
            hashArray.append(commitName+" "+lastCommitFound+"\n")
            afterIsWaitingForABefore = False            
          lastCommitFound = commitName
      else:
        #if not containsAFixBool and pattern.search(line):
        if pattern.search(line):
           afterIsWaitingForABefore = True
           #containsAFixBool=True
           #fout.write("=======================\n")
	   #if ' ' not in commitName and len(commitName) ==40:
             #hashArray.append(commitName+"\n")
           #else:
	     #hashArray.pop(-1)  # removes last element
	   #fout.write("\n")
           #fout.write(line+"\n") # Uncomment this line if you want to see the full message being saved in commitList.txt
           #fout.write("\n")
           fixCount=fixCount+1

    #if last item doesnt have a match, remove it
    #lastItem = hashArray[len(hashArray)-1]
    #if lastItem[len(lastItem)-1] == ' ':
    #  hashArray.pop(-1)

    for line in hashArray:
      fout.write(line)
    print "fix count: ",fixCount
    print "total count: ",totalCount

if __name__ == "__main__":
  main()    
