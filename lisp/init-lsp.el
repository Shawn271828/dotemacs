;; init-lsp.el --- Initialize lsp configurations.	-*- lexical-binding: t -*-
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;             LSP configurations.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((rust-mode . lsp-deferred))
  :bind
  (:map lsp-mode-map
        ("C-c s i" . lsp-describe-thing-at-point)
        ("C-c s c" . lsp-find-references)
        ("C-c s d" . xref-find-definitions-other-window))
  :init
  (setq lsp-keymap-prefix "C-c s"
        lsp-keep-workspace-alive nil
        lsp-print-performance t
        lsp-modeline-code-actions-enable nil
        lsp-enable-symbol-highlighting t
        lsp-lens-enable t
        lsp-headerline-breadcrumb-enable t
        lsp-diagnostics-provider :flycheck
        lsp-modeline-diagnostics-enable t
        lsp-signature-auto-activate nil
        lsp-signature-render-documentation nil
        lsp-completion-provider :capf
        lsp-completion-show-detail t
        lsp-completion-show-kind t
        lsp-auto-guess-root nil)
  :config
  (progn
    (use-package company-lsp
      :ensure t
      :commands company-lsp
      :config
      (shawn/local-push-company-backend 'company-lsp))

    (use-package lsp-ui
      :commands lsp-ui-mode
      :bind(:map lsp-ui-mode-map
                 ([remap xref-find-definitions] . #'lsp-ui-peek-find-definitions)
                 ([remap xref-find-references] . #'lsp-ui-peek-find-references))
      :init
      (setq lsp-ui-doc-enable nil
            lsp-ui-doc-use-webkit nil
            lsp-ui-doc-delay 0.2
            lsp-ui-doc-include-signature t
            lsp-ui-doc-position 'at-point
            lsp-ui-doc-border (face-foreground 'default)
            lsp-eldoc-enable-hover t

            lsp-ui-imenu-enable t
            lsp-ui-imenu-colors `(,(face-foreground 'font-lock-keyword-face)
                                  ,(face-foreground 'font-lock-string-face)
                                  ,(face-foreground 'font-lock-constant-face)
                                  ,(face-foreground 'font-lock-variable-name-face))

            lsp-ui-sideline-enable nil
            lsp-ui-sideline-show-hover nil
            lsp-ui-sideline-show-diagnostics nil
            lsp-ui-sideline-ignore-duplicate t
            lsp-ui-sideline-show-code-actions nil
            )
      :config
      (add-to-list 'lsp-ui-doc-frame-parameters '(right-fringe . 8))

      ;; `C-g'to close doc
      (advice-add #'keyboard-quit :before #'lsp-ui-doc-hide)

      ;; WORKAROUND Hide mode-line of the lsp-ui-imenu buffer
      ;; @see https://github.com/emacs-lsp/lsp-ui/issues/243
      (defun my-lsp-ui-imenu-hide-mode-line ()
        "Hide the mode-line in lsp-ui-imenu."
        (setq mode-line-format nil))
      (advice-add #'lsp-ui-imenu :after #'my-lsp-ui-imenu-hide-mode-line))))

(provide 'init-lsp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init-lsp.el ends here
