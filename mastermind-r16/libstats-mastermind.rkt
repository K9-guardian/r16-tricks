#lang racket
(define (take* l n) (if (< (length l) n) l (take l n)))

(define (update-leaderboard*)
  (and~> (read-storage 'user)
         (match [(cons word guess-count) (update-leaderboard word guess-count)]
           [_ (void)])))

(define (update-leaderboard word guess-count)
  (or
   (and~> (read-storage 'guild)
          (hash-update
           message-author
           (λ~> (list (cons word guess-count)) (sort < #:key cdr) car)
           (cons word guess-count))
          (write-storage 'guild _))
   (write-storage 'guild (hash message-author (cons word guess-count)))))

(define (read-stats)
  (update-leaderboard*)
  (displayln "**Top 20 codebreakers:**")
  (and~> (read-storage 'guild)
         hash->list (sort <= #:key cddr) (take* 20)
         (map
          (match-lambda
            [(list* id word guess-count)
             (format "<@!~a>: `~a`, ~a guess(es)" id word guess-count)]) _)
         (string-join "\n") display)
  (and~> (read-storage 'guild) (hash-ref message-author)
         (match [(cons word guess-count)
                 (format "Your stats: `~a`, ~a guess(es)" word guess-count)])))

(define (update-stats word guess-count)
  (update-leaderboard*)
  (update-leaderboard word guess-count)
  (match (read-storage 'user)
    [(cons _ pguess-count)
     (when (< guess-count pguess-count)
       (write-storage 'user (cons word guess-count))
       (displayln "New record!"))]
    [_ (write-storage 'user (cons word guess-count))
       (displayln "New record!")]))

(values read-stats update-stats)
