#lang racket
(require "backend.rkt")
(define gifify (call-trick 'libtrick-gif #f))
(define get-image (call-trick 'libtrick-scrape-image #f))
(define image-flip (call-trick 'libtrick-image-flip #f))
(define read-one (curryr (call-trick 'read-n #f) 1))

(define (make-gif time trick args)
  (let ([bytes (~> (call-trick trick args) get-image)]
        [dt (inexact->exact (/ 100 (/ 2 time)))])
    (~> (list (cons bytes dt) (cons (image-flip bytes) dt))
        (gifify 0 0) (make-attachment "flippy.gif" 'image/gif))))

(let loop ([time 1] [args string-args])
  (match (read-one args)
    [(list (or '-t '--time) rest) (apply loop (read-one rest))]
    [(list trick args) (make-gif time trick args)]
    [_ "Usage: `!!flip <(-t --time) [time]> [trick] [args]`"]))
