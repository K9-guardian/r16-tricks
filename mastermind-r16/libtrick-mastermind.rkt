#lang racket
(define-values (hit wrong-loc empty) (call-trick 'libphrase-mastermind 'all))
(define emote-sort
  (λ~>>* (map (curry index-of (call-trick 'libphrase-mastermind 'motes))) (apply <)))

(define (make-phrase guess word)
  (let ([frequencies
         (~>> word string->list (group-by identity)
              (map (λ (lst) (cons (car lst) (length lst))))
              make-hasheq)]
        [word (string-downcase word)])
    (sort
     (for/list ([ch guess]
                [x
                 (for/list ([a guess] [b word])
                   (if (char=? a b)
                       (begin (hash-update! frequencies a sub1) hit)
                       empty))])
       (if (and (string=? empty x)
                (positive? (hash-ref frequencies ch 0)))
           (begin (hash-update! frequencies ch sub1) wrong-loc)
           x))
     emote-sort)))
make-phrase