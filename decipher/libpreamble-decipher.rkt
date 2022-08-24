#lang racket
'((define-values (round-number->words format-phrase) (call-trick 'libwords-decipher #f))
  (define-values (within-limit remaining-seconds seconds-away change-state) (call-trick 'libhelp-decipher #f))
  (define-values (update-leaderboard show-leaderboard) (call-trick 'libleaderboard-decipher #f))
  (define ~aln (curry ~a #:separator "\n")))
