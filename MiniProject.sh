#!/usr/bin/bash

cards=( 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6 7 7 7 7 8 8 8 8 9 9 9 9 10 10 10 10 11 11 11 11 12 12 12 12 13 13 13 13 )

declare -a player1
declare -a player2

flag=0

player1Play=1
player2Play=1

total1=0
total2=0

winner=""
player1Points=0
player2Points=0

reset()
{
    cards=( 1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4 5 5 5 5 6 6 6 6 7 7 7 7 8 8 8 8 9 9 9 9 10 10 10 10 11 11 11 11 12 12 12 12 13 13 13 13 )

    player1=()
    player2=()

    flag=0

    player1Play=1
    player2Play=1

    total1=0
    total2=0

    winner=""
    clear
}

addToDeck()
{
    if [ $flag -eq 0 ]
    then
        total1=0
        player1+=( "$num" )
        echo -n "Player 1 Cards:"
        echo "${player1[@]}"
        for i in ${player1[*]}
        do
            total1=`expr $total1 + $i`
        done
        echo -n "Sum of Card Values:"
        echo $total1
        echo "~~~~~~~~~~~~~~~~~"
    else
        total2=0
        player2+=( "$num" )
        echo -n "Player 2 Cards:"
        echo "${player2[@]}"
        for i in ${player2[*]}
        do
            total2=`expr $total2 + $i`
        done
        echo -n "Sum of Card Values:"
        echo $total2
        echo "~~~~~~~~~~~~~~~~~"
    fi
}

getWinner()
{
    if [ $total1 -gt $total2 ]
    then
        winner="Player1"
    else
        winner="Player2"
    fi
}

newGame()
{
    echo "LETS START"
    echo " "
    rand=$[$RANDOM % ${#cards[@]}]
    echo "~~~~~~~~~~~~~~~~~"
    num=${cards[$rand]}
    addToDeck num flag
    echo " "
    flag=1
    rand=$[$RANDOM % ${#cards[@]}]
    echo "~~~~~~~~~~~~~~~~~"
    num=${cards[$rand]}
    addToDeck num flag
    flag=0
    del_element=`expr $rand + 1`
    cards=("${cards[@]:0:$((del_element-1))}" "${cards[@]:$del_element}")
}

playGame()
{
    reset
    newGame
    while [ $player1Play -eq 1 ] || [ $player2Play -eq 1 ]
    do
    echo " "
    if [ $flag -eq 0 ]
    then
        echo "Player 1's Chance"
        echo "Current total: $total1"
    else
        echo "Player 2's Chance"
        echo "Current total: $total2"
    fi

    echo -n "Draw another card or Pass (y or n):"
    read draw
    if [ $draw == "y" ]
    then
        rand=$[$RANDOM % ${#cards[@]}]
        echo "~~~~~~~~~~~~~~~~~"
        num=${cards[$rand]}
        if [ $flag -eq 0 ] && [ $player1Play -eq 1 ]
        then
            addToDeck num flag
            if [ $player2Play -eq 1 ]
            then
                flag=1
            fi
        elif [ $flag -eq 1 ] && [ $player2Play -eq 1 ]
        then
            addToDeck num flag
            if [ $player1Play -eq 1 ]
            then
                flag=0
            fi
        fi
        del_element=`expr $rand + 1`
        cards=("${cards[@]:0:$((del_element-1))}" "${cards[@]:$del_element}")


        if [ $total1 -eq 21 ]
        then
            winner="Player1"
            break
        fi

        if [ $total2 -eq 21 ]
        then
            winner="Player2"
            break
        fi



        if [ $total1 -gt 21 ]
        then
            winner="Player2"
            sleep 3s
            clear
            echo "It is a BUST for Player 1"
            sleep 3s
            break
        fi

        if [ $total2 -gt 21 ]
        then
            winner="Player1"
            sleep 3s
            clear
            echo "It is a BUST for Player 2"
            sleep 3s
            break
        fi



     elif [ $flag -eq 0 ] && [ $draw == "n" ]
     then
         player1Play=0
         flag=1

     elif [ $flag -eq 1 ] && [ $draw == "n" ]
     then
         player2Play=0
         flag=0
     fi
     getWinner
    done
}

while true
do
echo -n "Enter choice Play(p) or Quit(q) "
read ch
    case "$ch" in
        p) playGame
        ;;
        q) break
    esac
clear
if [ $winner == "Player1" ]
then
    echo "Player 1 WON!!"
    player1Points=`expr $player1Points + 1`
elif [ $winner == "Player2" ]
then
    echo "Player 2 WON!!"
    player2Points=`expr $player2Points + 1`
fi
echo "Player 1 points: $player1Points"
echo "Player 2 points: $player2Points"
done
