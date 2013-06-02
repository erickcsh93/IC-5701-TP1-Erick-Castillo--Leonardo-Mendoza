 # Makefile -- scanner
 # Crea "scanner" de "scanner_xhtml.l" 
 #
 LEX=flex
 lex.yy.c: scanner_xhtml.l
	flex scanner_xhtml.l
	gcc -o scanner lex.yy.c -l l

