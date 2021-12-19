#lang racket
(require threading)
(define read-two (curryr (call-trick 'read-n #f) 2))

(define (typoglycemia s)
  (~>> s
       (regexp-match* #px"<a?:\\w+:\\d+>|\\p{L}+|\\P{L}+")
       (map (λ (w)
              (if (regexp-match #px"\\p{L}+" w)
                  (match (string->list w)
                    [(list f m ... l) (apply ~a `(,f ,@(shuffle m) ,l))]
                    [_ w]) w)))
       (apply ~a)))

(match (read-two string-args)
  [(list (or "-t" "--trick") (app ~a trick) args) (typoglycemia (call-trick trick args))]
  ['() "Usage: `!!typoglycemia [text]`\n`!!typoglycemia [-t --trick] [trick] [args]`"]
  [_ (typoglycemia string-args)])