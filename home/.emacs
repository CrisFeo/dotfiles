(require 'package)
(add-hook 'haskell-mode-hook 'haskell-indentation-mode)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa-stable" . "http://stable.melpa.org/packages/")))))

;; UI

(menu-bar-mode -1)
(setq-default mode-line-format (list
				"–––(▤) "
				'(:eval (propertize "%b" 'face '(:background "yellow")))
				" ––––––––(⌥) "
				'(:eval (propertize mode-name 'face '(:background "yellow")))
				" ––––––––(✜) "
				'(:eval (propertize "%l:%c" 'face '(:background "yellow")))))

(set-background-color "black")
(set-foreground-color "white")
(set-cursor-color "white")
(set-border-color "white")
(set-mouse-color "white")

(set-face-background 'default "black")
(set-face-foreground 'default "white")

(set-face-background 'region "blue")
(set-face-foreground 'region "white")

(set-face-background 'highlight "blue")
(set-face-foreground 'highlight "white")

(set-face-background 'mode-line "blue")
(set-face-foreground 'mode-line "black")

;; Modes
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; Indents
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq c-basic-offset 2)
(setq sh-basic-offset 2)
(setq cperl-indent-level 2)

;; Mode Hooks
(add-hook 'text-mode-hook'(lambda ()
  (setq indent-tabs-mode nil)
  (setq tab-width 2)
  (setq indent-line-function (quote insert-tab))))
