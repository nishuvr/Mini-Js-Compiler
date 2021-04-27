# Mini-Js-Compiler
The Mini Compiler has been made for the language JavaScript.The
constructs that have been focused on are ‘do while’ and ‘for’ loop. The
optimizations that were implemented are as follows: <br>
● Elimination of dead code/unreachable code <br>
● Implementation Copy Propagation <br>
● Implementation of Constant folding <br>
● Implementation of Constant Propagation <br>
Syntax and semantic errors were taken care of and Syntax error recovery
has been implemented using Panic Mode Recovery in lexer.
<br><br>
To run the files - <br>
flex lex.l && bison -d -y par.y && gcc y.tab.c lex.yy.c -w -ll -fdce && ./a.out <ip
