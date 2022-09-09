#lang racket
'((define help (call-trick 'libhelp-farkle #f))
  (define farkle (call-trick 'libgame-farkle #f))
  (define d6? (conjoin exact-integer? (λ (f) (<= 1 f 6))))
  (define d6s? (curry andmap d6?))
  (define leaderboard (call-trick 'libleaderboard-farkle #f)))
