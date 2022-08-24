#lang racket
#<<EOF
This trick plays the game mastermind with 4 letter words (https://en.wikipedia.org/wiki/Mastermind_(board_game)). White circle means correct letter and correct place, red circle means correct letter but incorrect place, and black circle means no matches (different from Wikipedia colors for visibility). The colors don't correspond to positions, so make sure to pay attention to amount rather than positioning!
Type `!!mastermind [word]` to start playing!
Type `!!mastermind [-h|--history]` to see your previous guesses!
Type `!!mastermind [-a|--abandon]` to start a new game!
Type `!!mastermind [-t|--toggle-gambling]` to switch between betting Vazcoin!
Type `!!mastermind [-l|--leaderboard]` to see the leaderboards!
EOF
