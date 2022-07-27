#lang racket
(define vazcoin (call-trick 'libvazcoin #f))
(define-values (_ clear-history _1) (call-trick 'libhistory-mastermind #f))
(define funds (vazcoin '(query)))
(define loss-amt 5)

(define (get-user-data)
  (match ((hash-ref parent-context 'read-storage) 'user)
    [(list word gambling? guess-count) (values word gambling? guess-count)]
    [_ (values #f #f 1)]))

(define (toggle-gambling)
  (let-values ([(_ gambling? _1) (get-user-data)])
    (cond
      [(and (not gambling?) (< funds loss-amt))
       (format "You don't have enough Vazcoins! You need ~a more to gamble."
               (exact->inexact (- loss-amt funds)))]
      [else
       (let ([gambling? (not gambling?)])
         ((hash-ref parent-context 'write-storage) 'user (list #f gambling? 1))
         (clear-history)
         (format "You have ~a gambling. Started a new game."
                 (if gambling? "enabled" "disabled")))])))

(values get-user-data toggle-gambling)