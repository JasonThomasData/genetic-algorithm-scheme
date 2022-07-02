(define (insert-loop last-sorted smaller to-insert possibly-larger)
    ; The trees here are themselves pairs, like ((list) error)
    ; Here, error is the difference between a tree's evaluation and the target
    ; It sure looks like a monster, but this is the same as have guard clauses at the top of a function
    (define to-insert-error (cdr to-insert))
    (if (null? possibly-larger)
        (append smaller (list to-insert))
        (let ((next-largest-error (cdr (car possibly-larger))))
            (if (null? last-sorted) 
                (if (or (< to-insert-error next-largest-error)
                        (equal? to-insert-error next-largest-error))
                    (cons to-insert possibly-larger)
                    (insert-loop (car possibly-larger)
                                 (append smaller (list (car possibly-larger)))
                                 to-insert
                                 (cdr possibly-larger)))
                (let ((last-sorted-error (cdr last-sorted)))
                    (cond ((equal? last-sorted-error to-insert-error)
                           (append smaller (cons to-insert possibly-larger)))
                          ((and (< last-sorted-error to-insert-error) (< to-insert-error next-largest-error))
                           (append smaller (cons to-insert possibly-larger)))
                          (else
                           (insert-loop (car possibly-larger)
                                        (append smaller (list (car possibly-larger)))
                                        to-insert
                                        (cdr possibly-larger)))))))))

(define (insertion-sort trees)
    ; This algorithm seems good for a linked list:
        ; 1) pop head of UNSORTED linked list, to insert
        ; 2) iterate over sorted list 
        ; 3) link new object where it is sorted
    (let sort-loop ((sorted-trees (list))
                    (unsorted-trees trees))
        (if (null? unsorted-trees)
            sorted-trees
            (let ((to-insert (car unsorted-trees)))
                (let ((sorted-trees (insert-loop (list)
                                                 (list)
                                                 to-insert 
                                                 sorted-trees)))
                    (sort-loop sorted-trees (cdr unsorted-trees)))))))
