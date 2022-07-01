(import (chicken load))
(import (chicken string))

(load-relative "parse.scm")
(load-relative "binary-tree.scm")
(load-relative "binary-tree-entropy.scm")

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
