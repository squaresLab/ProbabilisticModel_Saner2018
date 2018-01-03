#!/bin/bash 

declare -ia successRates
declare -ia successRatesMut
SRIndex=0
SRIndexMut=0
for FOLDTOTEST in {1..10}
do

  cd GitRepos/

    #load model for all but FOLDTOTEST
    declare -ia model
    readarray model < AllButTier"$FOLDTOTEST"Model.txt

    cd tier"$FOLDTOTEST"

      declare -ia testingData
      readarray testingData < tier"$FOLDTOTEST"Model.txt

      counterModel=0
      counterTesting=0
      didPredictIt=0
      didNotPredictIt=0
      for replacee in `seq 1 22`; # 484 = 22*22 all possible combinations of replacements
      do
        mostLikely1=0
        mostLikely2=0
        mostLikely3=0
        mostLikely4=0
        mostLikely5=0
        lineNumberOfMostLikely1=$counterModel
        lineNumberOfMostLikely2=$(($counterModel+1))
        lineNumberOfMostLikely3=$(($counterModel+2))
        lineNumberOfMostLikely4=$(($counterModel+3))
        lineNumberOfMostLikely5=$(($counterModel+4))

        for modelReplacer in `seq 1 22`;
        do
          if [ ${model[$counterModel]} -ge $mostLikely1 ]
          then
            mostLikely5=$mostLikely4
            lineNumberOfMostLikely5=$lineNumberOfMostLikely4
            mostLikely4=$mostLikely3
            lineNumberOfMostLikely4=$lineNumberOfMostLikely3
            mostLikely3=$mostLikely2
            lineNumberOfMostLikely3=$lineNumberOfMostLikely2
            mostLikely2=$mostLikely1
            lineNumberOfMostLikely2=$lineNumberOfMostLikely1
            mostLikely1=${model[$counterModel]}
            lineNumberOfMostLikely1=$counterModel
          elif [ ${model[$counterModel]} -ge $mostLikely2 ]
          then
            mostLikely5=$mostLikely4
            lineNumberOfMostLikely5=$lineNumberOfMostLikely4
            mostLikely4=$mostLikely3
            lineNumberOfMostLikely4=$lineNumberOfMostLikely3
            mostLikely3=$mostLikely2
            lineNumberOfMostLikely3=$lineNumberOfMostLikely2
            mostLikely2=${model[$counterModel]}
            lineNumberOfMostLikely2=$counterModel
          elif [ ${model[$counterModel]} -ge $mostLikely3 ]
          then
            mostLikely5=$mostLikely4
            lineNumberOfMostLikely5=$lineNumberOfMostLikely4
            mostLikely4=$mostLikely3
            lineNumberOfMostLikely4=$lineNumberOfMostLikely3
            mostLikely3=${model[$counterModel]}
            lineNumberOfMostLikely3=$counterModel
          elif [ ${model[$counterModel]} -ge $mostLikely4 ]
          then
            mostLikely5=$mostLikely4
            lineNumberOfMostLikely5=$lineNumberOfMostLikely4
            mostLikely4=${model[$counterModel]}
            lineNumberOfMostLikely4=$counterModel
          elif [ ${model[$counterModel]} -ge $mostLikely5 ]
          then
            mostLikely5=${model[$counterModel]}
            lineNumberOfMostLikely5=$counterModel
          fi
          counterModel=$(($counterModel+1))
        done
        #echo "Most likelies in row $replacee are: $mostLikely1 in line $(($lineNumberOfMostLikely1+1)), $mostLikely2 in line $(($lineNumberOfMostLikely2+1)), $mostLikely3 in line $(($lineNumberOfMostLikely3+1)), $mostLikely4 in line $(($lineNumberOfMostLikely4+1)), $mostLikely5 in line $(($lineNumberOfMostLikely5+1))"
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







	for modelReplacer in `seq 1 19`;
        do
          if [ ${model[$counterModel]} -ge $mostLikely1 ]
          then
            mostLikely5=$mostLikely4
            lineNumberOfMostLikely5=$lineNumberOfMostLikely4
            mostLikely4=$mostLikely3
            lineNumberOfMostLikely4=$lineNumberOfMostLikely3
            mostLikely3=$mostLikely2
            lineNumberOfMostLikely3=$lineNumberOfMostLikely2
            mostLikely2=$mostLikely1
            lineNumberOfMostLikely2=$lineNumberOfMostLikely1
            mostLikely1=${model[$counterModel]}
            lineNumberOfMostLikely1=$counterModel
          elif [ ${model[$counterModel]} -ge $mostLikely2 ]
          then
            mostLikely5=$mostLikely4
            lineNumberOfMostLikely5=$lineNumberOfMostLikely4
            mostLikely4=$mostLikely3
            lineNumberOfMostLikely4=$lineNumberOfMostLikely3
            mostLikely3=$mostLikely2
            lineNumberOfMostLikely3=$lineNumberOfMostLikely2
            mostLikely2=${model[$counterModel]}
            lineNumberOfMostLikely2=$counterModel
          elif [ ${model[$counterModel]} -ge $mostLikely3 ]
          then
            mostLikely5=$mostLikely4
            lineNumberOfMostLikely5=$lineNumberOfMostLikely4
            mostLikely4=$mostLikely3
            lineNumberOfMostLikely4=$lineNumberOfMostLikely3
            mostLikely3=${model[$counterModel]}
            lineNumberOfMostLikely3=$counterModel
          elif [ ${model[$counterModel]} -ge $mostLikely4 ]
          then
            mostLikely5=$mostLikely4
            lineNumberOfMostLikely5=$lineNumberOfMostLikely4
            mostLikely4=${model[$counterModel]}
            lineNumberOfMostLikely4=$counterModel
          elif [ ${model[$counterModel]} -ge $mostLikely5 ]
          then
            mostLikely5=${model[$counterModel]}
            lineNumberOfMostLikely5=$counterModel
          fi
          counterModel=$(($counterModel+1))
        done
        #echo "Most likelies in row $replacee are: $mostLikely1 in line $(($lineNumberOfMostLikely1+1)), $mostLikely2 in line $(($lineNumberOfMostLikely2+1)), $mostLikely3 in line $(($lineNumberOfMostLikely3+1)), $mostLikely4 in line $(($lineNumberOfMostLikely4+1)), $mostLikely5 in line $(($lineNumberOfMostLikely5+1))"
        #see how many can the model correctly predict
        for testingReplacer in `seq 1 19`;
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







