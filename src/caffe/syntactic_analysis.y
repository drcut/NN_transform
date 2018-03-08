/*
*Author:HanRuobing
*Created on:2018-02-09
*Descroption:Semantic analysis for tensorflow.
*/
%{
#include<unistd.h>
#include<stdio.h>
#include "util.h"
struct node* tmp_node = NULL;
%}
%start Program
%union{
    char* str;
    struct node *p;
}

%token <str> LP RP LB RB LC RC COMMA FLOAT WELL SPACE EOL BOOL INTEGER NONE STRING PLUS MINUS MUL DIV DOT SEMICOLON LAYER
%token <str> VARIABLE CONSTANT ASSIGNOP DTYPE  NAME TOP BOTTOM TYPE
%type <str> Program ExtDef ExtDefList List Serial Serial_Element  KWARG_LIST
%type <str> Number NormalOP Optimizer AttrDefs AttrDef LayerDef
/*priority*/
%right NOT COMMA
%left LP RP LB RB DOT
%%

Program:ExtDefList{$$ = "program";};
ExtDefList:ExtDef ExtDefList | {$$="extdeflist";};
/*
NormalOP: PLUS | MINUS | MUL |DIV {$$ = $1;};
Number: MINUS Number {$$=concat_str(2,"-",$2);}|
        FLOAT | INTEGER {$$=$1;} |  Number NormalOP Number {$$ = concat_str(3,$1,$2,$3);};
*/
ExtDef:NAME SEMICOLON STRING{$$ = $3;printf("get name define\n");}|
       LayerDef  {$$ = $1;};
LayerDef:LAYER LC {tmp_node = malloc(sizeof(struct node));}AttrDefs RC{$$ = tmp_node->op_name;};
AttrDefs: |AttrDef AttrDefs{$$="attrs";};
AttrDef:
    NAME SEMICOLON STRING {tmp_node->node_name = $3;}|
    TYPE SEMICOLON STRING {tmp_node->op_name = $3;}|
    TOP SEMICOLON STRING {add_node($3,tmp_node);}|
    BOTTOM SEMICOLON STRING {tmp_node->input[tmp_node->input_cnt++] = get_node($3);}
/*
KWARG_LIST: {$$ = "";}|
    COMMA Serial {$$ = $2;};
Serial :{$$="";}| 
        Serial_Element COMMA Serial {printf("serial:%s %s\n",$1,$3);$$ = concat_str(3,$1,",",$3);} | 
        Serial_Element {$$ = $1;};
Serial_Element:Number  | NONE |List {$$ = $1;}|
        VARIABLE ASSIGNOP VARIABLE {$$ = concat_str(3,$1,":",$3);}|
        VARIABLE ASSIGNOP STRING {$$=concat_str(3,$1,":",$3);}|
        VARIABLE ASSIGNOP Number {$$=concat_str(3,$1,":",$3);}|
        VARIABLE ASSIGNOP List {$$=concat_str(3,$1,":",$3);}|
        EXPRESSION {$$=$1->node_name;};

KWARG_VALUE:BOOL | FLOAT | VARIABLE |List{$$=$1;};
List : LB Serial RB {$$ = concat_str(3,"[",$2,"]");};
FUNC:NNFUNC LP PARAMETERS RP{$$ = new_node($1,0);printf("%s\n",$1);};
NNFUNC: CONSTANT {$$ = "constant";}|MATMUL{$$ = "matmul";};
PARAMETERS: VARIABLE COMMA VARIABLE{$$ = "parameters";};
*/
