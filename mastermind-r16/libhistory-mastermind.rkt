#lang racket

(define (add-history guess)
  (write-storage
   'user
   (or (and~>> (read-storage 'user) (cons guess))
       (list guess))))

(define (clear-history) (write-storage 'user #f))

(define (get-history)
  (let ([hist (read-storage 'user)]
        [word (match ((hash-ref parent-context 'read-storage) 'user)
                [(list word _ _) word] [_ #f])])
    (if (and hist word)
        (for/fold ([str ""]) ([guess (in-list (reverse hist))] [i (in-naturals 1)])
          (~a str (format "~a. `~a`, ~a\n"
                          i guess
                          (apply ~a ((call-trick 'libtrick-mastermind #f) guess word)))))
        "You need to make a guess to view your history!")))

(values add-history clear-history get-history)
