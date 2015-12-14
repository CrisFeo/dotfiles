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
				'(:eval (propertize "%b" 'face '(:foreground "green")))
				" ––––––––(⌥) "
				'(:eval (propertize mode-name 'face '(:foreground "red")))
				" ––––––––(✜) "
				'(:eval (propertize "%l:%c" 'face '(:foreground "yellow")))))

(set-background-color "black")
(set-foreground-color "white")
(set-cursor-color "brightwhite")
(set-border-color "brightwhite")
(set-mouse-color "brightwhite")

(set-face-background 'default "black")
(set-face-foreground 'default "white")

(set-face-background 'region "green")
(set-face-foreground 'region "brightblack")

(set-face-background 'highlight "green")
(set-face-foreground 'highlight "brightblack")

(set-face-background 'mode-line "color-236")
(set-face-foreground 'mode-line "color-250")

(set-face-background 'mode-line-inactive "color-236")
(set-face-foreground 'mode-line-inactive "color-250")

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
