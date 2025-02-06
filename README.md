# fastlisp
(comment 

currently fastlisp is not compiling properly. the compiler is being worked on to try to guarantee as correct and as reproducable of builds as the design currently allows.

fastlisp is a very tiny version of the lisp programming language. it is based on sector lisp which was based on lisp-1.

this language is able to carry out many tasks that a normal programming language is able to carry out such as running simulations and algorithms and controlling external software systems.

fastlisp is composed of three parts: comments, lambdas, and strings.

(comment a comment in fastlisp represents a block of code that is not intended to run.)

lambdas are like building blocks that can build programs. you can think of them as tiny universal programs.
(lambda x x)

strings contain text made out of characters like 'a', 'b', 'c', '5', or '%'.

(text hello, world!)

every valid fastlisp program is a specific lambda. that lambda can be executed on any true scottish lambda calculus interpreter.

this compiler compiles from fastlisp to a universal format for representing lambdas called binary lambda calculus.

this binary lambda calculus format or BLC file can be interpreted by any true knight of the lambda calculus with any true scottish lambda caluculus interpreter.

currently the fastlisp program is using sectorlambda as a virtual machine for BLC: https://justine.lol/lambda/

this is against the best advice of john tromp who says that he has a better interepter with a better system than a krivine machine for computing binary lambda calculus

so you can test the output of the fastlisp compiler with stdin and stdout through this binary: https://justine.lol/lambda/blc?v=3

when the fastlisp compiler is finished the next goal is to make fastlisp a master system and python a worker system for fastlisp. this is to expedite the process of getting things done in fastlisp in the beginning.

another goal coming soon will be to make a binary lambda calculus interpeter in haskell and make fastlisp a master system and haskell the worker system for fastlisp.

another goal coming soon will be to write a posix compliant interepter for binary lambda calculus and make binary lambda calculus a mster system and to make posix a worker system for fastlisp.

)
