#!/usr/bin/env racket
#lang racket
(require racket/cmdline)

(provide parse-args)

(define parse-args 
  (λ (entrypoint)
    (command-line
      #:program "hynocli"
      #:usage-help "\nUnofficial command-line client for the Hypernode-API"
      #:ps "\nRun hynocli to talk to the Hypernode-API."
        "examples: "
         "$ racket main.rkt settings"
         "$ racket main.rkt settings php_version"
         "$ racket main.rkt --help"
      #:args args
      (begin
	(entrypoint args)))))
