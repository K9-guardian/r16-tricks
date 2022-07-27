#lang racket
(provide entries)

(define (read-storage storage)
  (~>
   "libbase64-lexicon.txt"
   open-input-file
   read))

(require threading net/base64 file/gunzip)

(define-values (in out) (make-pipe))

(~>
 (read-storage 'guild)
 base64-decode
 open-input-bytes
 (gunzip-through-ports out))

(define entries (read in))