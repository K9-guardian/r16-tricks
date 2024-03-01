#lang racket
(require threading)
(define entries (call-with-input-file "lexicon-src.txt" read))
(define (call-trick name _argument)
  (case name
    [(libdata-lexicon) entries]
    [(libsplit-text*) (λ (x _) (list x))]))
(define (make-attachment payload _name _mime) payload)
(define string-args "flugel")

(define ignored-words '( "a" "and" "in" "of" "the" "to" "with"))
(define lexicon-base "https://botaniamod.net/lexicon.html#")

(define (edit-distance str1 str2)
  (define rows (add1 (string-length str1)))
  (define cols (add1 (string-length str2)))
  (define dp (make-vector (* rows cols) 0))
  (define (coord r c) (+ (* r cols) c))
  (for ([i (range 1 rows)]) (vector-set! dp (coord i 0) i))
  (for ([j (range 1 cols)]) (vector-set! dp (coord 0 j) j))
  (for* ([j (range 1 cols)] [i (range 1 rows)])
    (define substitution-cost (if (eq? (string-ref str1 (sub1 i)) (string-ref str2 (sub1 j))) 0 1))
    (vector-set! dp
                 (coord i j)
                 (min (add1 (vector-ref dp (coord (sub1 i) j)))
                      (add1 (vector-ref dp (coord i (sub1 j))))
                      (+ (vector-ref dp (coord (sub1 i) (sub1 j))) substitution-cost))))
  (vector-ref dp (coord (sub1 rows) (sub1 cols))))

(define (distance title arg)
  (define title-words (string-split (string-foldcase title)))
  (define arg-words (string-split (string-foldcase arg)))
  (for/sum ([arg-str arg-words])
    (~>> (for/list ([title-str title-words]
                    #:unless (member title-str ignored-words))
           (edit-distance arg-str title-str))
         (cons +inf.0)
         (apply min))))

(~>> (call-trick 'libdata-lexicon #f)
     (filter (λ~>> car string-split length (<= (~> string-args string-split length))))
     (map (λ (entry) (cons (distance (car entry) string-args) entry)))
     (sort _ (λ (p1 p2)
               (cond
                 [(< (car p1) (car p2)) #t]
                 [(> (car p1) (car p2)) #f]
                 [else (< (cdr p1) (cdr p2))]))
           #:key (λ (item) (cons (car item) (string-length (cadr item)))))
     car
     (match _
       [(list _ _ bookmark text)
        (values
         (~a lexicon-base bookmark)
         (make-attachment
          (string->bytes/latin-1
           (string-join ((call-trick 'libsplit-text* #f) text 80) "\n"))
          "matched.txt"
          ".txt"))]))
