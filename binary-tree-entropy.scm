(import (chicken load))
(import (chicken random))

(load-relative "binary-tree.scm")

; These functions are related to binary trees but involve randomness, so they can't easily be tested
; TODO - package the psuedo random number generator in a wrapper functon, pass that, so that these can be tested.

; TODO - have a function to pick an operator
;(define (select-an-operator options)

(define (select-one-operator options)
    (let ((operator-to-select (pseudo-random-integer (length options))))
        (list-ref options operator-to-select)))

(define (select-operators options number-required)
    (let loop ((selected (list))
               (options options)
               (number-required number-required))
        (if (equal? number-required 0)
            selected
            (let ((selected (append selected (list (select-one-operator options)))))
                (loop selected options (- number-required 1))))))

(define (create-one-tree numbers operator-options)
    (define number-count (length numbers))
    ; There are always one fewer nodes than leaf nodes for every binary tree
    (define operator-count (- number-count 1))
    (define operators (select-operators operator-options operator-count))
    (form-expression-tree numbers operators)
)

(define (create-one-mutation tree operator-options)
    ; to do - make operator random
    (let ((pos-A (pseudo-random-integer (length tree)))
        (pos-B (pseudo-random-integer (length tree)))
        (operator (select-one-operator operator-options)))
        (mutate tree pos-A pos-B operator)))

(define (create-mutations first-tree population-target operator-options)
    (define to-create (- population-target 1))
    (let create-loop ((trees (list first-tree))
                      (last-tree first-tree)
                      (to-create to-create))
        (if (equal? to-create 0)
            trees
            (let ((new-tree (create-one-mutation last-tree operator-options)))
                (let ((trees (append trees (list new-tree))))
                    (create-loop trees new-tree (- to-create 1)))))))
