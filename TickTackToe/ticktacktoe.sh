#!/bin/bash

PLAYER1=x
PLAYER2=o
COMPUTER=o
PLAYERSYMBOL=$PLAYER1
PLAYERNAME=PLAYER1
STOPGAME=false
RANGE='^[1-9]$'
COUNTER=0

table=(1 2 3 4 5 6 7 8 9)

printBoard() {
  clear
  echo " ${table[0]} | ${table[1]} | ${table[2]} "
  echo "-----------"
  echo " ${table[3]} | ${table[4]} | ${table[5]} "
  echo "-----------"
  echo " ${table[6]} | ${table[7]} | ${table[8]} "
  echo "============="

}
saveGame() {
  str=""
  for ((x = 0; x < 9; x++)); do
    str=$str"${table[$x]} "
  done
  str=$str"$PLAYERSYMBOL"
  echo "$str" >save.txt

}

loadGame() {
  exec 3<>./save.txt
  read -u 3 -a tab

  for ((x = 0; x < 9; x++)); do
    table[$x]=${tab[$x]}
  done

  exec 3>&-
  printBoard
}

saveSetup() {
  if [[ $OPTION == 1 ]]; then
    PLAYERSYMBOL=${tab[9]}
  elif [[ $OPTION == 2 ]]; then
    if [[ ${tab[9]} == "x" ]]; then
      PLAYERNAME=PLAYER1
      PLAYERSYMBOL=${tab[9]}
    elif [[ ${tab[9]} == "o" ]]; then
      computerMove
    fi
  fi
}

playerMove() {
  if [[ $STOPGAME == false ]]; then
    printf "Chose position (1-9) or save (S) "
    read POSITION

    if [[ $POSITION = S ]] || [[ $POSITION = s ]]; then
      saveGame
      printf "Saved, Chose position (1-9): "
      read POSITION
    fi

    while [[ ${table[$POSITION - 1]} == "x" ]] || [[ ${table[$POSITION - 1]} == "o" ]]; do
      printf "Chosen, Chose another position (1-9): "
      read POSITION
    done

    while ! [[ $POSITION =~ $RANGE ]]; do
      printf "Invalid input, Chose position (1-9): "
      read POSITION
    done

    table[$POSITION - 1]=$PLAYERSYMBOL
    if [[ $OPTION == 1 ]]; then
      changePlayer
    else
      PLAYERNAME=PLAYER1
    fi
    COUNTER=$((COUNTER + 1))
  fi

}

changePlayer() {
  if [[ $PLAYERSYMBOL == $PLAYER1 ]]; then
    PLAYERSYMBOL=$PLAYER2
    PLAYERNAME=PLAYER2
  elif [[ $PLAYERSYMBOL == $PLAYER2 ]]; then
    PLAYERSYMBOL=$PLAYER1
    PLAYERNAME=PLAYER1
  fi

}

computerMove() {
  if [[ $STOPGAME == false ]]; then
    position=$(($RANDOM % (9)))
    while [[ ${table[$position]} == "x" ]] || [[ ${table[$position]} == "o" ]]; do
      position=$(($RANDOM % (9)))
    done
    PLAYERNAME=COMPUTER
    table[$position]=$COMPUTER
    COUNTER=$((COUNTER + 1))
  fi
}

checkWin() {
  if [[ ${table[0]} == ${table[1]} ]] && [[ ${table[1]} == ${table[2]} ]]; then
    STOPGAME=true
  elif [[ ${table[3]} == ${table[4]} ]] && [[ ${table[4]} == ${table[5]} ]]; then
    STOPGAME=true
  elif [[ ${table[6]} == ${table[7]} ]] && [[ ${table[7]} == ${table[8]} ]]; then
    STOPGAME=true
  elif [[ ${table[0]} == ${table[4]} ]] && [[ ${table[4]} == ${table[8]} ]]; then
    STOPGAME=true
  elif [[ ${table[2]} == ${table[4]} ]] && [[ ${table[4]} == ${table[6]} ]]; then
    STOPGAME=true
  elif [[ ${table[0]} == ${table[3]} ]] && [[ ${table[3]} == ${table[6]} ]]; then
    STOPGAME=true
  elif [[ ${table[1]} == ${table[4]} ]] && [[ ${table[4]} == ${table[7]} ]]; then
    STOPGAME=true
  elif [[ ${table[2]} == ${table[5]} ]] && [[ ${table[5]} == ${table[8]} ]]; then
    STOPGAME=true
  elif [ $COUNTER == 9 ]; then
    STOPGAME=true
  fi

}

showResult() {
  if [[ $COUNTER == 9 ]]; then
    echo "GAME OVER"
  else
    changePlayer
    echo "${PLAYERNAME} WON"
  fi

}

gameType() {
  if [[ $OPTION == 1 ]]; then
    while [[ $STOPGAME == false ]]; do
      printBoard
      playerMove
      checkWin
    done

  elif [[ $OPTION == 2 ]]; then
    while [[ $STOPGAME == false ]]; do
      printBoard
      playerMove
      checkWin
      computerMove
      checkWin
    done
  fi
}

clear
echo "PLAYER VS PLAYER - 1"
echo "PLAYER VS COMPUTER - 2"
echo "LOAD GAME - L"
read OPTION
gameType
if [[ $OPTION == L ]] || [[ $OPTION == l ]]; then
  loadGame
  printBoard
  echo "PLAYER VS PLAYER - 1"
  echo "PLAYER VS COMPUTER - 2"
  read OPTION
  saveSetup
  gameType
fi

if [[ $STOPGAME == true ]]; then
  printBoard
  showResult
fi
