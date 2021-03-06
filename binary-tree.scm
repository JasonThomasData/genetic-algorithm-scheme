(import (chicken condition))

(define (replace-branch tree pos branch)
    (if (equal? pos 0)
        (abort "Can never replace the branch starting at the first node, since that is the entire tree"))
    (let replace-branch-loop ((nodes-left (list))
                              (nodes-right tree)
                              (i 0)
                              (pos pos)
                              (branch branch))
        (cond ((null? nodes-right)
                  (abort "List out of range before replacement"))
              ((equal? i pos)
                  (append nodes-left (append branch (cdr nodes-right))))
              (else
                  (let ((nodes-left (append nodes-left (list (car nodes-right))))
                        (nodes-right (cdr nodes-right)))
                      (replace-branch-loop nodes-left nodes-right (+ i 1) pos branch))))))

(define (replace-node tree pos node)
    (if (and (equal? pos 0) (number? node))
        (abort "Can never replace the first node with a number, must be an operator"))
    (let replace-node-loop ((nodes-left (list))
                            (nodes-right tree)
                            (i 0)
                            (pos pos)
                            (node node))
        (cond ((null? nodes-right)
                  (abort "List out of range before replacement"))
              ((equal? i pos)
                  (append nodes-left (cons node (cdr nodes-right))))
              (else
                  (let ((nodes-left (append nodes-left (list (car nodes-right))))
                        (nodes-right (cdr nodes-right)))
                      (replace-node-loop nodes-left nodes-right (+ i 1) pos node))))))

(define (swap-nodes tree pos-a node-a pos-b node-b)
    (replace-node (replace-node tree pos-b node-a) pos-a node-b))

(define (move-to-pos tree pos)
    (let move-loop ((nodes-left (list))
                    (nodes-right tree)
                    (i 0)
                    (pos pos))
        (cond ((null? nodes-right)
                  (abort "List out of range before node located"))
              ((equal? i pos)
                  (cons nodes-left nodes-right))
              (else (let ((nodes-left (append nodes-left (list (car nodes-right))))
                          (nodes-right (cdr nodes-right)))
                        (move-loop nodes-left nodes-right (+ i 1) pos))))))

(define (separate-branch nodes-right)
    (let seperate-loop ((branch (list))
                        (nodes-right nodes-right)
                        (operand-count 0)
                        (operator-count 0))
        ; This function uses the convenient fact that in any binary tree, |nodes| = |leafs|-1
        (if (null? nodes-right)
            (abort "List out of range before branch ended"))
        (define node (car nodes-right))
        (set! branch (append branch (list node)))
        (set! nodes-right (cdr nodes-right))
        (if (number? node)
            (set! operand-count (+ operand-count 1))
            (set! operator-count (+ operator-count 1)))
        (if (equal? operand-count (+ operator-count 1))
            (cons branch nodes-right)
            (seperate-loop branch nodes-right operand-count operator-count))))


(define (replace-branch-with-symbol tree pos symbol)
    (if (equal? pos 0)
        (abort "Can never take the entire tree as a branch"))
    (define tree-at-pos (move-to-pos tree pos))
    (define nodes-left (append (car tree-at-pos) (list symbol)))
    (define nodes-including-branch (cdr tree-at-pos))
    (define branch-and-remaining-nodes (separate-branch nodes-including-branch))
    (define branch (car branch-and-remaining-nodes))
    (set! tree (append nodes-left (cdr branch-and-remaining-nodes)))
    (cons branch tree))

(define (adjust-pos-branch-removed pos branch)
    ; Branch has becomes a symbol of length 1
    (+ (- pos (length branch) ) 1))

(define (is-branch-parent pos-A pos-B)
    ; the branch at pos-A can be the parent but the branch or node at pos-B will never be the parent.
    ; At the time of call, the branch-A is reduced to a symbol, so the branch has size 1, temorarily
    (> (+ pos-A 1) pos-B))

