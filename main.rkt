#lang racket/base

(require racket/contract
         racket/match
         racket/runtime-path
         racket/string)

(provide (contract-out
          [pinyin-hash-table hash?]
          [pinyin (-> char? (listof string?))]))

(define-runtime-path pinyin.txt "pinyin.txt")

(module+ test
  (require rackunit)
  (check-true (file-exists? pinyin.txt)))

(define (read-data)
  (call-with-input-file pinyin.txt
    (lambda (in)
      (for/hasheqv ([m (regexp-match*
                        ;; U+3007: líng,yuán,xīng  # 〇
                        #rx"U\\+([0-9a-fA-F]+): +([^ ]+)"
                        in #:match-select cdr)])
        (match-let ([(list hanzi pinyins) m])
          (let ([k (integer->char
                    (string->number (string-append "#x" (bytes->string/utf-8 hanzi))))]
                [v (string-split (bytes->string/utf-8 pinyins) ",")])
            (values k v)))))))

(define pinyin-hash-table (read-data))

(define (pinyin hanzi)
  (hash-ref pinyin-hash-table hanzi))

(module+ test
  ;; Tests to be run with raco test
  (check-equal? (pinyin #\徐) (list "xú")))
