(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cdar x) (cdr (car x)))
(define (cddr x) (cdr (cdr x)))

; Some utility functions that you may find useful to implement.

(define (cons-all first rests)
    (define (insert-first s)
        (append (list first) s)
    )
    (map insert-first rests)
)

(define (zip pairs)
    (list (map car pairs) (map cadr pairs))
)

;; Problem 17
;; Returns a list of two-element lists
(define (enumerate s)
    (define (helper s i)
        (if (null? s) nil
            (cons (list i (car s))
                (helper (cdr s) (+ i 1))
            )
        )
    )
    (helper s 0)
)

;; Problem 18
;; List all ways to make change for TOTAL with DENOMS
(define (list-change total denoms)
    (cond 
        ((or (null? denoms) (<= total 0))
            nil
        )
        ((< total (car denoms))
            (list-change total (cdr denoms))
        )
        ((= total (car denoms))
            (append (list (list total)) (list-change total (cdr denoms)))
        )
        (else
            (append (cons-all (car denoms) (list-change (- total (car denoms)) denoms)) (list-change total (cdr denoms))) 
        )
    )
)

;; Problem 19
;; Returns a function that checks if an expression is the special form FORM
(define (check-special form)
  (lambda (expr) (equal? form (car expr))))

(define lambda? (check-special 'lambda))
(define define? (check-special 'define))
(define quoted? (check-special 'quote))
(define let?    (check-special 'let))

;; Converts all let special forms in EXPR into equivalent forms using lambda
(define (let-to-lambda expr)
  (cond ((atom? expr)
            expr
        )
        ((quoted? expr)
            expr
        )
        ((or (lambda? expr)
             (define? expr))
         (let ((form   (car expr))
               (params (cadr expr))
               (body   (cddr expr)))
            (append (list form params) (map let-to-lambda body))
        ))
        ((let? expr)
            (let ((values (cadr expr))
               (body   (cddr expr)))
               (define params (car (zip values)))
                    (define args (map let-to-lambda (cadr (zip values))))
                    (define body (map let-to-lambda body))
                    (cons (append (list 'lambda params) body) args)
            )   
        )
        (else
            (map let-to-lambda expr)
        )))
