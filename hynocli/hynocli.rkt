#!/usr/bin/env racket
#lang racket

(provide hynocli)

(define environment-variables (current-environment-variables))

(define-syntax-rule (configure-environment-variables env-var-var-name env-var-name message)
  (begin
    (define env-var-var-name
      (environment-variables-ref environment-variables env-var-name))
    (if (not env-var-var-name)
      (raise (format "Before you run hynocli first export the required environment variables: ~a" message))
      (void))))

(configure-environment-variables hynocli-app #"HYNOCLI_APP" "export HYNOCLI_APP=your_app_name")
(configure-environment-variables hynocli-token #"HYNOCLI_TOKEN" "export HYNOCLI_TOKEN=your_api_token")

(define hynocli
  (λ (args)
     (display hynocli-app)
     (display hynocli-token)
     (display args)))
