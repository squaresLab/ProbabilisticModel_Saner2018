#!/bin/bash 

declare -ia successRates
declare -ia successRatesMut
SRIndex=0
SRIndexMut=0
for FOLDTOTEST in {1..10}
do

  cd GitRepos/

    cd tier"$FOLDTOTEST"

      declare -ia testingData
      readarray testingData < tier"$FOLDTOTEST"Model.txt

      counterTesting=0
      didPredictIt=0
      didNotPredictIt=0
      for replacee in `seq 1 22`; # 484 = 22*22 all possible combinations of replacements
      do

        lineNumberOfMostLikely1=-1
        lineNumberOfMostLikely2=-1
        lineNumberOfMostLikely3=-1
        lineNumberOfMostLikely4=-1
        lineNumberOfMostLikely5=-1
	BetweenOneAndTwentyTwo=$[ ( $RANDOM % 22 ) ]
	RAND=$((($replacee - 1) * 22 + $BetweenOneAndTwentyTwo))
	while [[ $RAND -eq $lineNumberOfMostLikely1 || $RAND -eq $lineNumberOfMostLikely2 || $RAND -eq $lineNumberOfMostLikely3 || $RAND -eq $lineNumberOfMostLikely4 || $RAND -eq $lineNumberOfMostLikely5 ]]
	do
	  BetweenOneAndTwentyTwo=$[ ( $RANDOM % 22 ) ]
          RAND=$((($replacee - 1) * 22 + $BetweenOneAndTwentyTwo))
	done
	lineNumberOfMostLikely1=$RAND
	while [[ $RAND -eq $lineNumberOfMostLikely1 || $RAND -eq $lineNumberOfMostLikely2 || $RAND -eq $lineNumberOfMostLikely3 || $RAND -eq $lineNumberOfMostLikely4 || $RAND -eq $lineNumberOfMostLikely5 ]]
        do
          BetweenOneAndTwentyTwo=$[ ( $RANDOM % 22 ) ]
          RAND=$((($replacee - 1) * 22 + $BetweenOneAndTwentyTwo))
        done
        lineNumberOfMostLikely2=$RAND
        while [[ $RAND -eq $lineNumberOfMostLikely1 || $RAND -eq $lineNumberOfMostLikely2 || $RAND -eq $lineNumberOfMostLikely3 || $RAND -eq $lineNumberOfMostLikely4 || $RAND -eq $lineNumberOfMostLikely5 ]]
        do
          BetweenOneAndTwentyTwo=$[ ( $RANDOM % 22 ) ]
          RAND=$((($replacee - 1) * 22 + $BetweenOneAndTwentyTwo))
        done
        lineNumberOfMostLikely3=$RAND
	while [[ $RAND -eq $lineNumberOfMostLikely1 || $RAND -eq $lineNumberOfMostLikely2 || $RAND -eq $lineNumberOfMostLikely3 || $RAND -eq $lineNumberOfMostLikely4 || $RAND -eq $lineNumberOfMostLikely5 ]]
        do
          BetweenOneAndTwentyTwo=$[ ( $RANDOM % 22 ) ]
          RAND=$((($replacee - 1) * 22 + $BetweenOneAndTwentyTwo))
        done
        lineNumberOfMostLikely4=$RAND
	while [[ $RAND -eq $lineNumberOfMostLikely1 || $RAND -eq $lineNumberOfMostLikely2 || $RAND -eq $lineNumberOfMostLikely3 || $RAND -eq $lineNumberOfMostLikely4 || $RAND -eq $lineNumberOfMostLikely5 ]]
        do
          BetweenOneAndTwentyTwo=$[ ( $RANDOM % 22 ) ]
          RAND=$((($replacee - 1) * 22 + $BetweenOneAndTwentyTwo))
        done
        lineNumberOfMostLikely5=$RAND



        #echo "Most likelies in row $replacee are: lines: $(($lineNumberOfMostLikely1+1)), $(($lineNumberOfMostLikely2+1)), $(($lineNumberOfMostLikely3+1)), $(($lineNumberOfMostLikely4+1)), $(($lineNumberOfMostLikely5+1))"

        #see how many can the model correctly predict
        for testingReplacer in `seq 1 22`;
        do
          #to get the data with less guesses comment the remaining OR's from this condition
          if [ $counterTesting -eq $lineNumberOfMostLikely1 ] || [ $counterTesting -eq $lineNumberOfMostLikely2 ] || [ $counterTesting -eq $lineNumberOfMostLikely3 ] || [ $counterTesting -eq $lineNumberOfMostLikely4 ] || [ $counterTesting -eq $lineNumberOfMostLikely5 ]
          then
            didPredictIt=$(($didPredictIt+${testingData[$counterTesting]}))
          else
            didNotPredictIt=$(($didNotPredictIt+${testingData[$counterTesting]})) 
          fi
          counterTesting=$(($counterTesting+1))
        done
        #echo "Testing Fold: $FOLDTOTEST, For line: $replacee, we have $didPredictIt predicted, and $didNotPredictIt NOT predicted." 

      done

      echo "Tier $FOLDTOTEST as testing data:"

      totalInstances=$(($didPredictIt + $didNotPredictIt))
      if [ $totalInstances -ne 0 ]
      then
      	successRate=$(($didPredictIt*100/$totalInstances))
      else
        successRate=0
      fi
      successRates[$SRIndex]=$successRate
      if [ $didPredictIt = 0 ] && [ $didNotPredictIt = 0 ]
      then
	echo "Replacements: $didPredictIt instances predicted, and $didNotPredictIt instances NOT predicted. There was nothing to predict"
      else
        echo "Replacements: $didPredictIt instances predicted, and $didNotPredictIt instances NOT predicted. Success Rate: $successRate%"
	((SRIndex=$SRIndex+1))
      fi







       # counterTesting=0
        didPredictIt=0
        didNotPredictIt=0


        lineNumberOfMostLikely1=-1
        lineNumberOfMostLikely2=-1
        lineNumberOfMostLikely3=-1
        lineNumberOfMostLikely4=-1
        lineNumberOfMostLikely5=-1
	BetweenOneAndNineteen=$[ ( $RANDOM % 19 ) ]
	RAND=$((1 + $BetweenOneAndNineteen))
	while [[ $RAND -eq $lineNumberOfMostLikely1 || $RAND -eq $lineNumberOfMostLikely2 || $RAND -eq $lineNumberOfMostLikely3 || $RAND -eq $lineNumberOfMostLikely4 || $RAND -eq $lineNumberOfMostLikely5 ]]
	do
	  BetweenOneAndNineteen=$[ ( $RANDOM % 19 ) ]
          RAND=$((1 + $BetweenOneAndNineteen))
	done
	lineNumberOfMostLikely1=$RAND
	while [[ $RAND -eq $lineNumberOfMostLikely1 || $RAND -eq $lineNumberOfMostLikely2 || $RAND -eq $lineNumberOfMostLikely3 || $RAND -eq $lineNumberOfMostLikely4 || $RAND -eq $lineNumberOfMostLikely5 ]]
        do
          BetweenOneAndNineteen=$[ ( $RANDOM % 19 ) ]
          RAND=$((1 + $BetweenOneAndNineteen))
        done
        lineNumberOfMostLikely2=$RAND
        while [[ $RAND -eq $lineNumberOfMostLikely1 || $RAND -eq $lineNumberOfMostLikely2 || $RAND -eq $lineNumberOfMostLikely3 || $RAND -eq $lineNumberOfMostLikely4 || $RAND -eq $lineNumberOfMostLikely5 ]]
        do
          BetweenOneAndNineteen=$[ ( $RANDOM % 19 ) ]
          RAND=$((1 + $BetweenOneAndNineteen))
        done
        lineNumberOfMostLikely3=$RAND
	while [[ $RAND -eq $lineNumberOfMostLikely1 || $RAND -eq $lineNumberOfMostLikely2 || $RAND -eq $lineNumberOfMostLikely3 || $RAND -eq $lineNumberOfMostLikely4 || $RAND -eq $lineNumberOfMostLikely5 ]]
        do
          BetweenOneAndNineteen=$[ ( $RANDOM % 19 ) ]
          RAND=$((1 + $BetweenOneAndNineteen))
        done
        lineNumberOfMostLikely4=$RAND
	while [[ $RAND -eq $lineNumberOfMostLikely1 || $RAND -eq $lineNumberOfMostLikely2 || $RAND -eq $lineNumberOfMostLikely3 || $RAND -eq $lineNumberOfMostLikely4 || $RAND -eq $lineNumberOfMostLikely5 ]]
        do
          BetweenOneAndNineteen=$[ ( $RANDOM % 19 ) ]
          RAND=$((1 + $BetweenOneAndNineteen))
        done
        lineNumberOfMostLikely5=$RAND



        #echo "Most likelies in row $replacee are: lines: $(($lineNumberOfMostLikely1+1)), $(($lineNumberOfMostLikely2+1)), $(($lineNumberOfMostLikely3+1)), $(($lineNumberOfMostLikely4+1)), $(($lineNumberOfMostLikely5+1))"

        #see how many can the model correctly predict
        for testingReplacer in `seq 1 19`;
        do
	convertedCounterTesting=$((counterTesting-483))

          #to get the data with less guesses comment the remaining OR's from this condition
          if [ $convertedCounterTesting -eq $lineNumberOfMostLikely1 ] || [ $convertedCounterTesting -eq $lineNumberOfMostLikely2 ] || [ $convertedCounterTesting -eq $lineNumberOfMostLikely3 ] || [ $convertedCounterTesting -eq $lineNumberOfMostLikely4 ] || [ $convertedCounterTesting -eq $lineNumberOfMostLikely5 ]
          then
            didPredictIt=$(($didPredictIt+${testingData[$counterTesting]}))
          else
            didNotPredictIt=$(($didNotPredictIt+${testingData[$counterTesting]})) 
          fi
          counterTesting=$(($counterTesting+1))
        done
        #echo "Testing Fold: $FOLDTOTEST, For line: $replacee, we have $didPredictIt predicted, and $didNotPredictIt NOT predicted." 


      totalInstances=$(($didPredictIt + $didNotPredictIt))
      if [ $totalInstances -ne 0 ]
      then
      	successRate=$(($didPredictIt*100/$totalInstances))
      else
        successRate=0
      fi
      successRatesMut[$SRIndexMut]=$successRate
      if [ $didPredictIt = 0 ] && [ $didNotPredictIt = 0 ]
      then
	echo "Mutations: $didPredictIt instances predicted, and $didNotPredictIt instances NOT predicted. There was nothing to predict"
      else
        echo "Mutations: $didPredictIt instances predicted, and $didNotPredictIt instances NOT predicted. Success Rate: $successRate%"
	((SRIndexMut=$SRIndexMut+1))
      fi





























    cd .. #out of tier$FOLDTOTEST
  cd .. # out of GitRepos
