#!/bin/bash

#It receives one parameter: the number of projects it should download from the link below
#param 1 can only be a multiple of 10. Ex:10,20,100,120, etc.

#This program reads a list of git respositories and clones each respository in the #list in the current directory

# Example usage: ./DowloadRepos.sh 10

if [ "$#" -ne 1 ]; then
    echo "This script should be run with 1 parameters: The number of projects to clone. It must be a multiple of 10 (Ex: 10,20,30,100,etc)"

else

NUMBEROFPROJECTSTODOWNLOAD="$1"

#The link is hardcoded, and it is the link of the java projects in github sorted by the number of stars
pythonArgs="https://github.com/search?utf8=%E2%9C%93&q=language%3AJava+stars%3A%3E1000&type=Repositories&ref=searchresults $NUMBEROFPROJECTSTODOWNLOAD"

echo "Calling ExtractGitHubRepos"
python ExtractGitHubRepos.py $pythonArgs > sampleRepos.txt
echo "Finishing ExtractGitHubRepos"

#rm -rf GitRepos
echo "Creating GitRepos"
mkdir GitRepos
cd GitRepos/
repoFile=../sampleRepos.txt
while read projectFolder
do
  echo "git clone $projectFolder"
  CLONECOMMAND="git clone $projectFolder"
  eval $CLONECOMMAND
  echo ""  	
  #sleep 1


done < $repoFile 

fi #Correct number of params

