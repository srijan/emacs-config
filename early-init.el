;;; early-init.el -*- lexical-binding: t; -*-

;; Emacs 27.1 introduced early-init.el, which is run before init.el,
;; before package and UI initialization happens, and before site files
;; are loaded.

;; A big contributor to startup times is garbage collection. We up the
;; gc threshold to temporarily prevent it from running, then reset it
;; later by enabling `gcmh-mode'. Not resetting it will cause
;; stuttering/freezes.

(setq gc-cons-threshold most-positive-fixnum)
;; (setq gc-cons-threshold (* 50 1000 1000))
;; (setq gc-cons-percentage 0.6)

;; In Emacs 27+, package initialization occurs before `user-init-file'
;; is loaded, but after `early-init-file'. We handle our own
;; initialization using use-package, so we must prevent Emacs from
;; doing it early
(setq package-enable-at-startup nil)

;; Premature redisplays can substantially affect startup times and produce
;; ugly flashes of unstyled Emacs.
(setq-default inhibit-redisplay t
              inhibit-message t)
(add-hook 'window-setup-hook
          (lambda ()
            (setq-default inhibit-redisplay nil
                          inhibit-message nil)
            (redisplay)))

;; Site files tend to use `load-file', which emits "Loading X..." messages in
;; the echo area, which in turn triggers a redisplay. Redisplays can have a
;; substantial effect on startup times and in this case happens so early that
;; Emacs may flash white while starting up.
(define-advice load-file (:override (file) silence)
  (load file nil 'nomessage))

;; Undo our `load-file' advice above, to limit the scope of any edge cases it
;; may introduce down the road.
(define-advice startup--load-user-init-file (:before (&rest _) init-doom)
  (advice-remove #'load-file #'load-file@silence))

;; Contrary to what many Emacs users have in their configs, you don't need
;; more than this to make UTF-8 the default coding system:
(set-language-environment "UTF-8")

;; set-language-enviornment sets default-input-method, which is unwanted
(setq default-input-method nil)
