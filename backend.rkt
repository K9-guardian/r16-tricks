;; Define r16 internals so lsp shuts up
#lang racket
(require threading)
(provide (all-defined-out) (all-from-out threading))

(define (call-trick name argument) #f)
(define string-args "")
(define trick-name "")
(define (read-args) '())
(define parent-context #f)

(define (delete-caller) (void))
(define (emote-lookup) #f)
(define (emote-image id) #f)
(define (make-attachment payload name mime) #f)
(define message-contents "")
(define (read-storage type) #f)
(define (write-storage type data) #f)
(define (attachment-data attachment) #"")
(define (open-attachment [index 0]) #f)
(define (open-reply-attachment [index 0]) #f)
(define attachment-count 0)
(define reply-attachment-count 0)
(define reply-contents #f)
