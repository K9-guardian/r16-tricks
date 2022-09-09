#lang racket
(require "../backend.rkt")
(for-each eval (call-trick 'libpreamble-farket #f))

(match (read-args)
  ['(roll ...) (farkle '(roll))]
  ['(show ...) (farkle '(show))]
  [`(keep ,(or '-r '--roll) . ,(? d6s? dice)) (farkle `(keep ,dice))
                                              (farkle '(roll))]
  [`(keep ,(or '-s '--stay) . ,(? d6s? dice)) (farkle `(keep ,dice))
                                              (farkle '(stay))]
  [`(keep . ,(? d6s? dice)) (farkle `(keep ,dice))]
  [`(challenge ,username) (farkle `(play ,username 10000))]
  [`(challenge ,username ,(? real? amt)) #:when (<= amt 1000 100000)
                                         (farkle `(play ,username ,amt))]
  [`(forfeit ...) (farkle '(forfeit))]
  ['(leaderboard ...) (leaderboard '(show))]
  [_ help])
