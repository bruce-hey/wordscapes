((defpackage wordscape
  (:use :cl))

(in-package :wordscape)

;; from Norvig: Paradigms of Artificial Intelligence Programming
(defun permutations (lst)
  "return all permutations of lst"
  (if (null lst)
      '(())
      (mapcan #'(lambda (e)
		  (mapcar #'(lambda (p) (cons e p))
			  (permutations
			   (remove e lst :count 1 :test #'eq))))
	      lst)))

(defun string-to-list (s)
  "return list of chars in s"
  (loop for c across s collect c))

(defun list-to-string (lst)
  "return stringified version of list : (list-to-string '(#\a #\b #\c)) => abc"
  (let ((s (make-array 0
		       :element-type 'character
		       :fill-pointer 0
		       :adjustable t)))
    (dolist (c lst)
      (vector-push-extend c s))
    s))

(defun make-game (s)
  "return list of permutations of string s, duplicates removed"
  (let* ((lst (string-to-list s))
	 (perms (permutations lst)))
    (remove-duplicates
     (mapcar #'list-to-string perms)
     :test #'equal)))

(defun build-dict (fn)
  "return hash table of contents of dictionary file fn"
  (let ((h (make-hash-table :test #'equal)))
    (with-open-file (stream fn)
      (loop for line = (read-line stream nil)
	    while line
		do  (setf (gethash line h) nil)))
    h))

(defun get-substrings (lst n)
  "return list of strings of length n from lst"
  (remove-duplicates
   (mapcar (lambda (x) (subseq x 0 n)) lst)
   :test #'equal))

(defun in-dict-p (item dict)
  "return t when item is contained in hash table dict"
  (multiple-value-bind (_ present) (gethash item dict)
    (declare (ignore _))
    present))

(defun get-words-of-length (game dict word-len)
  "return list of words of length word-len from game"
  (remove-if-not (lambda (w) (in-dict-p w dict)) (get-substrings game word-len)))

(defun flatten (l)
	     (cond ((null l) nil)
		   ((atom l) (list l))
		   (t (loop for a in l appending (flatten a)))))

(defun ws (s)
  "generate sorted list of dictionary words from permutations of string s having minimum length 3"
  (let* ((game (make-game s))
	 (dict (build-dict #P"/usr/share/dict/words"))
	 (l nil))
    (dotimes (i (- (length s) 2))
      (setf l (append l (get-words-of-length game dict (+ i 3)))))
    (sort l #'string-lessp)))


