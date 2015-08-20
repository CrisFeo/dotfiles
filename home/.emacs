
; Modes
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

; Indents
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq c-basic-offset 2)
(setq sh-basic-offset 2)
(setq cperl-indent-level 2)

; Mode Hooks
(add-hook 'text-mode-hook'(lambda ()
  (setq indent-tabs-mode nil)
  (setq tab-width 2)
  (setq indent-line-function (quote insert-tab))))
