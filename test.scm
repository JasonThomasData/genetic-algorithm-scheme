(import (chicken load))
(import (chicken condition))
(import test)

(print "~ binary-tree.scm")
(load-relative "binary-tree.scm")

(test "GIVEN tree is valid WHEN (eval-expression-tree tree) THEN return 2"
      2
      (eval-expression-tree (list + * 2 2 - 1 3)))

(test-error "GIVEN tree with number as first node WHEN (eval-expression-tree tree) THEN raises error"
            (eval-expression-tree (list 1 + * 2 2 - 1 3)))

(test-error "GIVEN tree with operator as last node WHEN (eval-expression-tree tree) THEN raises error"
            (eval-expression-tree (list + * 2 2 - / 1)))

(test-error "GIVEN tree with operator as second-last node WHEN (eval-expression-tree tree) THEN raises error"
            (eval-expression-tree (list + * 2 2 - 1 +)))

(test-error "GIVEN tree disjoint WHEN (eval-expression-tree tree) THEN raises error"
            (eval-expression-tree (list + 2 2 2 - 1 3)))

(test "GIVEN replacement for root node is operator WHEN (replace-node tree 0 /) THEN returns tree with replaced operator"
      (list / * 2 2 - 1 3)
      (replace-node (list + * 2 2 - 1 3) 0 /))

(test-error "GIVEN replacement for first node is a number WHEN (replace-node tree 0 3) THEN raises error"
            (replace-node (list + * 2 2 - 1 3) 0 3))

(test-error "GIVEN list size of 7 WHEN (replace-node tree 8 +) THEN raises error"
            (replace-node (list + * 2 2 - 1 3) 8 +))

(test-error "GIVEN replacement for first node is a number WHEN (replace-branch tree 0 3) THEN raises error"
            (replace-branch (list + * 2 2 - 1 3) 0 3))

(test-error "GIVEN list size of 7 WHEN (replace-branch tree 8 +) THEN raises error"
            (replace-branch (list + * 2 2 - 1 3) 8 +))

(test "GIVEN pos to find WHEN (move-to-pos tree 3) THEN returns pair with target node on RHS"
      (cons (list + * 2) (list 2 - 1 3))
      (move-to-pos (list + * 2 2 - 1 3) 3))

(test-error "GIVEN list size of 7 WHEN (move-to-pos tree 8) THEN raises error"
            (move-to-pos (list + * 2 2 - 1 3) 8))

(test "GIVEN first list element is an operator WHEN (separate-branch list) THEN returns pair with branch on LHS"
      (cons (list * 2 2) (list - 1 3))
      (separate-branch (list * 2 2 - 1 3)))

(test "GIVEN first list element is an operator WHEN (separate-branch list) THEN returns pair with branch on LHS"
      (cons (list * 2 + - 1 3 4) (list - 1 3))
      (separate-branch (list * 2 + - 1 3 4 - 1 3)))

(test-error "GIVEN branch incomplete WHEN (separate-branch list) THEN raises error"
            (separate-branch (list * 2 + - 1 3)))

(test "GIVEN pos and symbol WHEN (replace-branch-with-symbol tree pos symbol) THEN returns branch on LHS, symbol replaced on RHS"
      (cons (list * 2 + - 1 3 4) (list + "a" - 1 3))
      (replace-branch-with-symbol (list + * 2 + - 1 3 4 - 1 3) 1 "a"))

(test "GIVEN pos-A for branch pos-B for branch WHEN (swap-branches tree pos-A pos-B) THEN returns branches swapped"
      (list + - 1 3 * 2 + - 1 3 4)
      (swap-branches (list + * 2 + - 1 3 4 - 1 3) 1 8))

(test "GIVEN pos-A for branch pos-B for leaf node WHEN (swap-branches tree pos-A pos-B) THEN branch and leaf swapped"
      (list + 1 - * 2 + - 1 3 4 3)
      (swap-branches (list + * 2 + - 1 3 4 - 1 3) 1 9))

(test "GIVEN pos-A for branch pos-B is child WHEN (swap-branches tree pos-A pos-B) THEN tree is not changed"
      (list + * 2 + - 1 3 4 - 1 3)
      (swap-branches (list + * 2 + - 1 3 4 - 1 3) 1 6))

