(import (chicken load))
(import (chicken process-context)
        (chicken port)
        args)

(load-relative "parse.scm")
(load-relative "genetic.scm")
(load-relative "create.scm")

(define (run-simulation small-numbers large-numbers target)
    (define population-target 10)
    (define operator-options (list + - / *))
    (define numbers (append small-numbers large-numbers))
    (define first-algorithm (create-one-algorithm numbers operator-options population-target))
    (define first-mutations (create-mutations first-algorithm population-target))
)

; load the args
(define opts
    (list
        (args:make-option (s small)         (required: "SMALL")     "choose from 1:10 inclusive. EG: -s 1,2,5,7")
        (args:make-option (l large)         (required: "LARGE")     "choose from (25,50,75.100). EG: -l 25,100")
        (args:make-option (t target)        (required: "TARGET")    "a 3-digit integer 100:999 EG: -t 340")
        ;(args:make-option (p population)    (required: "TARGET")    "an integer for the maximum number of algorithms")
        ;(args:make-option (g generations)   (required: "TARGET")    "an integer for the number of generations")
        (args:make-option (h help)          #:none                  "Display this text")
    )
)
(define (usage)
    (with-output-to-port (current-error-port)
        (lambda ()
            (print "Usage: " (car (argv)) " [options...]")
            (newline)
            (print (args:usage opts))
            (print "Find it on Github at.")))
    (exit 1)
)
(receive (options operands)
    (args:parse (command-line-arguments) opts)

    (cond
        ((not (alist-ref 'small options))
            (print "missing small")
            (usage))
        ((not (alist-ref 'large options))
            (print "missing large")
            (usage))
        ((not (alist-ref 'target options))
            (print "missing target")
            (usage)))
    
    (let ((small-numbers (parse-small-arg (alist-ref 'small options)))
        (large-numbers (parse-large-arg (alist-ref 'large options)))
        (target (parse-target-arg (alist-ref 'target options))))
        (run-simulation small-numbers large-numbers target)
    )
)

#|

(define (select algorithm elements-to-add )
    (cond
        ((equal? (length elements-to-add) 0)
            algorithm)
        ((equal? (length ) 0)
            algorithm)
    )
)

|#

(define binary-expression-tree (list * + * 2 1 / 3 - 4 1 5))
(print (eval-expression-tree binary-expression-tree))

