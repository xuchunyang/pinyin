#lang racket/base

(module+ test
  (require rackunit))

;; Notice
;; To install (from within the package directory):
;;   $ raco pkg install
;; To install (once uploaded to pkgs.racket-lang.org):
;;   $ raco pkg install <<name>>
;; To uninstall:
;;   $ raco pkg remove <<name>>
;; To view documentation:
;;   $ raco docs <<name>>
;;
;; For your convenience, we have included a LICENSE.txt file, which links to
;; the GNU Lesser General Public License.
;; If you would prefer to use a different license, replace LICENSE.txt with the
;; desired license.
;;
;; Some users like to add a `private/` directory, place auxiliary files there,
;; and require them in `main.rkt`.
;;
;; See the current version of the racket style guide here:
;; http://docs.racket-lang.org/style/index.html

;; Code here

(require racket/runtime-path            ; `define-runtime-path'
         racket/string                  ; `string-append'
         racket/match)                  ; `match-let'

(provide pinyin-hash-table pinyin)

(define-runtime-path pinyin.txt "pinyin.txt")

(module+ test
  (check-true (file-exists? pinyin.txt)))

(define (read-data)
  (call-with-input-file pinyin.txt
    (lambda (in)
      (for/hash ([m (regexp-match*
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

;; $ racket -l pinyin 汉字
;; $ raco pinyin 汉字
(module+ main
  ;; Main entry point, executed when run with the `racket` executable or DrRacket.
  (let ([args (current-command-line-arguments)])
    (if (not (= (vector-length args) 1))
        (error "Usage: <pinyin> chars")
        (for ([c (vector-ref args 0)])
          (let ([v (hash-ref pinyin-hash-table c #f)])
            (if v
                (printf "~a: ~a\n" c (string-join v ", "))
                (printf "~a: ~a\n" c c)))))))
