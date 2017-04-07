#!/usr/bin/env racket
#lang racket/base
(require file/resource)
;; Need to istall config-ini with this:
;;; raco pkg install  https://github.com/naihe2010/rkt-config-ini.git
(require rkt-config-ini/config-ini/ini)

;; Find a config file
(define (get-aws-config)
  #| Looks for $AWS_CONFIG_FILE environment
     variable, and checks to make sure file exists. If it is not define,
     checks if $HOME/.aws/config exists. It returns a path object if it
     finds the file. Otherwise, it returns false.
  |#
  (cond
    [(and (getenv "AWS_CONFIG_FILE")
          (file-exists?
           (string->path
            (getenv "AWS_CONFIG_FILE"))))
     (string->path
      (getenv "AWS_CONFIG_FILE"))]
    [(file-exists?
      (build-path
       (find-system-path 'home-dir)
       ".aws/config"))
     (build-path
       (find-system-path 'home-dir)
       ".aws/config")]))
(define aws-config (get-aws-config))

(define aws-ini (ini-new))

(define (get-aws profile option)
  (ini-read aws-ini aws-config)
  (ini-get-key-string aws-ini profile option))

(get-aws "profile dev" "aws_access_key_id")
