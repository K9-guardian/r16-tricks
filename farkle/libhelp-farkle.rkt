#lang racket
#<<EOF
Welcome to Farkle (https://en.wikipedia.org/wiki/Farkle)! To start a game, type `!!farkle roll`. You can play alone to learn the game, but to earn a spot on the leaderboard you must challenge someone to a game. The top 6 people will get colored die in the order of the rainbow!

Usage:
`!!farkle roll` to roll the dice.
`!!farkle stay` to end your turn.
`!!farkle keep [dice]` to set aside scoring dice.
`!!farkle keep [-r|--roll] [dice]` to set aside scoring dice and roll.
`!!farkle keep [-s|--stay] [dice]` to set aside scoring dice and stay.
`!!farkle show` to see your current roll.
`!!farkle challenge [username] <[amount]>` to challenge someone to a game to 10,000 points, or `amount` points.
`!!farkle forfeit` to forfeit a game.
`!!farkle leaderboard` to see the leaderboards.
`!!farkle help` to show this page and exit.
EOF
