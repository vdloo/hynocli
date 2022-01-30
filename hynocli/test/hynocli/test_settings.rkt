#!/usr/bin/env racket
#lang racket

(require rackunit)
(require rackunit/text-ui)
(require json)

(require "../../hynocli.rkt")

(define mock-ok-status "HTTP/1.1 200 OK")
(define mock-header
  (list "Server: nginx/1.14.2" 
	"Date: Sun, 30 Jan 2022 17:09:32 GMT"
	"Content-Type: application/json"
	"Content-Length: 1989"
	"Connection: close"
	"Allow: GET, PUT, PATCH, DELETE, HEAD, OPTIONS"
	"X-Frame-Options: DENY"
	"Vary: Accept-Language"
	"Content-Language: en "
	"X-Content-Type-Options: nosniff"
	"Referrer-Policy: same-origin"
	"Strict-Transport-Security: max-age=15778463"
	"X-Frame-Options: DENY"
	"X-Content-Type-Options: nosniff"))
(define mock-settings-json #<<EOF
{
  "name": "somenonexistingtestapp",
  "product": {
    "code": "MAG1",
    "name": "Start",
    "backups_enabled": true,
    "storage_size_in_gb": 8,
    "is_development": false,
    "provider": "combell",
    "varnish_supported": false,
    "supports_sla": false
  },
  "domainname": "somenonexistingtestapp.hypernode.io",
  "destroyed": false,
  "ssh_keys": [],
  "uses_floating_ip": true,
  "ip": "1.2.3.4",
  "backup_ips": [],
  "provider": "digitalocean",
  "provider_location": "sfo3",
  "in_production": true,
  "state": "production",
  "monitoring_enabled": true,
  "account_user": null,
  "is_international": false,
  "subscription_id": null,
  "provider_name_override": "combell",
  "opendkim_public_key": "v=DKIM1; h=sha256; k=rsa; p=somedkimkey",
  "enable_ioncube": false,
  "password_auth": true,
  "openvpn_enabled": false,
  "unixodbc_enabled": false,
  "supervisor_enabled": false,
  "mailhog_enabled": true,
  "modern_ssl_config_enabled": false,
  "support_insecure_legacy_tls": true,
  "modern_ssh_config_enabled": false,
  "mysql_tmp_on_data_enabled": true,
  "redis_persistent_instance": false,
  "firewall_block_ftp_enabled": false,
  "disable_optimizer_switch": false,
  "mysql_disable_stopwords": false,
  "mysql_enable_large_thread_stack": true,
  "mysql_enable_explicit_defaults_for_timestamp": false,
  "rabbitmq_enabled": false,
  "composer_version": "1.x",
  "elasticsearch_enabled": false,
  "elasticsearch_version": "7.x",
  "varnish_esi_ignore_https": true,
  "varnish_large_thread_pool_stack": false,
  "varnish_enabled": false,
  "blackfire_enabled": false,
  "permissive_memory_management": false,
  "varnish_secret": "somevarnishsecret",
  "varnish_version": "4.0",
  "mysql_ft_min_word_len": "4",
  "php_version": "8.1",
  "mysql_version": "5.7",
  "blackfire_server_id": null,
  "blackfire_server_token": null,
  "override_sendmail_return_path": null,
  "php_apcu_enabled": false,
  "php_amqp_enabled": true,
  "managed_vhosts_enabled": true,
  "nodejs_version": "10",
  "new_relic_enabled": false,
  "new_relic_app_name": null,
  "new_relic_secret": null
}
EOF
)

(define mock-read-json
  (λ (response)
    (with-input-from-string
      mock-settings-json
      (λ () (read-json)))))

(define mock-do-request 
  (λ (api-host 
      uri 
      #:ssl? [ssl #f] 
      #:data [data #f] 
      #:method [method "GET"] 
      #:headers [headers #f]) 
  (values
    mock-ok-status
    mock-header 
    "mock-response-not-used-see-do-mock-read-json")))

(module+ test
  (define settings-tests
    (test-suite
      "Testsuite for hynocli/hynocli.rkt -> settings"
      (test-case
        "Test that hynocli settings can print PHP version"

	(define expected-value "8.1")

	(parameterize ([http-sendrecv-factory mock-do-request]
		       [read-json-factory mock-read-json]
                       [displayln-factory
                         (λ (to-print) (check-equal? expected-value to-print))])
          (hynocli (list "settings" "php_version"))))

      (test-case
        "Test that hynocli settings can print Varnish version"

	(define expected-value "4.0")

	(parameterize ([http-sendrecv-factory mock-do-request]
		       [read-json-factory mock-read-json]
                       [displayln-factory
                         (λ (to-print) (check-equal? expected-value to-print))])
          (hynocli (list "settings" "varnish_version"))))
      ))

(run-tests settings-tests))
