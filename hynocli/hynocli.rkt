#!/usr/bin/env racket
#lang racket

(require net/http-client)
(require json)

(provide hynocli)

(define api-host "api.hypernode.com")
(define api-url "/v1/")
(define api-app-url (format "~aapp/" api-url))
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

(define api-settings-url (format "~a~a/" api-app-url hynocli-app))

(define pretty-print-hasheq
  (λ (to-print #:indent [indent ""])
     (hash-for-each 
       to-print
       (λ (hash-key hash-value)
          (if (hash? hash-value)
            (begin
              (display (format "~a:\n" hash-key))
              (pretty-print-hasheq hash-value #:indent (format "~a  " indent)))
            (display (format "~a~a: ~a\n" indent hash-key hash-value)))))))

(define do-request
  (λ (uri method #:data [data #f])
     (define-values (status header response)
       (http-sendrecv
         api-host
         uri
         #:ssl? #t
         #:data data
         #:method method
         #:headers (list (format "Authorization: Token ~a" hynocli-token))))
     (read-json response)))

(define settings
  (λ (args)
     (let ([settings-response (do-request api-settings-url "GET")])
       (if (empty? args)
         (pretty-print-hasheq settings-response)
         (if (empty? (cdr args))
           (displayln
             (hash-ref
               settings-response
               (string->symbol (car args))
               (λ () (raise (format "No setting '~a' exists!" (car args))))))
           (displayln "Patching settings not implemented yet!"))))))

(define hynocli
  (λ (args)
     (cond
       [(empty? args) (display "See --help for options\n")]
       [(equal? (car args) "settings") (settings (cdr args))]
       [else
         (display 
           (format "No such command. See the --help menu for examples\n"))])))
