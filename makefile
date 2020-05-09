parser:
	bison -y -d file_bison.y 
	flex file_flex.l
	gcc -c y.tab.c lex.yy.c
	gcc y.tab.o lex.yy.o -o myParser

