#lang racket

(define vaz-motes
  '("<:pog:805133520191488090>"
    "<:pausechamp:805152666950434866>"
    "<:clueless:805133519755149332>"))

(define normal-motes
  '(":white_circle:"
    ":red_circle:"
    ":black_circle:"))

(define jane-motes
  '("<:snomlove:805186487338795008>"
    "<:snom:805168920159059999>"
    "<:waaaaaaa:805168920759107594>"))

(define curr-motes
  (cond
    [(equal? message-author "166270844316811275") jane-motes]
    [(read-storage 'user) vaz-motes]
    [else normal-motes]))

(match (read-args)
  ['(all) (apply values curr-motes)]
  ['(motes) curr-motes]
  ['(hit) (car curr-motes)]
  ['(toggle) (write-storage 'user (not (read-storage 'user)))])