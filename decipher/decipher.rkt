#lang racket
(for-each eval (call-trick 'libpreamble-decipher #f))

(define (start-game)
  (match (read-storage 'guild)
    [(hash-table ('timestamp timestamp) ('round-number round-number) ('players players))
     (if (within-limit timestamp)
         "There is currently a game in progress!"
         (begin (update-leaderboard players round-number) (next-round 0 '())))]
    [_ (next-round 0 '())]))

(define (end-game round-number words players timestamp)
  (update-leaderboard players round-number #t)
  (write-storage 'guild #f)
  (format "You've run out of time! You were ~a second(s) away!\nYou lasted ~a round(s).\nThe solution was ||~a||."
          (seconds-away timestamp)
          round-number
          (~>> words (map (curry format "`~a`")) string-join)))

(define (next-round round-number players)
  (let* ([round-number (add1 round-number)]
         [words (round-number->words round-number)]
         [players (set-add players message-author)])
    (change-state round-number words players)
    (format-phrase round-number words)))

(define (continue-game guesses)
  (match (read-storage 'guild)
    [(hash-table
      ('timestamp timestamp) ('round-number round-number)
      ('words words) ('players players))
     (if (within-limit timestamp)
         (let ([remaining-words (set-subtract words (map string-foldcase guesses))])
           (cond
             [(empty? remaining-words)
              (~aln "That guess is **correct**!" (next-round round-number players))]
             [(set=? remaining-words words)
              (~aln "That guess is **wrong**!"
                    (remaining-seconds timestamp)
                    (format-phrase round-number words))]
             [else
              (change-state round-number remaining-words (set-add players message-author) timestamp)
              (~aln "Almost there!"
                    (remaining-seconds timestamp)
                    (format-phrase round-number remaining-words))]))
         (end-game round-number words players timestamp))]
    [_ "You are not currently in a game!\nType `!!dc [-b|--begin]` to start playing!"]))

(match string-args
  ["" (call-trick 'libdoc-decipher #f)]
  [(or "-b" "--begin") (start-game)]
  [(or "-l" "--leaderboard") (show-leaderboard)]
  [guesses (continue-game (string-split guesses #px"[,\\s]+"))])
