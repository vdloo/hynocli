#!/usr/bin/env racket
#lang racket

(require racket/function)

(require "commandline.rkt")
(require "hynocli.rkt")

(provide main)

(define (main #:parse-with [parse-args parse-args]
              #:hynocli-with [hynocli hynocli])
  (parse-args hynocli))
