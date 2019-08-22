#!/bin/bash
#Mini_Project Guess the word!

function_game_guide()
{
	echo "1.Admin will input a hidden word and a word hint" 
	echo "Enter to continue"
	read -r -s enter 
	echo "2.You will import a character to gues the hidden word"
	echo "Enter to continue"
	read -r -s enter 
	echo "3.You will continue guessing until the word is discoveried.
Game is ended if the hidden word is found or your scores is 0"
	echo "Enter to continue"
	read -r -s enter 
	echo "Your score will be calculated:
Scores = Lenght_of_word + Success_count - Failue_count"
	
}

function_view_high_scores()
{
	sort -nr hight_score.txt
}

function_show_word()
{
	for (( j=0; j<${#hidden_word}; j++ )); do
		if [[ ${hidden_word:j:1} != " " ]];	then
			echo -n "${word_guessed[j]}"
		else
			echo -n " "
		fi	
	done
}

function_check_character()
{
	local lenght=1
	if [[ $lenght != ${#c_input} || $c_input =~ [0-9] ]]; then
		echo "Please input must a character!"
	elif [[ $c_input =~ ^[a-zA-Z] ]]; then
		c_input=${c_input,,}
		break
	else
		echo "Please input alphabetic character!"
	fi
}

function_play_game()
{
	echo
	echo "####### WELLCOME TO GUESS THE WORD ########"
	echo "-------------------------------------------"
	
	local lenght=1
	local scores=0
	local i=0
	local num_true=0
	local num_false=0
	local num_fales_consecutive=0
	local lenght_word=0
	local hidden_word
	
	printf "Enter a hidden word(LOWER 25 characters): "
	while IFS= read -r -s -n1 word; do
		if [[ -z "$word" || !(25 -ge ${#hidden_word}) ]]; then
			if [[ !( -z "$hidden_word" ) && ( 25 -ge ${#hidden_word} ) ]]; then
				break
			fi
			echo
			echo "Hidden word is emtpty or Hidden word more than 25 characters. Please enter again!"
			hidden_word=""
			printf "Enter a hidden word(LOWER 25 characters): "

		elif [[ $hidden_word =~ [0-9] ]]; then
			echo
			echo "Hidden word have number or special characters. Please enter again!"
			hidden_word=""
			printf "Enter a hidden word(LOWER 25 characters): "

		else
			word=${word,,}
			case "$word" in
			*\ *)
				word_guessed[i]=' '
				echo -n "$word_guessed"
				;;
			*)
				word_guessed[i]='*'
				echo -n "$word_guessed"
				;;
			esac
			hidden_word+=$word
		fi

	done

	echo
	while [ 1 ]; do
		read -p "Enter a word hint: " c_input
		function_check_character
	done
	
	printf "Word: "
	for ((i=0; i<${#hidden_word}; i++)); do
		if [[ ${hidden_word:i:1} != " " ]];	then
			echo -n "*"
			lenght_word=$((lenght_word+1))	
		else
			echo -n " "
		fi
	done
	echo
	#echo $lenght_word
	scores=$lenght_word
	
	for (( j=0; j<${#hidden_word}; j++ )); do
		word_guessed[$j]="*"
	done
	
	while [[ 0 -lt $scores ]]; 
	do
		guessed=false
		a=0
		b=0
		num_characters=0
		
		while [ 1 ]; do
			echo
			read -r -p "Your next guess: " c_input
			if [[ " ${character_proposed[*]} " == *" $c_input "* ]]; then
				guessed=true
				echo "Character guessed! Please input another alphabetic character!"
			else	
				function_check_character
			fi
		done
	
		character_proposed[$i]=$c_input
	#	echo ${character_proposed[@]}
		i=$((i+1))
		echo "Guess: $c_input"

		if [[ $hidden_word == *$c_input* ]]; then
			for (( j=0; j<${#hidden_word}; j++ )); do
				if [[ ${hidden_word:j:1} == $c_input ]]; then
					num_characters=$((num_characters+1))
				fi
			done
			echo
			echo "CONGRATS, these are $num_characters character '$c_input' in the word!"
			echo
		fi
		
		printf "Word: "
		if [[ $hidden_word == *$c_input* ]]; then
			num_true=$((num_true+1))
	#		echo $num_true
			num_fales_consecutive=0
	#		echo $num_fales_consecutive
			for (( j=0; j<${#hidden_word}; j++ )); do
				if [[ ${hidden_word:j:1} == $c_input ]]; then
					word_guessed[$((j))]=$c_input
	#				echo "$num_characters"
				fi
			done
			function_show_word
		else
			function_show_word
	
			character_missed[$i]=$c_input
			num_fales_consecutive=$((num_fales_consecutive+1))
	#		echo $num_fales_consecutive
			num_false=$((num_false+1))
	#		echo $num_false

		fi

		if [[ 3 -eq $num_fales_consecutive ]]; then
		echo
		echo "You guesed wrong 3 times continuously"
		echo "--------------------------------"
			while true; do
				random=${hidden_word:$(( RANDOM % ${#hidden_word} )):1}
		#		echo $random
				if [[ ! (${word_guessed[*]} =~ $random) ]]; then
					printf "Word: "
#					echo $random
					for (( j=0; j<${#hidden_word}; j++ )); do
						if [[ ${hidden_word:j:1} == $random ]]; then
							word_guessed[$((j))]=$random
						fi
					done

					function_show_word
					
					num_fales_consecutive=0
		#			echo $num_fales_consecutive
					break
				fi
			done
		fi

		echo
		printf "Missed: "
		echo -n "${character_missed[@]}"
		echo
		echo "-------------------------------"
#	clear
		scores=$(($lenght_word + $num_true*2 - $num_false))
	#	echo  "$scores"

	
	#	word_guessed=$(printf '%s' "${word_guessed[@]}")
		for ((j=0; j<${#hidden_word}; j++)); do
			test=$(printf '%s' "${word_guessed[@]}")
		done
	
		for (( j=0; j<${#hidden_word}; j++ )); do
			if [[ ${hidden_word:j:1} != " " ]];	then
				if [[ ${word_guessed[j]} != "*" ]]; then
					a=$((a+1))
				fi
			else
				b=$((b+1))
			fi
		done
		
		if [[ $(($a + $b)) == ${#word_guessed[@]} ]]; then	
			echo "-------------------------------"
			echo "Mission Compledted!"
			echo "You are Awesome!"
			echo "-------------------------------"
			echo "The Answer Is: $hidden_word"
			echo "-------------------------------"
			echo "Your scores: $scores"
			echo "$scores">>hight_score.txt
#			function_view_high_scores
			break
		fi
	done
	
	if [[ 0 == $scores ]]; then
		echo "#########################"
		echo "Mission Failed!"
		echo "The Answer Is: $hidden_word"
		echo "Good bye"
		echo "##########################"
	fi
	
	for (( d=0; d<i; d++)); do
		character_proposed[$d]=' '
	done
	echo ${character_proposed[@]}
}

while true; do
	echo
	echo "#######################################"
	echo
	echo "GUESS THE WORD"
	echo "Main Menu"
	echo "1. Play game now"
	echo "2. Game guide"
	echo "3. High scores"
	echo "4. Quit"
	echo
	echo "#######################################"
	echo -n "Input option: "
	read option
	if [[ !($option =~ [1-4]) ]]; then
		echo "INPUT AGAIN OPTION!"
	fi
	echo
	case $option in
		1)
			function_play_game
			;;
		2)
			function_game_guide
			;;
		3)
			function_view_high_scores
			;;
		4)
			exit 0
			;;
	esac
done
