/*
*Author:HanRuobing
*Created on:2018-02-09
*Descroption:Semantic analysis for tensorflow.
*/
%{
#include<unistd.h>
#include<stdio.h>
#include "util.h"
%}
%start Program
%union{
    char* str;
    struct node *p;
}

%token <str> LP RP LB RB COMMA FLOAT WELL SPACE EOL
%token <str> VARIABLE MATMUL CONSTANT MASS ASSIGNOP
%type <str> Program ExtDef ExtDefList
%type <p> EXPRESSION

/*priority*/
%right NOT COMMA
%left LP RP LB RB DOT
%%

Program:ExtDefList{$$ = "program";};
ExtDefList:ExtDef ExtDefList{$$="extdeflist";} | {$$="extdeflist";};
ExtDef:VARIABLE ASSIGNOP EXPRESSION{$$ = $1;$3->node_name = $1;add_node($1,$3);};
EXPRESSION:
    MATMUL LP VARIABLE COMMA VARIABLE RP{printf("get exp\n");$$ = new_node("matmul",2,get_node($3),get_node($5));};
/*
FUNC:NNFUNC LP PARAMETERS RP{$$ = new_node($1,0);printf("%s\n",$1);};
NNFUNC: CONSTANT {$$ = "constant";}|MATMUL{$$ = "matmul";};
PARAMETERS: VARIABLE COMMA VARIABLE{$$ = "parameters";};
*/
