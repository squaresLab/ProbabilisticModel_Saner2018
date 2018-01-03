#!/bin/bash 

#./CountTotalNumberOfTemplates.sh tier1

containerFolderName="$1"

declare -ia templateCounter
for i in `seq 1 16`; 
do
  templateCounter[$i]=0
done

cd GitRepos/

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

 ls -d Commit[1234567890]*ParMutationsCounts.txt | grep -v / > CommitFilesTemplates.txt

  if [ -e "CommitFilesTemplates.txt" ] 
  then
    commitFilesNames=./CommitFilesTemplates.txt
    while read commitFileName 
    do
      if [ -s $commitFileName ] #if it is not empty
      then
        echo "Container: $containerFolderName Project: $projectName File: $commitFileName"
        for i in `seq 1 16`; 
        do
          commandToGetSpecificLine="sed '$i!d' $commitFileName | cut -f1 -d':'" # take only the number before the colon
          numberOfTemplatesOfThisLine=$(eval $commandToGetSpecificLine)
echo "numberOfTemplatesOfThisLine: $numberOfTemplatesOfThisLine"
          (( templateCounter[$i]+=$numberOfTemplatesOfThisLine ))
	 
        done 
      fi
    done < $commitFilesNames
  fi
#cd .. # get out of BugFixingCommitVersions
cd .. # get out of $projectName
done < $projectNames

#print the templateCounter array into a file here: Model.txt
for i in `seq 1 16`; 
do
  echo ${templateCounter[$i]} >> "$containerFolderName"Model.txt
done


#Already performed in previous script
#touch summaryOfModel.txt
for i in `seq 1 16`;
do
  if [ ${templateCounter[$i]} -ne 0 ]; then
    echo "Total counter for template $i: ${templateCounter[$i]}" >> "$containerFolderName"SummaryOfModel.txt
  fi
done 

