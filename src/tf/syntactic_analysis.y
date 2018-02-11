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
%start FUNC
%union{
    char* str;
    struct node *p;
}

%token <str> LP RP LB RB COMMA FLOAT
%token <str> VARIABLE MATMUL CONSTANT
%type <p> FUNC
%type <str> NNFUNC PARAMETERS

/*priority*/
%right NOT COMMA
%left LP RP LB RB DOT
%%

FUNC:NNFUNC LP PARAMETERS RP{$$ = new_node($1,0);printf("%s\n",$1);};
NNFUNC: CONSTANT {$$ = "constant";}|MATMUL{$$ = "matmul";};
PARAMETERS: VARIABLE COMMA VARIABLE{$$ = "parameters";};
