/*
*Author:HanRuobing
*Created on:2018-02-09
*Descroption:Semantic analysis for tensorflow.
*/
%{
#include<stdio.h>
%}
%start Program
%union{
    char* str;
    struct node* p;
}

%token INTEGER FLOAT PLUS MINUS MULTIPLY DIV NOT LP RP LB RB DOT
%token VARIABLE LIST ASSIGNOP MATMUL CONSTANT
%type Program ExtDefList ExtDef ExtDecList Exp
%type <p> FUNC NumericalOP
%type <str> NNFUNC

/*priority*/
%right ASSIGNOP
%left PLUS MINUS
%left MULTIPLY DIV
%right NOT
%left LP RP LB RB DOT
%%
Program:{}|ExtDefList {};
ExtDefList:ExtDef ExtDefList {}| {};
ExtDef:Dec{};
Dec:VARIABLE ASSIGNOP Exp {} | VARIABLE ASSIGNOP Dec {};
NumericalOP:PLUS{}|MINUS{}|MULTIPLY{}|DIV{};
Exp:VARIABLE{}|Exp NumericalOP Exp{}|FUNC{};
NNFUNC:MATMUL{}|CONSTANT{};
FUNC:NNFUNC LP PARAMETERS RP{$$ = &(node($1,0));printf("%s\n",$1)};
NNFUNC: CONSTANT {$$ = "constant";}|MATMUL{$$ = "matmul";};
PARAMETERS: PARAMETER PARAMETERS{} | {};
PARAMETER: VARIABLE{};