done
echo "Replacements:"
mean=$(echo ${successRates[@]} | awk '{for(i=1;i<=NF;i++){sum+=$i};print sum/NF}')
echo "Mean: $mean"
variance=$(echo ${successRates[@]} | awk -vM=5 '{for(i=1;i<=NF;i++){sum+=($i-'"$mean"')*($i-'"$mean"')};print sum/NF}')
echo "Variance: $variance"
stdDev=$(echo ${successRates[@]} | awk -vM=5 '{for(i=1;i<=NF;i++){sum+=($i-'"$mean"')*($i-'"$mean"')};print sqrt(sum/NF)}')
echo "Standard deviation: $stdDev"
echo ""
echo "Mutations:"
meanMut=$(echo ${successRatesMut[@]} | awk '{for(i=1;i<=NF;i++){sum+=$i};print sum/NF}')
echo "Mean: $meanMut"
varianceMut=$(echo ${successRatesMut[@]} | awk -vM=5 '{for(i=1;i<=NF;i++){sum+=($i-'"$meanMut"')*($i-'"$meanMut"')};print sum/NF}')
echo "Variance: $varianceMut"
stdDevMut=$(echo ${successRatesMut[@]} | awk -vM=5 '{for(i=1;i<=NF;i++){sum+=($i-'"$meanMut"')*($i-'"$meanMut"')};print sqrt(sum/NF)}')
echo "Standard deviation: $stdDevMut"


