/*
*Author:HanRuobing
*Created on:2018-02-09
*Descroption:Semantic analysis for caffe.
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
%token <str> VARIABLE CONSTANT ASSIGNOP DTYPE  NAME TOP BOTTOM TYPE PARAM SHAPE ATTR_NAME DIM POOL_ATTR
%type <str> Program ExtDef ExtDefList  DIM_LIST
%type <str> Number NormalOP AttrDefs AttrDef LayerDef PARAM_ATTRS PARAM_ATTR PARAM_ATTR_VAL
/*priority*/
%right NOT COMMA
%left LP RP LB RB DOT
%%

Program:ExtDefList{$$ = "program";};
ExtDefList:ExtDef ExtDefList | {$$="extdeflist";};

NormalOP: PLUS | MINUS | MUL |DIV {$$ = $1;};
Number: MINUS Number {$$=concat_str(2,"-",$2);}|
        FLOAT | INTEGER {$$=$1;} |  Number NormalOP Number {$$ = concat_str(3,$1,$2,$3);};

ExtDef:NAME SEMICOLON STRING{$$ = $3;printf("get name define\n");}|
       LayerDef  {$$ = $1;printf("tmp_node->node_name:%s\n",tmp_node->node_name);if(!strcmp(tmp_node->node_name,"prob")){printf("travel\n");travel_node(tmp_node);}};
LayerDef:LAYER LC {tmp_node = malloc(sizeof(struct node));tmp_node->pid = -1;tmp_node->input_cnt = 0;}AttrDefs RC{$$ = tmp_node->node_name;};
AttrDefs: |AttrDef AttrDefs {$$="attrs";};
AttrDef:
    NAME SEMICOLON STRING {tmp_node->node_name = $3;}|
    TYPE SEMICOLON STRING {tmp_node->op_name = $3;}|
    TOP SEMICOLON STRING {add_node($3,tmp_node);}|
    BOTTOM SEMICOLON STRING {printf("add input %s\n",$3);add_input(tmp_node,get_node($3));}|
    PARAM LC PARAM_ATTRS RC {tmp_node->attrs = $3;};
PARAM_ATTRS: PARAM_ATTR{$$=$1;}|PARAM_ATTR PARAM_ATTRS{$$ = concat_str(3,$1,",",$2);};
PARAM_ATTR: ATTR_NAME SEMICOLON LC DIM_LIST RC {$$ = concat_str(3,$1,":",$4);}|
            ATTR_NAME SEMICOLON PARAM_ATTR_VAL {$$ = concat_str(3,$1,":",$3);};
PARAM_ATTR_VAL:
    Number {$$=$1;}| POOL_ATTR {$$=$1;};
DIM_LIST: {$$ = "";}| DIM SEMICOLON Number DIM_LIST {$$ = concat_str(3,$3,",",$4);};
