#lang racket
(cond
  [(and parent-context (member (hash-ref parent-context 'trick-name) '("mastermind" "mm")))
   (read-storage 'guild)]
  [(and (not parent-context) (equal? message-author "334372802410840065"))
   (delete-caller)
   (cond
     [(string-prefix? string-args "+")
      (~>> (read-storage 'guild)
           (vector-append (vector (substring string-args 1)))
           (write-storage 'guild))]
     [(string=? string-args "upload")
      (~>> (open-attachment) port->string
           (string-split _ "\n") list->vector
           (write-storage 'guild))]
     [else
      (~>> (read-storage 'guild)
           (vector-filter-not (curry equal? string-args))
           (write-storage 'guild))])])
