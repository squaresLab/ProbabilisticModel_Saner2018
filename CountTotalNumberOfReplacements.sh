#!/bin/bash 

#./4CountTotalNumberOfReplacements.sh tier1

containerFolderName="$1"

declare -ia replacementCounter
for i in `seq 1 484`; # 484 = 22*22 all possible combinations of replacements
do
  replacementCounter[$i]=0
done
replacementCount=0
appendCount=0
deleteCount=0

cd GitRepos/

cd $containerFolderName

ls -d *BugFixingCommitVersions > GithubProjects.txt

projectNames=./GithubProjects.txt
while read projectName 
do

  #echo "current directory:"
  #pwd
  echo "Counting GenProg mutations on project $projectName"
  cd $projectName
#  cd BugFixingCommitVersions

  ls -d Commit[1234567890]*GenProgMutationsCounts.txt | grep -v / > CommitFilesGenProg.txt

  if [ -e "CommitFilesGenProg.txt" ] 
  then
    commitFilesNames=./CommitFilesGenProg.txt
    while read commitFileName 
    do
      if [ -s $commitFileName ] #if it is not empty
      then
        echo "Container: $containerFolderName Project: $projectName File: $commitFileName"
        for i in `seq 1 487`; # 484 = 22*22 all possible combinations of replacements
        do
          commandToGetSpecificLine="sed '$i!d' $commitFileName | cut -f1 -d':'" # take only the number before the colon

          numberOfReplacementsOfThisLine=$(eval $commandToGetSpecificLine)
	  if [ $i -le 484 ]; then
            (( replacementCounter[$i]+=$numberOfReplacementsOfThisLine ))
	  fi
	  if [ $i -eq 485 ]; then
            (( replacementCount+=$numberOfReplacementsOfThisLine ))
	  fi
	  if [ $i -eq 486 ]; then
            (( appendCount+=$numberOfReplacementsOfThisLine ))
	  fi
	  if [ $i -eq 487 ]; then
            (( deleteCount+=$numberOfReplacementsOfThisLine ))
	  fi
          #if [ ${replacementCounter[$i]} -ne 0 ]; then
            #echo "Total counter for iterator $i: ${replacementCounter[$i]}"
          #fi
        done 
      fi
    done < $commitFilesNames
  fi
#cd .. # get out of BugFixingCommitVersions
cd .. # get out of $projectName
done < $projectNames

#print the replacementCounter array into a file here: Model.txt
printf "%s\n" "${replacementCounter[@]}" > "$containerFolderName"Model.txt
echo $replacementCount >> "$containerFolderName"Model.txt
echo $appendCount >> "$containerFolderName"Model.txt
echo $deleteCount >> "$containerFolderName"Model.txt

#touch summaryOfModel.txt
for i in `seq 1 484`; # 484 = 22*22 all possible combinations of replacements
do
  if [ ${replacementCounter[$i]} -ne 0 ]; then
    echo "Total counter for iterator $i: ${replacementCounter[$i]}" >> "$containerFolderName"SummaryOfModel.txt
  fi
done 
if [ $replacementCount -ne 0 ]; then
    echo "Total counter for replacements: $replacementCount" >> "$containerFolderName"SummaryOfModel.txt
fi
if [ $appendCount -ne 0 ]; then
    echo "Total counter for append: $appendCount" >> "$containerFolderName"SummaryOfModel.txt
fi
if [ $deleteCount -ne 0 ]; then
    echo "Total counter for delete: $deleteCount" >> "$containerFolderName"SummaryOfModel.txt
fi
