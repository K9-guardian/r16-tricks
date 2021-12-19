#lang racket
(require racket/random)
(define level-up 5)
(define words (read-storage 'guild))

(define (round-number->words round-number)
  (random-sample words (ceiling (/ round-number level-up)) #:replacement? #f))

(define (format-phrase round-number words)
  (format "Round ~a: ~a"
          round-number
          (~>> words
               (map (λ~>> string->list shuffle (apply ~a) (format "`~a`")))
               string-join)))

(match string-args
  ["upload" #:when (equal? message-author "334372802410840065")
   (delete-caller)
   (~>> (open-attachment)
        port->string
        (string-split _ "\n")
        list->vector
        (write-storage 'guild))]
  [_ (values round-number->words format-phrase)])