(test "GIVEN pos-a and pos-b are equal and less than half the tree length WHEN (arrange-positions 2 2 tree) THEN return pos-a=2 pos-b=3"
      (cons 2 3)
      (arrange-positions 2 2 (list + * 2 2 - 1 3)))

(test "GIVEN pos-a and pos-b are equal and more than half the tree length WHEN (arrange-positions 5 5 tree) THEN return pos-a=4 pos-b=5"
      (cons 4 5)
      (arrange-positions 5 5 (list + * 2 2 - 1 3)))

(test "GIVEN pos-a larger than pos-b WHEN (arrange-positions 5 2 tree) THEN return pos-a=2 pos-b=5"
      (cons 2 5)
      (arrange-positions 5 2 (list + * 2 2 - 1 3)))

(test "GIVEN tree is valid WHEN (mutate tree 3 5) THEN return 2 numbers (leaf nodes) swapped"
      (list + * 2 1 - 2 3)
      (mutate (list + * 2 2 - 1 3) 3 5 /))

(test "GIVEN pos-A and pos-B are for branches WHEN (mutate tree 1 4) THEN return 2 branches swapped"
      (list + - 1 3 * 2 2 )
      (mutate (list + * 2 2 - 1 3) 1 4 /))

(test "GIVEN pos-A for branch pos-B is child WHEN (mutate tree 1 4) THEN operator node placed in pos-A"
      (list + / 2 + - 1 3 4 - 1 3)
      (mutate (list + * 2 + - 1 3 4 - 1 3) 1 4 /))

(test "GIVEN pos-A is 0 WHEN (mutate tree 0 3) THEN operator node placed in pos-A"
      (list / * 2 + - 1 3 4 - 1 3)
      (mutate (list + * 2 + - 1 3 4 - 1 3) 0 3 /))

(test "GIVEN pos-B is 0 WHEN (mutate tree 4 0) THEN operator node placed in pos-B"
      (list / * 2 + - 1 3 4 - 1 3)
      (mutate (list + * 2 + - 1 3 4 - 1 3) 4 0 /))

(test "GIVEN both pos=3 and less than list middle WHEN (mutate tree 2 2) THEN node at pos-A=2 swapped with branch at pos-B=3"
      (list + * + - 1 3 4 2 - 1 3)
      (mutate (list + * 2 + - 1 3 4 - 1 3) 2 2 /))

(test "GIVEN pos-A is a parent of pos-B WHEN (is-branch-parent 1 2) THEN returns true"
      #t
      (is-branch-parent 1 1))

(test "GIVEN pos-A is parent of pos-B WHEN (is-branch-parent 1 3) THEN returns false"
      #f
      (is-branch-parent 1 3))

(test-error "GIVEN numbers list is same size as operators WHEN (form-expression-tree (list) (list)) THEN raises error"
            (form-expression-tree (list 1 2 3) (list + - *)))

(test "GIVEN numbers list 1 larger than operators WHEN (form-expression-tree (list) (list)) THEN returns prefix tree"
      (list + 1 - 2 * 3 4)
      (form-expression-tree (list 1 2 3 4) (list + - *)))

(print "~ parse.scm")
(load-relative "parse.scm")

(test "GIVEN number is in approved numbers WHEN (check-is-approved number approved-numbers) THEN returns #t"
      #t
      (check-is-approved 2 (list 1 2 3)))

(test "GIVEN number is not in approved numbers WHEN (check-is-approved number approved-numbers) THEN returns #f"
      #f
      (check-is-approved 4 (list 1 2 3)))

(test "GIVEN expression WHEN (expr->string expression) THEN returns string representation"
      "+ 1 - / 2 3 4 "
      (expr->string (list + 1 - / 2 3 4)))

(print "~ simulation.scm")
(load-relative "simulation.scm")

(test "GIVEN list of valid expression trees WHEN (find-errors (trees)) THEN returns list of trees with errors"
      (list (cons (list + * 2 2 - 1 3) 4)
            (cons (list + * 2 3 - 1 3) 2)
            (cons (list + * 1 2 - 2 3) 5))
      (find-errors (list (list + * 2 2 - 1 3) (list + * 2 3 - 1 3) (list + * 1 2 - 2 3)) 6))

