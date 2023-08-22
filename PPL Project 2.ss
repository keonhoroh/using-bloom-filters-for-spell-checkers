
;; contains "ctv", "A", and "reduce" definitions
(load "include.ss")

;; contains simple dictionary definition
(load "test-dictionary.ss")

;; -----------------------------------------------------
;; HELPER FUNCTIONS

(define generate-bit-vector
  (lambda (hashfunctionlist dict)
    (cond
      ((null? dict) '())
      (else
       (append
        (reduce
         (lambda (chosenhashfunction bv)
           (cons (chosenhashfunction (car dict)) bv)) hashfunctionlist '())
        (generate-bit-vector hashfunctionlist (cdr dict)))))))

(define check-hash-functions
  (lambda (hashfunctionlist bv w)
    (cond
      ((null? hashfunctionlist ) #t)
      ((not (contains? bv ((car hashfunctionlist) w))) #f)
      (else (check-hash-functions (cdr hashfunctionlist) bv w)))))

(define contains?
  (lambda (list value)
    (cond
      ((null? list) #f)
      ((= (car list) value) #t)
      (else (contains? (cdr list) value)))))


;; -----------------------------------------------------
;; KEY FUNCTION

(define key
  (lambda (w)
    (let loop ((i (- (length w) 1))
               (key-value 5077))
      (if (< i 0)
          key-value
          (let ((c (list-ref w i)))
            (loop (- i 1) (+ (* key-value 29) (ctv c))))))))

;; -----------------------------------------------------
;; EXAMPLE KEY VALUES
;;   (key '(h e l l o))       = 104146015601
;;   (key '(m a y))           = 123844020
;;   (key '(t r e e f r o g)) = 2539881083658035

;; -----------------------------------------------------
;; HASH FUNCTION GENERATORS

;; value of parameter "size" should be a prime number
(define gen-hash-division-method
  (lambda (size)
    (lambda (w)
      (let ((key (key w)))
        (modulo key size)))))

;; Note: hash functions may return integer values in "real"
;;       format, e.g., 17.0 for 17

(define gen-hash-multiplication-method
  (lambda (size)
    (lambda (w)
      (let ((key (key w)))
        (floor (* size (- (* key A) (floor (* key A)))))))))


;; -----------------------------------------------------
;; EXAMPLE HASH FUNCTIONS AND HASH FUNCTION LISTS

;; (define hash-1 (gen-hash-division-method 70111))
;; (define hash-2 (gen-hash-division-method 89997))
;; (define hash-3 (gen-hash-multiplication-method 7224))
;; (define hash-4 (gen-hash-multiplication-method 900))

;; (define hashfl-1 (list hash-1 hash-2 hash-3 hash-4))
;; (define hashfl-2 (list hash-1 hash-3))
;; (define hashfl-3 (list hash-2 hash-3))

;; -----------------------------------------------------
;; EXAMPLE HASH VALUES
;;   to test your hash function implementation
;;
;;  (hash-1 '(h e l l o))       ==> 51317
;;  (hash-1 '(m a y))           ==> 27994
;;  (hash-1 '(t r e e f r o g)) ==> 33645
;;
;;  (hash-2 '(h e l l o))       ==> 47249
;;  (hash-2 '(m a y))           ==> 8148
;;  (hash-2 '(t r e e f r o g)) ==> 53006
;;
;;  (hash-3 '(h e l l o))       ==> 711.0
;;  (hash-3 '(m a y))           ==> 4747.0
;;  (hash-3 '(t r e e f r o g)) ==> 5418.0
;;
;;  (hash-4 '(h e l l o))       ==> 88.0
;;  (hash-4 '(m a y))           ==> 591.0
;;  (hash-4 '(t r e e f r o g)) ==> 675.0


;; -----------------------------------------------------
;; SPELL CHECKER GENERATOR

(define gen-checker
  (lambda (hashfunctionlist dict)
    (let ((bv (generate-bit-vector hashfunctionlist dict)))
      (lambda (w)
        (check-hash-functions hashfunctionlist bv w)))))


;; -----------------------------------------------------
;; EXAMPLE SPELL CHECKERS

;; (define checker-1 (gen-checker hashfl-1 dictionary))
;; (define checker-2 (gen-checker hashfl-2 dictionary))
;; (define checker-3 (gen-checker hashfl-3 dictionary))

;; EXAMPLE APPLICATIONS OF A SPELL CHECKER
;;
;;  (checker-1 '(a r g g g g)) ==> #f
;;  (checker-2 '(h e l l o)) ==> #t
;;  (checker-2 '(a r g g g g)) ==> #f  

