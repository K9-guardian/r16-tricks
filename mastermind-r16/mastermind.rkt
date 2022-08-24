#lang racket
(require racket/random)
(for-each eval (call-trick 'libpreamble-mastermind #f))

(define (abandon-game)
  (let-values ([(word gambling? _) (get-user-data)])
    (if word
        (begin
          (write-storage 'user (list #f gambling? 1)) (clear-history)
          (format "Restarting the game. The word was ||`~a`||." word))
        "You need to make a guess to abandon a game!")))

(define (play-game guess)
  (let*-values ([(word gambling? guess-count) (get-user-data)]
                [(word) (or word (random-ref (get-words)))]
                [(phrase) (get-phrase guess word)])
    (cond
      [(and gambling? (< funds loss-amt))
       (write-storage 'user #f) (clear-history)
       (format "You don't have enough Vazcoins! You need ~a more to gamble. Starting a new (gambling free) game."
               (exact->inexact (- loss-amt funds)))]
      [(= 4 (count (curry string=? hit) phrase))
       (write-storage 'user (list #f gambling? 1)) (clear-history)
       (update-stats guess guess-count)
       (when gambling?
         (vazcoin `(add ,win-amt))
         (printf "You have won `~a` Vazcoin(s)!" win-amt))
       (format "Congratulations! <@!~a>\nYou took ~a guess(es)." message-author guess-count)]
      [else
       (write-storage 'user (list word gambling? (add1 guess-count))) (add-history guess)
       (printf "This is your ~a guess." (call-trick 'libtrick-ordinals guess-count))
       (when gambling?
         (vazcoin `(deduct ,loss-amt)) (pot-add loss-amt)
         (printf "You have lost `~a` Vazcoin(s)!" loss-amt))
       (apply ~a phrase)])))

(when (or (not parent-context) (member (hash-ref parent-context 'trick-name) '("mm")))
  (match string-args
    ["" (call-trick 'libdoc-mastermind #f)]
    [(or "-t" "--toggle-gambling") (toggle-gambling)]
    [(or "-l" "--leaderboard") (read-stats)]
    [(or "-a" "--abandon") (abandon-game)]
    [(or "-h" "--history") (get-history)]
    ["--toggle-emotes" (toggle-emotes)]
    [(? (λ~> string-length (= 4)) guess) (play-game guess)]
    [_ "Please enter a 4 letter word!"]))
