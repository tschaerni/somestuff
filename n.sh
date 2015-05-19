#!/usr/bin/zsh
function n() {
	if [[ "$#" = "0" ]]
	then
		echo "Usage:         n <name of note>"
		echo "list notes:    n -ls"
		echo "remove notes:  n -rm or -del or --delete"
	else
		case "$1" in
		"-ls")
			shift
			if [[ -z "$1" ]]
			then
				ls -lt ~/notes/
			else
				ls -lt ~/notes/*$**
			fi
		;;
		"-rm"|"-del"|"--delete")
			shift
			if ls ~/notes/*$** &> /dev/null
			then
				NUMNOTES=$(ls -l ~/notes/*$** | wc -l)
				if [[ "$NUMNOTES" > "1" ]]
				then
					echo "there are more then one file with the given name:"
					echo ""
					ls -lt ~/notes/*$**
					echo ""
					echo "please specify"
				else
					NOTE=$(ls ~/notes/*$**)
					read "NOTEDEL?delete $NOTE ? [y/N]: "
					if [[ "${(L)NOTEDEL}" = "y" || "${(L)NOTEDEL}" = "yes" ]]
					then
						rm -v "$NOTE"
						echo "deleted"
					else
						echo "abort"
					fi
				fi
			fi
		;;
		*)
			if ls ~/notes/*$** &> /dev/null
			then
				NUMNOTES=$(ls -l ~/notes/*$** | wc -l)
				if [[ "$NUMNOTES" > "1" ]]
				then
					echo "there are more then one file with the given name:"
					echo ""
					ls -lt ~/notes/*$**
					echo ""
					echo "please specify"
				else
					NOTE=$(ls ~/notes/*$**)
					$EDITOR $NOTE
				fi
			else
				$EDITOR ~/notes/"$*".txt
			fi
		;;
		esac
	fi
}
