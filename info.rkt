#lang info
(define collection "pinyin")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define raco-commands '(("pinyin" (submod pinyin main) "run pinyin" #f)))
(define scribblings '(("scribblings/pinyin.scrbl" ())))
(define pkg-desc "Convert Hanzi to Pinyin")
(define version "0.0")
(define pkg-authors '(xcy))
