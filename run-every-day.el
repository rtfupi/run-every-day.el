;;; run-every-day.el --- run something every day

;; Copyright (C) 2018,2021 Eugene Markov <...@gmail.com>

;; Author: Eugene Markov <upirtf@gmail.com>
;; URL: https://github.com/rtfupi/run-every-day.el
;; Version: 0.1
;; Keywords: utilities

;; Package-Requires: ((emacs "24"))

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
;; 02110-1301, USA.

;;; Commentary:

;; Inspired by midnight.el (Author Sam Steingold <sds@gnu.org>)
;; from Emacs

;;; Code:


(defvar run-every-day-timer nil
  "Timer running the `run-every-day-hook'. Use `cancel-timer' to stop it
 and `run-every-day-timer-set' to change the time when it is run.")


(defvar run-every-day-period (* 24 60 60)
  "The number of seconds in a day--the delta for `run-every-day-timer'.")


(defvar  run-every-day-hook '(run-every-day-hello)
  "The hook run every day.")


;;;###autoload
(defun run-every-day-timer-set (tm)
  "Modify `run-every-day-timer'. Format `tm' is HH:MM."
  (when (timerp run-every-day-timer) (cancel-timer run-every-day-timer))
  (unless (string= tm "stop")

    (setq run-every-day-timer
          (run-at-time
           ;; need a relative time !!!
           (let ((cur (run-every-day-current))
                 (aim (run-every-day-aim tm))
                 (day (* 24 60 60)))
             (message ">>>> c %S a %S d %S" cur aim day)
             (if ( >= aim cur)
                 (- aim cur)         ; today
               (+ (- day cur) aim))) ; next day
           run-every-day-period
           #'run-hooks 'run-every-day-hook))))

;;(run-every-day-timer-set "01:00")


(defun run-every-day-current ()
  "Return the number of seconds from midnight."
  (pcase-let ((`(,sec ,min ,hrs) (decode-time)))
    (+ (* 60 60 hrs) (* 60 min) sec)))


(defun run-every-day-aim (s)
  "HH:MM to second (integer) from midnight."
  (let (h m)
    (if (not (string-match "^\\([0-9]+\\):\\([0-9]+\\)$" s))
        (error "Time format error"))

    (setq h (string-to-number (match-string 1 s)))
    (setq m (string-to-number (match-string 2 s)))

    (if (not (and (>= h 0) (<= h 23)))
        (error "Hour format error"))
    (if (not (and (>= m 0) (<= m 59)))
        (error "Minute format error"))

    (+ (* 60 60 h) (* 60 m))))


(defun run-every-day-hello ()
  ""
  (message "run-every-day: [%s] : Hello !!!"
           (format-time-string "%Y-%m-%d %a %H:%M.%S")))
;;(run-every-day-hello)

(provide 'run-every-day)

;;; run-every-day.el ends here
;;(eval-buffer)



;; (require 'cl-lib)

;; (defun run-every-day-date2second (s)
;;   "HH:MM to second (integer)"
;;   (let (h m)
;;     (if (not (string-match "^\\([0-9]+\\):\\([0-9]+\\)$" s))
;;         (error "Time format error"))

;;     (setq h (string-to-number (match-string 1 s)))
;;     (setq m (string-to-number (match-string 2 s)))

;;     (if (not (and (>= h 0) (<= h 23)))
;;         (error "Hour format error"))
;;     (if (not (and (>= m 0) (<= m 59)))
;;         (error "Minute format error"))

;;     (+ (* 3600 h) (* 60 m))))


;; (defun run-every-day-next ()
;;   "Return the number of seconds till the next midnight."
;;   (pcase-let ((`(,sec ,min ,hrs) (decode-time)))
;;     (- (* 24 60 60) (* 60 60 hrs) (* 60 min) sec)))
