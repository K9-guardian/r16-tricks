#lang racket
(define (take* l n) (if (< (length l) n) l (take l n)))

(define (update-leaderboard players round-number [display-new-record? #f])
  (define (updater prev-round-number)
    (define maximum (max round-number prev-round-number))
    (when (and display-new-record? (= maximum round-number))
      (displayln "New Record!"))
    (max round-number prev-round-number))
  (or
   (and~> (read-storage 'guild)
          (hash-update (sort players string<?) updater round-number)
          (write-storage 'guild _))
   (write-storage 'guild (hash players round-number))))

(define (show-leaderboard)
  (displayln "**Top 20 unscramblers:**")
  (and~> (read-storage 'guild)
         hash->list (sort >= #:key cdr) (take* 20)
         (map
          (match-lambda
            [(cons players round-number)
             (format "~a: ~a round(s)"
                     (~>> players
                          (map (curry format "<@!~a>"))
                          (string-join _ ", "))
                     round-number)]) _)
         (string-join _ "\n") display))

(values update-leaderboard show-leaderboard)
