#lang racket

(define (an->move an)
  (cond
    [(regexp-match standard-move an) => (compose make-immutable-hash
                                                 (curry filter cdr)
                                                 (curry map cons '(piece
                                                                   from-file
                                                                   from-rank
                                                                   to-file
                                                                   to-rank))
                                                 rest)]
    [(regexp-match promotion an) => (compose make-immutable-hash
                                             (curry map cons '(to-file to-rank promotion))
                                             rest)]
    [(regexp-match king-castle an) '(castle king)]
    [(regexp-match queen-castle an) '(castle queen)]))

(define standard-move #rx"^([NBRQK])?([a-h])?([1-8])?x?([a-h])([1-8])[+#]?$")

(define promotion #rx"^([a-h])([18])[=/]?\\(?([NBRQK])\\)?[+#]?$")

(define king-castle #rx"^[0O]-[0O][+#]?$")

(define queen-castle #rx"^[0O]-[0O]-[0O][+#]?$")

(an->move "0-O")