(print "~ sort.scm")
(load-relative "sort.scm")

(test "GIVEN a list of sorted (tree . error) and one to insert is largest WHEN (insert-loop) THEN returns list with largest at end"
      (list (cons (list + "a" "b") 2)
            (cons (list + "a" "b") 4)
            (cons (list + "a" "b") 5)
            (cons (list + "c" "d") 6))
      (insert-loop (list)
                   (list)
                   (cons (list + "c" "d") 6)
                   (list (cons (list + "a" "b") 2)
                         (cons (list + "a" "b") 4)
                         (cons (list + "a" "b") 5))))

(test "GIVEN a list of sorted (tree . error) and one to insert is equal-largest WHEN (insert-loop) THEN returns list with largest at end"
      (list (cons (list + "a" "b") 2)
            (cons (list + "a" "b") 4)
            (cons (list + "a" "b") 5)
            (cons (list + "c" "d") 5))
      (insert-loop (list)
                   (list)
                   (cons (list + "c" "d") 5)
                   (list (cons (list + "a" "b") 2)
                         (cons (list + "a" "b") 4)
                         (cons (list + "a" "b") 5))))

(test "GIVEN a list of sorted (tree . error) and one to insert is smallest WHEN (insert-loop) THEN returns list with smallest at beginning"
      (list (cons (list + "a" "b") 1)
            (cons (list + "a" "b") 2)
            (cons (list + "a" "b") 4)
            (cons (list + "a" "b") 5))
      (insert-loop (list)
                   (list)
                   (cons (list + "a" "b") 1)
                   (list (cons (list + "a" "b") 2)
                         (cons (list + "a" "b") 4)
                         (cons (list + "a" "b") 5))))

(test "GIVEN a list of sorted (tree . error) and one to insert is equal-smallest WHEN (insert-loop) THEN returns list with smallest at beginning"
      (list (cons (list + "c" "d") 2)
            (cons (list + "a" "b") 2)
            (cons (list + "a" "b") 4)
            (cons (list + "a" "b") 5))
      (insert-loop (list)
                   (list)
                   (cons (list + "c" "d") 2)
                   (list (cons (list + "a" "b") 2)
                         (cons (list + "a" "b") 4)
                         (cons (list + "a" "b") 5))))

(test "GIVEN a list of sorted (tree . error) and one to insert WHEN (insert-loop) THEN returns list with item inserted"
      (list (cons (list + "a" "b") 2)
            (cons (list + "c" "d") 3)
            (cons (list + "a" "b") 4)
            (cons (list + "a" "b") 5))
      (insert-loop (list)
                   (list)
                   (cons (list + "c" "d") 3)
                   (list (cons (list + "a" "b") 2)
                         (cons (list + "a" "b") 4)
                         (cons (list + "a" "b") 5))))

(test "GIVEN a list of sorted (tree . error) and one to insert is equal to another WHEN (insert-loop) THEN returns list with item inserted behind other"
      (list (cons (list + "a" "b") 2)
            (cons (list + "a" "b") 4)
            (cons (list + "c" "d") 4)
            (cons (list + "a" "b") 5))
      (insert-loop (list)
                   (list)
                   (cons (list + "c" "d") 4)
                   (list (cons (list + "a" "b") 2)
                         (cons (list + "a" "b") 4)
                         (cons (list + "a" "b") 5))))

(test "GIVEN an unsorted list (tree . error) WHEN (insertion-sort) THEN returns sorted list"
      (list (cons (list + "a" "b") 2)
            (cons (list + "a" "b") 2)
            (cons (list + "a" "b") 3)
            (cons (list + "a" "b") 4)
            (cons (list + "a" "b") 4)
            (cons (list + "a" "b") 5))
      (insertion-sort (list (cons (list + "a" "b") 3)
                            (cons (list + "a" "b") 2)
                            (cons (list + "a" "b") 4)
                            (cons (list + "a" "b") 5)
                            (cons (list + "a" "b") 4)
                            (cons (list + "a" "b") 2))))
