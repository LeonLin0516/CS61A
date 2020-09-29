(define (accumulate combiner start n term)
    (if (< n 1) start 
        (combiner (term n) (accumulate combiner start (- n 1) term))
    )
)

(define (accumulate-tail combiner start n term)
    (if (= n 1) (combiner start (term n))
        (accumulate-tail combiner (combiner start (term n)) (- n 1) term)
    )
)

(define (partial-sums stream)
    (define (helper sums stream)
        (if (null? stream) nil
            (cons-stream (+ (car stream) sums) (helper (+ (car stream) sums) (cdr-stream stream)))
        )
    )
    (helper 0 stream)
)

(define (rle s)
    (define (rle-helper prev n stream)
        (cond 
            ((null? stream) (cons-stream (list prev n) nil))
            ((= (car stream) prev) (rle-helper prev (+ n 1) (cdr-stream stream)))
            (else
                (cons-stream (list prev n) (rle-helper (car stream) 0 stream))
            )
        )
    )
    (if (null? s) nil
        (rle-helper (car s) 0 s)
    )
)