: <<'END'
      #Calculating how many from the testing set the model is able to guess
      sumOfAllInstancesOfMutations=0
      for possibleMutation in `seq $counterModel 503`;
      do
	sumOfAllInstancesOfMutations=$((sumOfAllInstancesOfMutations+model[$possibleMutation]))
      done

      declare -ia percentagesPerEachMutation
      declare -ia howManyCorrectGuesses
      sumOfCorrectGuesses=0
      for possibleMutation in `seq 1 1`; 
      do
	modelIndex=$(($possibleMutation+484))
	#echo "modelIndex: $modelIndex"
        percentagesPerEachMutation[$possibleMutation]=$((model[$modelIndex]*100/sumOfAllInstancesOfMutations))
	#echo "percentagesPerEachMutation[possibleMutation]: ${percentagesPerEachMutation[$possibleMutation]}%"
	#echo "model[$modelIndex]: ${model[$modelIndex]}"
	#echo "sumOfAllInstancesOfMutations: $sumOfAllInstancesOfMutations"
	howManyCorrectGuesses[$possibleMutation]=$((testingData[$modelIndex]*percentagesPerEachMutation[$possibleMutation]/100))
	#echo "howManyCorrectGuesses[possibleMutation]: ${howManyCorrectGuesses[$possibleMutation]}"
	sumOfCorrectGuesses=$((sumOfCorrectGuesses+howManyCorrectGuesses[$possibleMutation]))
	#echo "sumOfCorrectGuesses: $sumOfCorrectGuesses"
        sumOfIncorrectGuesses=$((sumOfCorrectGuesses+testingData[$modelIndex]-howManyCorrectGuesses[$possibleMutation]))
	#echo "sumOfIncorrectGuesses: $sumOfIncorrectGuesses"

	totalMut=$(($sumOfCorrectGuesses+$sumOfIncorrectGuesses))
	#echo "sumOfCorrectGuesses+sumOfIncorrectGuesses: $totalMut"
        if [ $totalMut -ne 0 ]; then
	  successMut=$(($sumOfCorrectGuesses*100/$totalMut))
        else
 	  successMut=0
        fi
	notPredicted=$((${testingData[$modelIndex]}-${howManyCorrectGuesses[$possibleMutation]}))
	echo "Mutations $possibleMutation: ${howManyCorrectGuesses[$possibleMutation]} instances predicted, and $notPredicted instances NOT predicted. Success Rate: $successMut%"
      done
END
      





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






