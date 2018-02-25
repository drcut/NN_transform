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

%token <str> LP RP LB RB COMMA FLOAT WELL SPACE EOL BOOL INTEGER NONE STRING
%token <str> VARIABLE MATMUL CONSTANT MASS ASSIGNOP PLACEHOLDER DTYPE RESHAPE RELU BIAS_ADD CONV2D TFVARIABLE RANDOM_NORMAL
%type <str> Program ExtDef ExtDefList List Serial Serial_Element  KWARG_LIST
%type <str> Number
%type <p> EXPRESSION

/*priority*/
%right NOT COMMA
%left LP RP LB RB DOT
%%

Program:ExtDefList{$$ = "program";};
ExtDefList:ExtDef ExtDefList | {$$="extdeflist";};
Number: FLOAT | INTEGER {$$=$1;};
ExtDef:VARIABLE ASSIGNOP EXPRESSION{$$ = $1;$3->node_name = $1;add_node($1,$3);if(!strcmp("conv1",$1)){printf("travel\n");travel_node($3);}}|
       VARIABLE ASSIGNOP Number  {$$ = $1;};
EXPRESSION:
    VARIABLE {$$ = get_node($1);}|
    MATMUL LP EXPRESSION COMMA EXPRESSION KWARG_LIST RP{$$ = new_node("matmul",2,$3,$5);$$->attrs = $6;}|
    CONSTANT LP List RP{$$ = new_node("constant",0);} |
    RESHAPE LP EXPRESSION KWARG_LIST RP {$$ = new_node("reshape",1,$3);}|
    PLACEHOLDER LP DTYPE KWARG_LIST RP {$$ = new_node("placeholder",0);}|
    RANDOM_NORMAL LP List KWARG_LIST RP {$$ = new_node("random_normal",0);}|
    TFVARIABLE LP EXPRESSION KWARG_LIST RP {$$ = new_node("variable",1,$3);}|
    CONV2D LP EXPRESSION COMMA EXPRESSION KWARG_LIST RP {$$ = new_node("conv2d",2,$3,$5);$$->attrs = $6;}|
    BIAS_ADD LP EXPRESSION COMMA EXPRESSION KWARG_LIST RP {$$ = new_node("bias_add",2,$3,$5);}|
    RELU LP EXPRESSION KWARG_LIST RP {$$ = new_node("relu",1,$3);$$->attrs = $4;};
KWARG_LIST: {$$ = "";}|
    COMMA Serial {$$ = $2;};
Serial :{$$="";}| 
        Serial_Element COMMA Serial {printf("serial:%s %s\n",$1,$3);$$ = concat_str(3,$1,",",$3);} | 
        Serial_Element {$$ = $1;};
Serial_Element:Number  | NONE |List {$$ = $1;}|
        VARIABLE ASSIGNOP STRING {$$=concat_str(3,$1,":",$3);}|
        VARIABLE ASSIGNOP Number |
        VARIABLE ASSIGNOP List {$$=concat_str(3,$1,":",$3);}|
        EXPRESSION {$$=$1->node_name;};
/*
KWARG_VALUE:BOOL | FLOAT | VARIABLE |List{$$=$1;};
*/
List : LB Serial RB {$$ = concat_str(3,"[",$2,"]");};
/*
FUNC:NNFUNC LP PARAMETERS RP{$$ = new_node($1,0);printf("%s\n",$1);};
NNFUNC: CONSTANT {$$ = "constant";}|MATMUL{$$ = "matmul";};
PARAMETERS: VARIABLE COMMA VARIABLE{$$ = "parameters";};
*/
