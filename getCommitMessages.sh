#!/bin/bash

#It receives one parameter: the number of projects it should download from the link below
#param 1 can only be a multiple of 10. Ex:10,20,100,120, etc.

#This program reads a list of git respositories and clones each respository in the #list in the current directory

# Example usage: ./DoWorkOnDownloadedRepos.sh


QACRASHFIXDIRECTORY=$(pwd)

uname -v | grep -qi Darwin && JAVA_PATH=`/usr/libexec/java_home -v 1.7`/bin
uname -v | grep -qi Ubuntu && JAVA_PATH="/usr/lib/jvm/java-7-oracle/bin"

cd GitRepos/
repoFile=../sampleRepos.txt
while read projectFolder
do

  folderNameTmp=$(echo $projectFolder | sed 's#.*/##g') #take the folder name from the url with extension
  folderName=$(echo "${folderNameTmp::${#folderNameTmp}-4}") # remove extension
  echo "Working on project $folderName"
  cd $folderName    # ENTER $folderName:21
  git log --all -- '*.java' > logResult.txt # look only for commits that look into java files
  python ../../readLogData.py logResult.txt commitList.txt
  echo "commitList.txt created"

  #THIS IS A TEMPORAL SOLUTION TO REDUCE THE TIME IT TAKES TO RUN THE SCRIPT. IT TAKES ONLY THE LAST 10 COMMITS. REMOVE IT
#  head -10 commitList.txt > commitListSmall.txt 
  #REMOVE WHATS ABOVE. ALSO CHANGE BELOW commitListSmall.txt FOR commitList.txt

  rm -rf BugFixingCommitVersions
  mkdir BugFixingCommitVersions
  cd BugFixingCommitVersions    # ENTER BugFixingCommitVersions:32
  commitNumber=0

  #saves the before and after versions for each of the modified files
  commitList=../commitList.txt
  num_commits=$(cat $commitList | wc -l)
  while read commitHashs
  do
    beforeHash=$(echo $commitHashs| cut -d' ' -f 1)
    afterHash=$(echo $commitHashs| cut -d' ' -f 2)
    #beforeHash=${commitHashs:0:40}
    commitNumber=$[$commitNumber+1]
    commitFolderName="Commit"$commitNumber
    echo "Working on $commitFolderName"
    echo ""
    mkdir $commitFolderName
    cd $commitFolderName  # ENTER $commitFolderName:47

    #git filters http://stackoverflow.com/questions/6879501/filter-git-diff-by-type-of-change
    allFilesModified=$(git diff --diff-filter=M --name-only $commitHashs) 

    stringFilesModifiedInThisCommit=""
    count=0
    for currentFile in $allFilesModified
    do
	  #echo "Checking file: $currentFile"
      if [[ "$currentFile" == *.java ]]
  	  then
        count=$(($count+1))
        #echo $currentFile
        stringFilesModifiedInThisCommit="$stringFilesModifiedInThisCommit $currentFile"
      fi
    done

    if [ $count -ge 3 ]
    then
      commit_msg=$(git log --format=%B -n 1 $afterHash)
      echo "$folderName: $commitNumber of $num_commits: $afterHash: $commit_msg" >> ../../../../commitLogs.txt
    fi
##    IFS=' ' read -r -a arrayOfModifiedFiles <<< "$stringFilesModifiedInThisCommit"
##    for oneJavaFile in "${arrayOfModifiedFiles[@]}"
##    do
##      echo $oneJavaFile >> filesModifiedInThisCommit.txt
##    done
##
##    if [ -n "$stringFilesModifiedInThisCommit" ]
##    then
##      mkdir before
##      cd before   # ENTER before:72
##      fileNames=../filesModifiedInThisCommit.txt
##      while read fileName
##      do
##      	nameOfFile=${fileName##*/}
##        git show $beforeHash:$fileName > $nameOfFile
##      done < $fileNames
##      cd ..     # EXIT before:72
##
##      mkdir after
##      cd after      # ENTER after:82
##      fileNames=../filesModifiedInThisCommit.txt
##      while read fileName
##      do
##	    nameOfFile=${fileName##*/}
##        git show $afterHash:$fileName > $nameOfFile
##      done < $fileNames
##      cd .. # EXIT after:82
##
##      fileNames=./filesModifiedInThisCommit.txt
##      while read fileName
##      do
##        nameOfFile=${fileName##*/} #name of the file with the .java extension. Example: example.java
##        currentDirectory=$(pwd)
##        nameOfFileWithoutExtension="${nameOfFile%.*}"
##        echo "Calling QACrashFix for project $folderName in commit $commitNumber with file $nameOfFile"
##        ${JAVA_PATH}/java -Dfile.encoding=UTF-8 -classpath $QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/test/Test/bin:$QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/target/exception-fix-0.0.1-SNAPSHOT.jar:$QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/log4j-api-2.5.jar:$QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/log4j-core-2.5.jar:$QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.core.contenttype_3.5.0.v20150421-2214.jar:$QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.core.jobs_3.7.0.v20150330-2103.jar:$QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.core.resources_3.10.1.v20150725-1910.jar:$QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.core.runtime_3.11.1.v20150903-1804.jar:$QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.equinox.common_3.7.0.v20150402-1709.jar:$QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.equinox.preferences_3.5.300.v20150408-1437.jar:$QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.jdt.core_3.11.1.v20150902-1521.jar:$QACRASHFIXDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.osgi_3.10.102.v20160118-1700.jar Test $currentDirectory/before/$nameOfFile $currentDirectory/after/$nameOfFile > "$currentDirectory"$nameOfFileWithoutExtension.txt
##
##      done < $fileNames
##    fi
    cd .. # EXIT $commitFolderName:47
  done < $commitList

  cd ..   # EXIT BugFixingCommitVersions:32
  mv BugFixingCommitVersions ../"$folderName"BugFixingCommitVersions
  cd ..   # EXIT $folderName:21
  #rm -r $folderName #remove the cloned project

  #rm -f projectFolders.txt
  echo ""
#done < $projectFolders

  #cd "$folderName"BugFixingCommitVersions

done < $repoFile 
















