#lang racket
(require "backend.rkt")
(require pict)

(define read-one (curryr (call-trick 'read-n #f) 1))
(define gifify (call-trick 'libtrick-gif #f))
(define get-image (call-trick 'libtrick-scrape-image #f))

(define (string->prefixes str step [lst '()])
  (let ([indices (regexp-match-positions (pregexp (~a "(<a?:\\w+:\\d+>|:\\w+:|" step ")$")) str)])
    (if indices
        (match-let ([(cons start end) (car indices)])
          (string->prefixes
           (substring str 0 start) step
           (cons (substring str 0 end) lst))) lst)))

(define (all-emotes str) (regexp-match #px"^(<a?:\\w+:\\d+>|:\\w+:){}$" str))

(define (string->rotations str step)
  (let ([lst (regexp-match* (pregexp (~a "<a?:\\w+:\\d+>|:\\w+:|" step)) (if (all-emotes str) str (~a str " ")))])
    (build-list
     (length lst)
     (λ (i)
       (let-values ([(start end) (split-at lst i)])
         (apply ~a (append (list (if (equal? " " (car end)) #\u200B "")) end start)))))))

(define ((text->text style) text)
  (get-image (call-trick 'text (~a (~s style) (if (non-empty-string? text) text "​")))))

(define ((text->image trick args) text)
  (get-image (call-trick (~a trick) (~a args text #:separator " "))))

(define (lst->pairs lst time generator proc text)
  (match generator
    [string->prefixes
     (let ([bb (ghost (proc text))])
       (map (λ (str)
              (cons (pin-under bb 0 0 (proc str))
                    (if (equal? str text) (* 10 time) time))) lst))]
    [string->rotations (map (λ (str) (cons (proc str) time)) lst)]))

(define (make-gif time step generator proc text)
  (~> text (string-trim #:right? #f) (generator step)
      (lst->pairs time generator proc text) (gifify 0 0)
      (make-attachment "typed.gif" 'image/gif)))

(let loop ([time 20] [step "."] [generator string->prefixes] [args string-args])
  (match (read-one args)
    [(list (or '-t '--time) (app read-one (list time rest))) (loop time step generator rest)]
    [(list (or '-w '--word) rest) (loop time "(?>^|\\s*)\\S+(?>$|\\s*)" generator rest)]
    [(list (or '-b '--banner) rest) (loop time step string->rotations rest)]
    [(list (or '-i '--image) (app read-one (list text trick/args)))
     (make-gif time step generator (apply text->image (read-one trick/args)) (~a text))]
    [(list style text) (make-gif time step generator (text->text style) text)]
    [_ "Usage: `!!typed <(-t --time) [time]> <-w --word> <-b --banner> [text-style] [text]`\n`!!typed <(-t --time) [time]> <-w --word> <-b --banner> [(-i --image) [text (quoted)]] [trick args]`"]))
