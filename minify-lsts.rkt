#!/usr/bin/env racket
#lang racket/base
(require racket/port)

(define (file->datums filepath)
  (define fileport (open-input-file filepath))
  (read-language fileport void)
  (for/list ([datum (in-producer read eof fileport)]) datum))

(define (format-unquoted datum)
  (with-output-to-string
    (λ () (print datum (current-output-port) 1))))

(define (format-unquoted* lst)
  (map (λ (x) ((if (list? x) format-unquoted* format-unquoted) x)) lst))

;; '(a b c d) -> '(a " " b " " c " " d)
;; '(a b (c d) e f) -> '(a " " b (c " " d) e " " f)

(define (add-spaces lst)
  (cond
    [(null? lst) '()]
    [(= 1 (length lst)) (if (list? (car lst))
                            (list (add-spaces (car lst)))
                            lst)]
    [else (define first* (car lst))
          (define second* (cadr lst))
          (if (not (or (list? first*) (list? second*)))
              (list* first* " " (add-spaces (cdr lst)))
              (cons (if (list? first*) (add-spaces first*) first*)
                    (add-spaces (cdr lst))))]))

(define (string-join* lst)
  (format "(~a)" (apply string-append (map (λ (x) (if (list? x) (string-join* x) x)) lst))))

(define (minify-file filepath)
  (for-each displayln
            (map
             (λ (datum)
               ((if (and (list? datum)
                         (or (null? datum) (not (memq (car datum) '(quote quasiquote)))))
                    (compose string-join* add-spaces format-unquoted*)
                    format-unquoted)
                datum))
             (file->datums filepath))))

(for-each minify-file (vector->list (current-command-line-arguments)))
