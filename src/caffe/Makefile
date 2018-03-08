lexical_analysis:lexical_analysis.l util.h util.c syntactic_analysis.y
	bison -d syntactic_analysis.y
	flex lexical_analysis.l
	gcc syntactic_analysis.tab.c lex.yy.c util.c
