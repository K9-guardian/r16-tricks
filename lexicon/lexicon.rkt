#lang racket
(require threading)
(require "libdata-lexicon.rkt")
(define (call-trick name _argument)
  (case name
    [(libdata-lexicon) entries]
    [(libsplit-text*) (λ (x _) (list x))]))
(define (make-attachment payload _name _mime) payload)
(define string-args "rod of the depths")

(define lexicon-base "https://botaniamod.net/lexicon.php#")
(define custom-inputs
  '(("tater" . "Tiny Potato")
    ("pew pew" . "Rod of the Unstable Reservoir")))

(define (num-matches title args)
  (define args*
    (or (and~>> custom-inputs
                (assf (curry string-contains? (string-foldcase args)))
                cdr
                string-foldcase)
        (string-foldcase args)))
  (define title* (string-foldcase title))
  (define (smart-string-prefix? str1 str2)
    (define lst (list str1 str2))
    (>= (~>> lst (map string->list) (apply take-common-prefix) length)
        (~>> lst (map string-length) (apply min) (max 3))))
  (for*/sum ([title-str (string-split title*)]
             [arg-str (string-split args*)]
             #:when (smart-string-prefix? title-str arg-str))
    (~>> (list title-str arg-str)
         (map string->list)
         (apply take-common-prefix)
         length)))

(~>> (call-trick 'libdata-lexicon #f)
     (map (λ (entry)
            (cons
             (num-matches (car entry) string-args)
             (cdr entry))))
     (argmax car)
     (match _
         [(cons 0 _) "No matches were found!"]
         [(list _ bookmark text)
          (values
           (~a lexicon-base bookmark)
           (make-attachment
            (string->bytes/utf-8
             (string-join ((call-trick 'libsplit-text* #f) text 80) "\n"))
            "matched.txt"
            ".txt"))]))
