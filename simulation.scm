(import (chicken load))
(import (chicken string))

(load-relative "parse.scm")
(load-relative "binary-tree.scm")
(load-relative "binary-tree-entropy.scm")

#|

(define (insertion-sort trees)
    (define (insert last-sorted smaller possibly-larger to-insert)
        (cond 
            ((equal? last-sorted NIL)
                (set! smaller (append smaller (list to-insert)))
                ;(set! possibly-larger (cdr possibly-larger))
                )
            ((equal? last-sorted to-insert)

                )
            ((and (< last-sorted to-insert) (< to-insert (car possibly-larger)))
                
                )
            ((< last-sorted (car possibly-larger))
                
                )
            
        
        )
        (append (append sorted-smaller (list to-insert)) sorted-possibly-larger)
    )

    (define (insertion-loop sorted-trees to-insert)
        sorted-trees
    )
    ; This algorithm seems good for a linked list: 1) pop head of UNSORTED linked list, 2) iterate over sorted list, 3) link new object where it is sorted
    (define (sort-loop sorted-trees unsorted-trees)
        (define unsorted-element (car trees))
        (set! trees (cdr trees))
        
    )
    (sort-loop (list) trees)
)

|#

(define (give-trees-report evaluated-trees generations)
    (print "\n")
    (define (report-loop evaluated-trees)
        (define evaluated-tree (car evaluated-trees))
        (set! evaluated-trees (cdr evaluated-trees))
        (print "Error: " (car evaluated-tree))
        (print "Tree: " (expr->string (cdr evaluated-tree))))
    (report-loop evaluated-trees))

(define (reproduce-trees)
    (print "grow population"))

(define (cull-trees)
    (print "cull by 1/2"))

(define (find-abs-error number target)
    (abs (- target number)))

(define (find-errors trees target)
    (let error-loop ((evaluated-trees (list))
                     (trees-to-evaluate trees)
                     (target target))
        (if (null? trees-to-evaluate)
            evaluated-trees
            (let ((tree (car trees-to-evaluate))
                  (trees-to-evaluate (cdr trees-to-evaluate)))
                (let ((evaluation (eval-expression-tree tree)))
                    (let ((error (find-abs-error evaluation target)))
                        (let ((evaluated-tree (cons tree error)))
                            (error-loop (append evaluated-trees (list evaluated-tree)) trees-to-evaluate target))))))))


(define (run-simulation small-numbers large-numbers target population-capacity generations)
    (define operator-options (list + - / *))
    (define numbers (append small-numbers large-numbers))
    (define first-tree (create-one-tree numbers operator-options))
    (define trees (create-mutations first-tree population-capacity))
    (define simulation-loop (trees target population-capacity generations)
        (cond ((or (equal? (length trees) population-capacity) (> (length trees) population-capacity))
                  ;(evaluate-trees)
                  ;(report-trees)
                  (cull-trees))
              ((< (length trees) population-capacity)
                  (reproduce-trees)))
        (simulation-loop trees target population-capacity generations))
    (simulation-loop trees target population-capacity generations))
