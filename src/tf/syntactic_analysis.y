/*
*Author:HanRuobing
*Created on:2018-02-09
*Descroption:Semantic analysis for tensorflow.
*/
%{
#include<stdio.h>
%}
%token INTEGER FLOAT PLUS MINUS MULTIPLY DIV NOT LP RP LB RB DOT
%token VARIABLE LIST ASSIGNOP MATMUL CONSTANT
%type Program ExtDefList ExtDef ExtDecList Exp
%type FUNC NumericalOP
%type NNFUNC
/*priority*/
%right ASSIGNOP
%left PLUS MINUS
%left MULTIPLY DIV
%right NOT
%left LP RP LB RB DOT
%%
Program:|ExtDefList {};
ExtDefList:ExtDef ExtDefList {}| {};
ExtDef:Dec{};
Dec:VARIABLE ASSIGNOP Exp {} | VARIABLE ASSIGNOP Dec {};
NumericalOP:PLUS{}|MINUS{}|MULTIPLY{}|DIV{};
Exp:VARIABLE{}|Exp NumericalOP Exp{}|FUNC{};
NNFUNC:MATMUL{}|CONSTANT{};
FUNC:NNFUNC LP PARAMETERS RP{};
