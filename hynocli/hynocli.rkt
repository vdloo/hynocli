#!/usr/bin/env racket
#lang racket

(require net/uri-codec)
(require net/http-client)
(require json)

(provide hynocli)
(provide http-sendrecv-factory)
(provide read-json-factory)
(provide displayln-factory)

(define api-host "api.hypernode.com")
(define api-url "/v1/")
(define api-app-url (format "~aapp/" api-url))
(define environment-variables (current-environment-variables))

(define http-sendrecv-factory (make-parameter http-sendrecv))
(define read-json-factory (make-parameter read-json))
(define displayln-factory (make-parameter displayln))

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
  (λ (uri method #:data [data #f] #:headers [headers (list (format "Authorization: Token ~a" hynocli-token))])
     (let ([http-sendrecv (http-sendrecv-factory)]
	   [read-json (read-json-factory)])
       (define-values (status header response)
         (http-sendrecv
           api-host
           uri
           #:ssl? #t
           #:data data
           #:method method
           #:headers headers))
       (read-json response))))

(define do-patch-request
  (λ (uri #:data [data #f])
    (do-request api-settings-url 
     "PATCH" 
     #:data data
     #:headers
       (list 
         (format "Authorization: Token ~a" hynocli-token)
          "Content-Type: application/x-www-form-urlencoded"))))

(define print-specific-setting
  (λ (setting-to-print settings-response)
   (let ([displayln (displayln-factory)])
     (displayln
       (hash-ref
         settings-response
         (string->symbol setting-to-print)
         (λ () (raise (format "No setting '~a' exists!" setting-to-print))))))))

(define patch-setting
  (λ (api-settings-url setting value)
    (do-patch-request
      api-settings-url
      #:data
      (alist->form-urlencoded
	(list (cons (string->symbol setting) value))))))

(define settings
  (λ (args)
     (let ([settings-response (do-request api-settings-url "GET")])
       (if (empty? args)
         (pretty-print-hasheq settings-response)
	 (print-specific-setting (car args)
           (if (empty? (cdr args))
	     settings-response
	     (patch-setting
	       api-settings-url
	       (car args)
	       (cadr args))))))))

(define hynocli
  (λ (args)
     (cond
       [(empty? args) (display "See --help for options\n")]
       [(equal? (car args) "settings") (settings (cdr args))]
       [else
         (display 
           (format "No such command. See the --help menu for examples\n"))])))