(define (swap-branches tree pos-A pos-B)
    (define branch-and-tree-A (replace-branch-with-symbol tree pos-A "A"))
    (define branch-A (car branch-and-tree-A))
    (set! pos-B (adjust-pos-branch-removed pos-B branch-A))
    (cond ((is-branch-parent pos-A pos-B)
              ; this occurs when pos-B is a child of branch at pos-A
              tree)
          (else (set! tree (cdr branch-and-tree-A))
                (let ((branch-and-tree-B (replace-branch-with-symbol tree pos-B "B")))
                    (let ((branch-B (car branch-and-tree-B)))
                        (set! tree (cdr branch-and-tree-B))
                        (set! tree (replace-branch tree pos-B branch-A))
                        (set! tree (replace-branch tree pos-A branch-B))
                        tree)))))

(define (arrange-positions pos-a pos-b tree)
    (cond ((< pos-b pos-a)
              (cons pos-b pos-a))
          ((equal? pos-a pos-b)
              (if (< pos-a (/ (length tree) 2))
                  (cons pos-a (+ pos-b 1))
                  (cons (- pos-a 1) pos-b)))
          (else (cons pos-a pos-b))))

(define (mutate tree pos-a pos-b replacement-operator)
    ; The replacement-operator is kept incase no other mutation can be made, so that at least this will change a node's operator
    (let ((positions (arrange-positions pos-a pos-b tree)))
        (set! pos-a (car positions))
        (set! pos-b (cdr positions)))
    (define node-a (list-ref tree pos-a))
    (define node-b (list-ref tree pos-b))

    (cond ((and (number? node-a) (number? node-b))
              (swap-nodes tree pos-a node-a pos-b node-b))
          ((equal? pos-a 0)
              (replace-node tree pos-a replacement-operator))
          ((equal? pos-b 0)
              (replace-node tree pos-b replacement-operator))
          (else (let ((mutated-tree (swap-branches tree pos-a pos-b)))
                    (if (equal? mutated-tree tree)
                        ; If a mutation fails at this point then it is because node-b is a child of node-a.
                        (replace-node tree pos-a replacement-operator)
                        mutated-tree)))))

(define (pre-validate tree)
    (define first (car tree))
    (define last (car (reverse tree)))
    (define second-last (car (cdr (reverse tree))))
    (cond ((number? first)
              (abort "First node cannot be a number"))
          ((not (number? last))
              (abort "Last node must be a number")) 
          ((not (number? second-last))
              (abort "Second-last node must be a number"))))

(define (post-validate tree count-traversed)
    (if (not (equal? (length tree) count-traversed))
        (abort "This tree has elements that were not traversed")))

(define (eval-expression-tree tree)
    (define count-traversed 0)
    (define tree-original tree)
    (define (eval-loop)
        (define first (car tree))
        (set! tree (cdr tree))
        (set! count-traversed (+ count-traversed 1))
        (if (number? first)
            first
            (first (eval-loop) (eval-loop))))
    (pre-validate tree)
    (define evaluation (eval-loop))
    (post-validate tree-original count-traversed)
    evaluation
)

(define (form-expression-tree numbers operators)
    (if (not (equal? (length numbers) (+ (length operators) 1)))
        (abort "A valid binary expression tree has leaf nodes (numbers) equal to length(operators) + 1"))
    (let form-loop ((tree (list))
                    (numbers numbers)
                    (operators operators)
                    (add-operator-next #t))
        (cond ((and (null? numbers) (null? operators))
                  tree)
              ((null? operators)
                  (set! tree (append tree (list (car numbers))))
                  (set! numbers (cdr numbers))
                  (form-loop tree numbers operators (not add-operator-next)))
              (add-operator-next
                  (set! tree (append tree (list (car operators))))
                  (set! operators (cdr operators))
                  (form-loop tree numbers operators (not add-operator-next)))
              (else
                  (set! tree (append tree (list (car numbers))))
                  (set! numbers (cdr numbers))
                  (form-loop tree numbers operators (not add-operator-next))))))
