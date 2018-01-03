#!/bin/bash

# Example usage: ./2DoWorkOnDownloadedRepos.sh

SCRIPTSDIRECTORY=$(pwd)
JAVALOCATION=$(which java)
JAVACLOCATION=$(which javac)

cd GitRepos/
repoFile=../sampleRepos.txt
while read projectFolder
do

  folderNameTmp=$(echo $projectFolder | sed 's#.*/##g') #take the folder name from the url with extension
  folderName=$(echo "${folderNameTmp::-4}") # remove extension
  #folderName=$(echo "${folderNameTmp::${#folderNameTmp}-4}") # remove extension
  echo "Working on project $folderName"
  if [ -d "$folderName" ]; then
    cd $folderName
    git log -100 --all -- '*.java' > logResult.txt # look only for commits that look into java files # add -100 to look just for the last 100 commits
    python ../../readLogData.py logResult.txt commitList.txt
    echo "commitList.txt created"
  
    rm -rf BugFixingCommitVersions
    mkdir BugFixingCommitVersions
    cd BugFixingCommitVersions
    commitNumber=0

    #saves the before and after versions for each of the modified files
    commitList=../commitList.txt
    while read commitHashs
    do
        beforeHash=$(echo $commitHashs| cut -d' ' -f 1)
        afterHash=$(echo $commitHashs| cut -d' ' -f 2)
        commitNumber=$[$commitNumber+1]

        #git filters http://stackoverflow.com/questions/6879501/filter-git-diff-by-type-of-change
        allFilesModified=$(git diff --diff-filter=M --name-only $commitHashs) 

        count=0
        for currentFile in $allFilesModified
        do
    	  #echo "Checking file: $currentFile"
          if [[ "$currentFile" == *.java ]]
          then
            count=$(($count+1))
            #echo $currentFile
          fi
        done

      if [ $count -le 3 ] && [ $count -ge 1 ]; #If the number of files modified is between 1 and 3
      #if [ $count -ge 1 ];
      then
        #echo "before and after, right before introducing it to commitListAfter3FileFilter.txt: $commitHashs"
        echo "$commitHashs" >> ../commitListAfter3FileFilter.txt
        #echo "Line $commitNumber from commitList.txt has between 1-3 java files being modified"
      fi    

      #cd .. #get out from $commitFolderName folder
    done < $commitList

    #It takes the last n commits
    head -100 ../commitListAfter3FileFilter.txt > ../commitListSmall.txt 
    rm ../commitListAfter3FileFilter.txt

    commitNumber=0
    commitListSmall=../commitListSmall.txt
    while read commitHashs
    do
        beforeHash=$(echo $commitHashs| cut -d' ' -f 1)
        afterHash=$(echo $commitHashs| cut -d' ' -f 2)
        #beforeHash=${commitHashs:0:40}
        commitNumber=$[$commitNumber+1]
        commitFolderName="Commit"$commitNumber
        echo ""
        echo "Working on $commitFolderName of $folderName"
        mkdir $commitFolderName
        cd $commitFolderName
        rm -f filesModifiedInThisCommit.txt

        #git filters http://stackoverflow.com/questions/6879501/filter-git-diff-by-type-of-change
        allFilesModified=$(git diff --diff-filter=M --name-only $commitHashs) 

        stringFilesModifiedInThisCommit=""
        for currentFile in $allFilesModified
        do
	  #echo "Checking file: $currentFile"
          if [[ "$currentFile" == *.java ]]
          then
          #  echo "Current file: "$currentFile
            stringFilesModifiedInThisCommit="$stringFilesModifiedInThisCommit $currentFile"
          fi
        done


        IFS=' ' read -r -a arrayOfModifiedFiles <<< "$stringFilesModifiedInThisCommit"
        for oneJavaFile in "${arrayOfModifiedFiles[@]}"
        do
          echo $oneJavaFile >> filesModifiedInThisCommit.txt
        done
   
        if [ -n "$stringFilesModifiedInThisCommit" ]; then
          mkdir before
          cd before
          fileNames=../filesModifiedInThisCommit.txt
          while read fileName
          do
	    nameOfFile=${fileName##*/}
	    git show $beforeHash:$fileName > $nameOfFile
          done < $fileNames
          cd .. #get out from before folder

          mkdir after
          cd after
          fileNames=../filesModifiedInThisCommit.txt
          while read fileName
          do
	    nameOfFile=${fileName##*/}
            git show $afterHash:$fileName > $nameOfFile
          done < $fileNames
          cd .. #get out from after folder
	
          fileNames=./filesModifiedInThisCommit.txt
          while read fileName
          do
	    nameOfFile=${fileName##*/} #name of the file with the .java extension. Example: example.java
            currentDirectory=$(pwd)
            nameOfFileWithoutExtension="${nameOfFile%.*}"
            echo "Calling QACrashFix for project $folderName in commit $commitNumber with file $nameOfFile"
	    
	    rm -f "$currentDirectory""$nameOfFileWithoutExtension"GenProgMutationsCounts.txt
	    #Getting each particular replacement
	        timeout -k 1m 5m $JAVALOCATION -Dfile.encoding=UTF-8 -classpath $SCRIPTSDIRECTORY/qacrashfix/QACrashFix/test/Test/bin:$SCRIPTSDIRECTORY/qacrashfix/QACrashFix/target/exception-fix-0.0.1-SNAPSHOT.jar:$SCRIPTSDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/log4j-api-2.5.jar:$SCRIPTSDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/log4j-core-2.5.jar:$SCRIPTSDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.core.contenttype_3.5.0.v20150421-2214.jar:$SCRIPTSDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.core.jobs_3.7.0.v20150330-2103.jar:$SCRIPTSDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.core.resources_3.10.1.v20150725-1910.jar:$SCRIPTSDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.core.runtime_3.11.1.v20150903-1804.jar:$SCRIPTSDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.equinox.common_3.7.0.v20150402-1709.jar:$SCRIPTSDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.equinox.preferences_3.5.300.v20150408-1437.jar:$SCRIPTSDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.jdt.core_3.11.1.v20150902-1521.jar:$SCRIPTSDIRECTORY/qacrashfix/QACrashFix/test/Test/lib/org.eclipse.osgi_3.10.102.v20160118-1700.jar CountNumberOfGenProgMutations $currentDirectory/before/$nameOfFile $currentDirectory/after/$nameOfFile  > "$currentDirectory""$nameOfFileWithoutExtension"GenProgMutationsCounts.txt



	    rm -f "$currentDirectory""$nameOfFileWithoutExtension"ParMutationsCounts.txt
	    echo "Calling Gumtree for project $folderName in commit $commitNumber with file $nameOfFile"
	    #timeout -k 1m 5m $SCRIPTSDIRECTORY/gumtreeBin/bin/gumtree adhocdiff $currentDirectory/before/$nameOfFile $currentDirectory/after/$nameOfFile > "$currentDirectory""$nameOfFileWithoutExtension"ParMutationsCounts.txt

	    cd $SCRIPTSDIRECTORY/ScalaGumTree/bugfixes/historicalfixv2/bin/
 	    timeout -k 1m 5m scala -classpath .:../allLibs/*:../allLibs/*/*:gumdiff/handlejdt/*:gumdiff/jdtgum/*:gumdiff/customLib/*:gumdiff/handlecommits/*:gumdiff/difftemplates/* gumdiff.difftemplates.DiffTemplates $currentDirectory/before/$nameOfFile $currentDirectory/after/$nameOfFile > "$currentDirectory""$nameOfFileWithoutExtension"ParMutationsCounts.txt
	    cd $SCRIPTSDIRECTORY/GitRepos/$folderName/BugFixingCommitVersions/$commitFolderName

          done < $fileNames
        fi
      cd .. #get out from $commitFolderName folder
    done < $commitListSmall

    cd .. #bugFixingCommitVersions
    rm -fr ../"$folderName"BugFixingCommitVersions
    mv BugFixingCommitVersions ../"$folderName"BugFixingCommitVersions
    cd .. #folderName
    #rm -r $folderName #remove the cloned project
  fi
  #rm -f projectFolders.txt
  echo ""
#done < $projectFolders

  #cd "$folderName"BugFixingCommitVersions

done < $repoFile 
















