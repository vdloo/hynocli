#!/usr/bin/env racket
#lang racket

(require rackunit)
(require rackunit/text-ui)

(require "../main.rkt")

(module+ test
  (define main-tests
    (test-suite
      "Testsuite for hynocli/main.rkt -> main"
      (test-case
        "Test that main calls parse-args with hynocli as the argument"
        (define mock-hynocli 'mock-hynocli)
        (define mock-parse-with (λ (arg) (check-equal? arg mock-hynocli)))

        (main #:parse-with mock-parse-with
              #:hynocli-with mock-hynocli))
      ))

(run-tests main-tests))
