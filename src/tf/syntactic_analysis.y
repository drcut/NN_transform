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

%token <str> LP RP LB RB COMMA FLOAT WELL SPACE EOL BOOL
%token <str> VARIABLE MATMUL CONSTANT MASS ASSIGNOP
%type <str> Program ExtDef ExtDefList List Serial Serial_Element  KWARG_LIST KWARG_VALUE
%type <p> EXPRESSION

/*priority*/
%right NOT COMMA
%left LP RP LB RB DOT
%%

Program:ExtDefList{$$ = "program";};
ExtDefList:ExtDef ExtDefList | {$$="extdeflist";};
ExtDef:VARIABLE ASSIGNOP EXPRESSION{$$ = $1;$3->node_name = $1;add_node($1,$3);};
EXPRESSION:
    MATMUL LP VARIABLE COMMA VARIABLE KWARG_LIST RP{$$ = new_node(concat_str(3,"matmul",$3,$5),2,get_node($3),get_node($5));$$->attrs = $6;}|
    CONSTANT LP List RP{$$ = new_node("constant",0);};
KWARG_LIST:{$$ = "";}
    |COMMA Serial {$$ = $2;};
Serial :| 
        Serial_Element COMMA Serial {printf("serial:%s %s\n",$1,$3);$$ = concat_str(3,$1,",",$3);} | 
        Serial_Element {$$ = $1;};
Serial_Element:FLOAT {$$ = $1;}| VARIABLE {$$ = $1;}| List {$$ = $1;} | 
                VARIABLE ASSIGNOP KWARG_VALUE {$$ = concat_str(3,$1,$2,$3);};
KWARG_VALUE:BOOL | FLOAT | VARIABLE |List{$$=$1;};
List : LB Serial RB {$$ = concat_str(3,"[",$2,"]");};
/*
FUNC:NNFUNC LP PARAMETERS RP{$$ = new_node($1,0);printf("%s\n",$1);};
NNFUNC: CONSTANT {$$ = "constant";}|MATMUL{$$ = "matmul";};
PARAMETERS: VARIABLE COMMA VARIABLE{$$ = "parameters";};
*/
