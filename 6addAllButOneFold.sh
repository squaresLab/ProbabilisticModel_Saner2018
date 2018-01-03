#!/bin/bash 

#./addAllButOneFold.sh


for FOLDTOOMIT in {1..10}
do
  echo "Omiting fold $FOLDTOOMIT:"
  declare -ia replacementCounter
  for i in `seq 1 484`; # 484 = 22*22 all possible combinations of replacements
  do
    replacementCounter[$i]=0
  done
  replacementCount=0
  appendCount=0
  deleteCount=0

  declare -ia replacementCounter
  for i in `seq 1 16`; # 16 templates
  do
    templatesCounter[$i]=0
  done

  cd GitRepos/

  for tierNumber in {1..10}
  do
    if [ $tierNumber -ne $FOLDTOOMIT ]; then
      cd tier"$tierNumber"
      echo "Taking data from tier $tierNumber"
      for i in `seq 1 503`; # 484 = 22*22 all possible combinations of replacements + 3 + 16
        do
          commandToGetSpecificLine="sed '$i!d' tier"$tierNumber"Model.txt" # take number in line i
          
          numberInThisLine=$(eval $commandToGetSpecificLine)
	  if [ $i -le 484 ]; then
            (( replacementCounter[$i]+=$numberInThisLine ))
	  fi
	  if [ $i -eq 485 ]; then
            (( replacementCount+=$numberInThisLine ))
	  fi
	  if [ $i -eq 486 ]; then
            (( appendCount+=$numberInThisLine ))
	  fi
	  if [ $i -eq 487 ]; then
            (( deleteCount+=$numberInThisLine ))
	  fi
	  if [ $i -ge 488 ]; then
	    CORRECTINDEX=0
	    ((CORRECTINDEX=$i-487))
            (( templatesCounter[$CORRECTINDEX]+=$numberInThisLine ))
	  fi

      done 
      cd .. # out of tier folder
    fi

  done

  #print the replacementCounter array into a file here: Model.txt
  rm -f AllButTier"$FOLDTOOMIT"Model.txt
  printf "%s\n" "${replacementCounter[@]}" > AllButTier"$FOLDTOOMIT"Model.txt
  echo $replacementCount >> AllButTier"$FOLDTOOMIT"Model.txt
  echo $appendCount >> AllButTier"$FOLDTOOMIT"Model.txt
  echo $deleteCount >> AllButTier"$FOLDTOOMIT"Model.txt
  printf "%s\n" "${templatesCounter[@]}" >> AllButTier"$FOLDTOOMIT"Model.txt
  echo "AllButTier"$FOLDTOOMIT"Model.txt created"

  #touch summaryOfModel.txt
  rm -f summaryOfAllButTier"$FOLDTOOMIT"Model.txt
  for i in `seq 1 484`; # 484 = 22*22 all possible combinations of replacements
  do
    if [ ${replacementCounter[$i]} -ne 0 ]; then
      echo "Total counter for iterator $i: ${replacementCounter[$i]}" >> summaryOfAllButTier"$FOLDTOOMIT"Model.txt
    fi
  done 
if [ $replacementCount -ne 0 ]; then
    echo "Total counter for replacements: $replacementCount" >> summaryOfAllButTier"$FOLDTOOMIT"Model.txt
fi
if [ $appendCount -ne 0 ]; then
    echo "Total counter for append: $appendCount" >> summaryOfAllButTier"$FOLDTOOMIT"Model.txt
fi
if [ $deleteCount -ne 0 ]; then
    echo "Total counter for delete: $deleteCount" >> summaryOfAllButTier"$FOLDTOOMIT"Model.txt
fi
  for i in `seq 1 16`; 
  do
    if [ ${templatesCounter[$i]} -ne 0 ]; then
      echo "Total counter for template $i: ${templatesCounter[$i]}" >> summaryOfAllButTier"$FOLDTOOMIT"Model.txt
    fi
  done 
echo "summaryOfAllButTier"$FOLDTOOMIT"Model.txt created"
echo ""
  cd .. # out of GitRepos
done
