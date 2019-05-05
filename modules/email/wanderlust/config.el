;;; app/wanderlust/config.el -*- lexical-binding: t; -*-

(def-package! wl
  :defer t
  :config
  (setq mail-user-agent 'wl-user-agent
        pgg-scheme 'gpg
        mime-edit-split-message nil)

  (when (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'wl-user-agent
      'wl-user-agent-compose
      'wl-draft-send
      'wl-draft-kill
      'mail-send-hook))

  (setq wl-init-file (expand-file-name "wl.el" doom-private-dir))

  (setq wl-demo nil
        wl-interactive-exit t
        wl-interactive-send t
        wl-stay-folder-window t
        wl-folders-file (expand-file-name "folders.wl" doom-private-dir)
        wl-x-face-file (expand-file-name "xface" doom-private-dir)
        wl-draft-folder "%INBOX.drafts"
        wl-fcc "%INBOX.Sent")

  (setq wl-message-truncate-lines t
        wl-summary-width 120
        wl-from (format "%s <%s>" user-full-name user-mail-address)
        ;; wl-organization "Secret Conspiracy"
        wl-local-domain (cadr (split-string user-mail-address "@"))
        wl-message-ignored-field-list
        '(".*Received:"
          ".*Path:"
          ".*Id:"
          "^References:"
          "^Replied:"
          "^Errors-To:"
          "^Lines:"
          "^Sender:"
          ".*Host:"
          "^Xref:"
          "^Content-Type:"
          "^Precedence:"
          "^Status:"
          "^X.*:"
          "^MIME.*:"
          "^In-Reply-To:"
          "^Content-Transfer-Encoding:"
          "^List-.*:"))

  (setq wl-message-visible-field-list '("^Message-Id:" "^User-Agent:" "^X-Mailer:" "^X-Face:"))

  (when (featurep! +gmail)
    (setq elmo-imap4-default-server "imap.gmail.com"
          elmo-imap4-default-port 993
          elmo-imap4-default-authenticate-type 'clear ; CRAM-MD5
          elmo-imap4-default-user ""
          elmo-imap4-default-stream-type 'ssl
          elmo-imap4-set-seen-flag-explicitly t)

    (setq wl-smtp-connection-type 'starttls
          wl-smtp-posting-port 587
          wl-smtp-authenticate-type "plain"
          wl-smtp-posting-user ""
          wl-smtp-posting-server "smtp.gmail.com"))

  (setq wl-message-id-domain wl-local-domain)

  (when (featurep! :editor evil)
    ;; Neither wl-folder-mode or wl-summary-mode are correctly defined as major
    ;; modes, so `evil-set-initial-state' won't work here.
    (add-hook! '(wl-folder-mode-hook wl-summary-mode-hook)
      #'evil-emacs-state))

  (add-hook 'mime-edit-mode-hook #'auto-fill-mode))
