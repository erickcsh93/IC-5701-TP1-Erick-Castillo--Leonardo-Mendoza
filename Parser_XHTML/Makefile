 # Makefile -- scanner
 # Crea "scanner" de "scanner_xhtml.l" 
 #
parser: y.tab.c lex.yy.c
	gcc -c y.tab.c lex.yy.c -w
	gcc -o parser y.tab.o lex.yy.o -ly -ll -w
lex.yy.c: scanner_xhtml.l y.tab.h
	flex -w scanner_xhtml.l

y.output y.tab.c y.tab.h: parser_xhtml.y arbol.h
	bison --warnings=none -vdty parser_xhtml.y

