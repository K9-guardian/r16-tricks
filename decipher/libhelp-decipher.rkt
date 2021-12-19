#lang racket
(define time-limit 60)
(define now (current-seconds))

(define (within-limit timestamp) (> time-limit (- now timestamp)))

(define (remaining-seconds timestamp)
  (format "You have ~a second(s) remaining."
          (- (+ time-limit timestamp) now)))

(define (seconds-away timestamp) (- now (+ time-limit timestamp)))

(define (change-state round-number words players [timestamp (current-seconds)])
  ((hash-ref parent-context 'write-storage)
   'guild
   (hasheq 'timestamp timestamp
           'round-number round-number
           'words words
           'players players)))

(values within-limit remaining-seconds seconds-away change-state)