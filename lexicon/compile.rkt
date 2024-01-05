#!/usr/bin/env racket
#lang racket
(require json threading)

(define en-us (call-with-input-file "en_us.json" read-json))
(define entries (find-files (λ~> file-or-directory-type (eq? 'file)) "entries"))

(call-with-output-file "lexicon-src.txt"
  (curry write
         (for/list ([path entries])
           (match (call-with-input-file path read-json)
             [(hash-table ('name name) ('pages pages))
              (define title (hash-ref en-us (string->symbol name)))
              (define address (~>> path (find-relative-path "entries") (path-replace-extension _ "") path->string))
              (define text (~>> pages
                                (filter (λ~> (hash-ref 'type) (member '("quest" "text"))))
                                (map (λ~> (hash-ref 'text)
                                          string->symbol
                                          (hash-ref en-us _)
                                          (regexp-replace* #px"\\$\\(.*?\\)" _ "")))
                                (string-join _ "\n")))
              (list title address text)])))
  #:exists 'replace)
