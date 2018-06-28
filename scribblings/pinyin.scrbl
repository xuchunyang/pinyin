#lang scribble/manual

@(require scribble/eval)
@(define the-eval (make-base-eval '(require pinyin)))

@require[@for-label[pinyin
                    racket/base]]

@title{Pinyin: Convert Hanzi to Pinyin}
@author[(author+email "Xu Chunyang" "mail@xuchunyang.me")]

@defmodule[pinyin]

一个汉字转拼音的函数库.

@defproc[(pinyin [hanzi char?]) (listof string?)]{
  返回汉字对应的拼音.

  @examples[#:eval the-eval
    (pinyin #\中)
    (pinyin #\国)
  ]
}

@defthing[pinyin-hash-table hash?]{
  保存拼音数据的 Hash Table.

  @examples[#:eval the-eval
    (hash-ref pinyin-hash-table #\中)
    (hash-ref pinyin-hash-table #\国)
  ]
}
