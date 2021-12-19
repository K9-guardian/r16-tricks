#lang racket
;; Tree structure: '(value left right)

(define (validate tree)
  (match tree
    [(list _ '() ...) #t]
    [(list v (? list? l r)) (if (<= (car l) v (car r)) (andmap validate (list l r)) #f)]
    [_ #f]))