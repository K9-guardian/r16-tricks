#lang racket
(require pict)

(define get-image (call-trick 'libtrick-scrape-image #f))
(define read-one (curryr (call-trick 'read-n #f) 1))
(define gifify (call-trick 'libtrick-gif #f))

(define (smart-scale pict i frames)
  (let ([mag (abs (cos (* pi (/ i frames))))])
    (if (< (* mag (pict-height pict)) 1) (blank 1) (scale pict 1 mag))))

(define (make-boing-boing time fps trick args)
  (let ([frames (exact-round (* time fps))]
        [dt (exact-round (/ 100 fps))]
        [pict (get-image (call-trick trick args))])
    (~> (build-list frames
          (lambda (i)
            (let ([scaled-pict (smart-scale pict i frames)])
              (cons (pin-over (ghost pict) 0 (- (pict-height pict) (pict-height scaled-pict)) scaled-pict) dt)))) 
        (gifify 0) (make-attachment "boingboing.gif" 'image/gif))))

(let loop ([time 1] [fps 30] [args string-args])
  (match (read-one args)
    [(list (or '-t '--time) (app read-one (list time rest)))
     (loop time fps rest)]
    [(list (or '-f '--fps) (app read-one (list fps rest)))
     (loop time fps rest)]
    [(list trick rest)
     (make-boing-boing time fps trick rest)]
    [_ "Usage: `!!bounce <(-t --time) [time]> <(-f --fps) [fps]> [trick] [args]`"]))