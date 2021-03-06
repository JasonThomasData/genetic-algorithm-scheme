(import (chicken load))
(import (chicken string))

(load-relative "parse.scm")
(load-relative "binary-tree.scm")
(load-relative "binary-tree-entropy.scm")

(define (check-success trees exit-success)
    (if exit-success
        (let ((best-tree (car trees)))
            (let ((best-tree-error (cdr best-tree)))
                (if (equal? best-tree-error 0)
                    (exit))))))

(define (give-report evaluated-trees generations-remaining)
    (print "\n")
    (print "----")
    (print "Generations remaining: " generations-remaining)
    (print "\n")
    (let report-loop ((evaluated-trees evaluated-trees)
                      (generations-remaining generations-remaining))
        (define evaluated-tree (car evaluated-trees))
        (print "Tree: " (expr->string (car evaluated-tree)))
        (print "Evaluation: " (eval-expression-tree (car evaluated-tree)))
        (print "Error: " (cdr evaluated-tree))
        (print "\n")
        (set! evaluated-trees (cdr evaluated-trees))
        (if (not (null? evaluated-trees))
            (report-loop evaluated-trees generations-remaining))))

(define (reproduce-trees trees operator-options)
    ; trees are a-sexual and produce one new tree each
    (let reproduce-loop ((trees-to-reproduce trees)
                         (new-trees (list)))
        (if (null? trees-to-reproduce)
            new-trees
            (let ((tree-to-reprpoduce (car (car trees-to-reproduce))))
                (let ((new-tree (create-one-mutation tree-to-reprpoduce operator-options)))
                    (reproduce-loop (cdr trees-to-reproduce) (cons new-tree new-trees)))))))

(define (cull-trees-by-half trees)
    (define desired-length (/ (length trees) 2))
    (let cull-loop ((trees (reverse trees)))
        (if (or (equal? (length trees) desired-length)
                (< (length trees) desired-length))
            (reverse trees)
            (cull-loop (cdr trees)))))

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
