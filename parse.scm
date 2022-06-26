(import (chicken string))
(import (chicken condition))

(define (convert-to-approved-numbers string-list approved)
    (define (traverse number-list string-list approved)
        (if (equal? (length string-list) 0)
            number-list
            (let ((number (string->number (car string-list))))
                ; Add check number is approved
                (set! number-list (append number-list (list number)))
                (traverse number-list (cdr string-list) approved)
            )
        )
    )
    (traverse (list) string-list approved)
)

(define (parse-small-arg arg)
    (define approved-small-numbers (list 1 2 3 4 5 6 7 8 9 10))
    (convert-to-approved-numbers (string-split arg ",") approved-small-numbers)
)

(define (parse-large-arg arg)
    (define approved-large-numbers (list 25 50 75 100))
    (convert-to-approved-numbers (string-split arg ",") approved-large-numbers)
)

(define (parse-target-arg arg)
    (define min 100) 
    (define max 999) 
    (define target (string->number arg))
    (if (or (< target min) (> target max))
        (abort "Target is out of allowed range")
        target
    )
)
