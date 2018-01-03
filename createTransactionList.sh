#!/bin/bash 

rm /home/mausoto/ReplacementsEmpiricalStudy/ReplacementTransactions.csv
touch /home/mausoto/ReplacementsEmpiricalStudy/ReplacementTransactions.csv
rm /home/mausoto/ReplacementsEmpiricalStudy/MutOperatorsTransactions.csv
touch /home/mausoto/ReplacementsEmpiricalStudy/MutOperatorsTransactions.csv

inputCounter=0

cd GitRepos/

for tier in `seq 1 10`; 
do
containerFolderName=tier"$tier"

declare -ia templateCounter
for i in `seq 1 16`; 
do
  templateCounter[$i]=0
done
declare -ia replacementCounter
for i in `seq 1 484`; # 484 = 22*22 all possible combinations of replacements
do
  replacementCounter[$i]=0
done
replacementCount=0
appendCount=0
deleteCount=0

cd $containerFolderName

#Already performed in previous script
#ls -d *BugFixingCommitVersions > GithubProjects.txt

projectNames=./GithubProjects.txt
while read projectName 
do

  #echo "current directory:"
  #pwd
  echo "Counting Templates on project $projectName"
  cd $projectName
#  cd BugFixingCommitVersions

 #ls -d Commit[1234567890]*ParMutationsCounts.txt | grep -v / > CommitFilesTemplates.txt
 
 if [ -e "CommitFilesGenProg.txt" ] 
  then
    commitFilesNames=./CommitFilesGenProg.txt
    while read commitFileName 
    do
      if [ -s $commitFileName ] #if it is not empty
      then
        #echo "Container: $containerFolderName Project: $projectName File: $commitFileName"
        for i in `seq 1 487`; # 484 = 22*22 all possible combinations of replacements
        do
          commandToGetSpecificLine="sed '$i!d' $commitFileName | cut -f1 -d':'" # take only the number before the colon

          numberOfReplacementsOfThisLine=$(eval $commandToGetSpecificLine)
	      if [ $i -le 484 ]; then
            (( replacementCounter[$i]=$numberOfReplacementsOfThisLine ))
	      fi
	      if [ $i -eq 485 ]; then
            (( replacementCount=$numberOfReplacementsOfThisLine ))
	      fi
	      if [ $i -eq 486 ]; then
            (( appendCount=$numberOfReplacementsOfThisLine ))
	      fi
	      if [ $i -eq 487 ]; then
            (( deleteCount=$numberOfReplacementsOfThisLine ))
	      fi
		  #if [ ${replacementCounter[$i]} -ne 0 ]; then
            #echo "Total counter for iterator $i: ${replacementCounter[$i]}"
          #fi
        done 
      else 
	    #echo "Empty file: Container: $containerFolderName Project: $projectName File: $commitFileName"
	    toFileReplacements="0"
	    for i in `seq 2 484`; # 484 = 22*22 all possible combinations of replacements
        do
		  toFileReplacements+=",0"
		done
		replacementCount="0"
		appendCount="0"
		deleteCount="0"
	  fi
	  
	  
	  
	  rootOfName=${commitFileName::-26} #Remove last 26 characters from the name
	  templatecommitFileName=$rootOfName"ParMutationsCounts.txt"
	  
	  if [ -s $templatecommitFileName ] #if it is not empty
      then
        #echo "Container: $containerFolderName Project: $projectName File: $templatecommitFileName"
        for i in `seq 1 16`; 
        do
          commandToGetSpecificLine="sed '$i!d' $templatecommitFileName | cut -f1 -d':'" # take only the number before the colon
          numberOfTemplatesOfThisLine=$(eval $commandToGetSpecificLine)
		  #echo "numberOfTemplatesOfThisLine: $numberOfTemplatesOfThisLine"
          templateCounter[$i]=$numberOfTemplatesOfThisLine 
        done
	  else
	    #echo "Empty file: Container: $containerFolderName Project: $projectName File: $commitFileName"
	    for i in `seq 1 16`; 
        do
          templateCounter[$i]=0
        done
      fi

	  toFileReplacements="${replacementCounter[1]}"
	  for i in `seq 2 484`; # 484 = 22*22 all possible combinations of replacements
      do
	    toFileReplacements+=",${replacementCounter[$i]}"
	  done
	  echo $toFileReplacements >> /home/mausoto/ReplacementsEmpiricalStudy/ReplacementTransactions.csv
	  
	  toFileMutOp="$replacementCount,$appendCount,$deleteCount"
	  for i in `seq 1 16`; # 484 = 22*22 all possible combinations of replacements
      do
	    toFileMutOp+=",${templateCounter[$i]}"
	  done
	  echo $toFileMutOp >> /home/mausoto/ReplacementsEmpiricalStudy/MutOperatorsTransactions.csv

	  echo "Inserted input for $rootOfName"
	  ((inputCounter++))
	  
	 
    done < $commitFilesNames
  fi
  echo ""
#cd .. # get out of BugFixingCommitVersions
cd .. # get out of $projectName
done < $projectNames

cd .. # get out of tier, aka: containerFolderName
done #going through different tiers

echo "Total number of insertions: $inputCounter"
