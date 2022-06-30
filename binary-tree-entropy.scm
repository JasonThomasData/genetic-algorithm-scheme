(import (chicken load))
(import (chicken random))

(load-relative "binary-tree.scm")

; These functions are related to binary trees but involve randomness, so they can't easily be tested
; TODO - generate a large-enough list of randomness and pass that, so that these can be tested.


; TODO - have a function to pick an operator
;(define (select-an-operator options)

;)

(define (select-operators options number-required)
    (define (loop selected options number-required)
        (if (equal? number-required 0)
            selected
            (let ((operator-to-select (pseudo-random-integer (length options))))
                (cond
                    ((equal? operator-to-select 0)
                        (set! selected (append selected (list (car options)))))
                    ((equal? operator-to-select 1)
                        (set! selected (append selected (list (car (cdr options))))))
                    ((equal? operator-to-select 2)
                        (set! selected (append selected (list (car (cdr (cdr options)))))))
                    ((equal? operator-to-select 3)
                        (set! selected (append selected (list (car (cdr (cdr (cdr options))))))))
                )
                (loop selected options (- number-required 1))
            )
        )
    )
    (loop (list) options number-required)
)

(define (create-one-tree numbers operator-options)
    (define number-count (length numbers))
    ; There are always one fewer nodes than leaf nodes for every binary tree
    (define operator-count (- number-count 1))
    (define operators (select-operators operator-options operator-count))
    (form-expression-tree numbers operators)
)

(define (create-mutations first-tree population-target)
    (define (loop trees last-tree number-required)
        (if (equal? number-required 0)
            trees
            (let ((pos-A (pseudo-random-integer (length last-tree)))
                (pos-B (pseudo-random-integer (length last-tree))))
                (let ((new-tree (mutate last-tree pos-A pos-B +)))
                    (let ((trees (append trees (list new-tree))))
                        (loop trees new-tree (- number-required 1))
                    )
                )
            )
        )
    )
    (loop (list first-tree) first-tree population-target)
)
