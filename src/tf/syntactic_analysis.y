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

%token <str> LP RP LB RB COMMA FLOAT WELL SPACE EOL BOOL INTEGER NONE STRING PLUS MINUS MUL DIV DOT
%token <str> VARIABLE MATMUL CONSTANT MASS ASSIGNOP PLACEHOLDER DTYPE RESHAPE RELU BIAS_ADD CONV2D TFVARIABLE RANDOM_NORMAL MAX_POOL LRN DROPOUT ADAMOPTIMIZER MINIMIZE SOFTMAX_CROSS_ENTROPY_WITH_LOGITS REDUCE_MEAN COMMENT UNSTACK BASICLSTMCELL STATIC_RNN SOFTMAX GDOPTIMIZER
%type <str> Program ExtDef ExtDefList List Serial Serial_Element KWARG_LIST Index
%type <str> Number NormalOP Optimizer
%type <p> EXPRESSION

/*priority*/
%right NOT COMMA
%left LP RP LB RB DOT
%%

Program:ExtDefList{$$ = "program";};
ExtDefList:ExtDef ExtDefList | {$$="extdeflist";};
NormalOP: PLUS | MINUS | MUL |DIV {$$ = $1;};
Number: MINUS Number {$$=concat_str(2,"-",$2);}|
        FLOAT | INTEGER {$$=$1;} |  Number NormalOP Number {$$ = concat_str(3,$1,$2,$3);};
ExtDef:VARIABLE ASSIGNOP EXPRESSION{$$ = $1;$3->node_name = $1;add_node($1,$3);if(!strcmp("loss_op",$1)){printf("travel\n");travel_node($3);}}|
       VARIABLE COMMA VARIABLE ASSIGNOP EXPRESSION {$$=$1;$5->node_name = concat_str(3,$1,":",$3);add_node($1,$5);add_node($3,$5);}|
       VARIABLE ASSIGNOP Number  {$$ = $1;}|
       COMMENT;
Index: LB Number RB {$$=concat_str(3,$1,$2,$3);}| Index LB Number RB {$$ = concat_str(4,$1,$2,$3,$4);};
EXPRESSION:
    VARIABLE {$$ = get_node($1);}|
    VARIABLE Index {$$ = new_node("indexed",1,get_node($1));$$->attrs = $2;}|
    MATMUL LP EXPRESSION COMMA EXPRESSION {tmp_node = new_node("matmul",2,$3,$5);} KWARG_LIST RP{$$ = tmp_node;$$->attrs = $7;tmp_node=NULL;}|
    CONSTANT LP List RP{$$ = new_node("constant",0);} |
    RESHAPE LP EXPRESSION {tmp_node = new_node("reshape",1,$3);} KWARG_LIST RP {$$ = tmp_node;$$->attrs = $5;tmp_node=NULL;}|
    PLACEHOLDER LP DTYPE {tmp_node = new_node("placeholder",0);}KWARG_LIST RP {$$ = tmp_node;$$->attrs = $5;tmp_node=NULL;}|
    RANDOM_NORMAL LP List {tmp_node = new_node("random_normal",0);}KWARG_LIST RP {$$=tmp_node;$$->attrs = concat_str(2,$3,$5);}|
    TFVARIABLE LP EXPRESSION {tmp_node = new_node("variable",1,$3);}KWARG_LIST RP {$$=tmp_node;$$->attrs = $5;tmp_node=NULL;}|
    CONV2D LP EXPRESSION COMMA EXPRESSION {tmp_node = new_node("conv2d",2,$3,$5);}KWARG_LIST RP {$$ = tmp_node;$$->attrs = $7;tmp_node=NULL;}|
    BIAS_ADD LP EXPRESSION COMMA EXPRESSION {tmp_node = new_node("bias_add",2,$3,$5);}KWARG_LIST RP {$$ = tmp_node;$$->attrs=$7;tmp_node=NULL;}|
    RELU LP EXPRESSION {tmp_node = new_node("relu",1,$3);}KWARG_LIST RP {$$ = tmp_node;$$->attrs = $5;tmp_node=NULL;}|
    MAX_POOL LP EXPRESSION{tmp_node = new_node("max_pool",1,$3);} KWARG_LIST RP {$$ = tmp_node;$$->attrs = $5;tmp_node=NULL;}|
    LRN LP EXPRESSION {tmp_node = new_node("lrn",1,$3);}KWARG_LIST RP {$$=tmp_node;$$->attrs = $5;tmp_node=NULL;}|
    DROPOUT LP EXPRESSION COMMA EXPRESSION {tmp_node = new_node("dropout",2,$3,$5);}KWARG_LIST RP {$$=tmp_node;$$->attrs = $8;tmp_node=NULL;}|
    EXPRESSION NormalOP EXPRESSION {$$ = new_node($2,2,$1,$3);}|
    Optimizer DOT MINIMIZE LP EXPRESSION RP {$$ = new_node("optimize",1,$5);$$->attrs = $1;}|
    Optimizer {$$=new_node("optimizer",0);$$->attrs = $1;}|
    VARIABLE DOT MINIMIZE LP EXPRESSION RP {$$=new_node("optimize",2,get_node($1),$5);}|
    SOFTMAX_CROSS_ENTROPY_WITH_LOGITS LP {tmp_node = new_node("softmax_cross_entropy_with_logits",0);}Serial RP {$$=tmp_node;$$->attrs = $1;tmp_node=NULL;}|
    REDUCE_MEAN LP EXPRESSION RP {$$=new_node("reduce_mean",1,$3);}|
    UNSTACK LP EXPRESSION {tmp_node=new_node("unstack",1,$3);}KWARG_LIST RP {$$=tmp_node;$$->attrs = $5;tmp_node=NULL;}|
    BASICLSTMCELL LP Serial RP {$$=new_node("basicLSTMcell",0);$$->attrs = $3;}|
    STATIC_RNN LP EXPRESSION COMMA EXPRESSION {tmp_node=new_node("static_rnn",2,$3,$5);}KWARG_LIST RP {$$=tmp_node;$$->attrs=$7;tmp_node=NULL;}|
    SOFTMAX LP EXPRESSION {tmp_node=new_node("softmax",1,$3);}KWARG_LIST RP{$$=tmp_node;$$->attrs=$5;tmp_node=NULL;};
Optimizer:
    GDOPTIMIZER LP Serial RP {$$=concat_str(2,$1,$3);}|
    ADAMOPTIMIZER LP Serial RP {$$ = concat_str(2,$1,$3);};
KWARG_LIST: {$$ = "";}|
    COMMA Serial {$$ = $2;};
Serial :{$$="";}| 
        Serial_Element COMMA Serial {printf("serial:%s %s\n",$1,$3);$$ = concat_str(3,$1,",",$3);} | 
        Serial_Element {$$ = $1;};
Serial_Element:Number  | NONE |List {$$ = $1;}|
        VARIABLE ASSIGNOP VARIABLE {$$ = concat_str(3,$1,":",$3);if(tmp_node) add_input(tmp_node,get_node($3));}|
        VARIABLE ASSIGNOP STRING {$$=concat_str(3,$1,":",$3);}|
        VARIABLE ASSIGNOP Number {$$=concat_str(3,$1,":",$3);}|
        VARIABLE ASSIGNOP DTYPE {$$=concat_str(3,$1,":",$3);}|
        VARIABLE ASSIGNOP List {$$=concat_str(3,$1,":",$3);}|
        EXPRESSION {$$=$1->node_name;};
List : LB Serial RB {$$ = concat_str(3,"[",$2,"]");};
/*
COMMENT: SINGLE_QUOTE SINGLE_QUOTE SINGLE_QUOTE Comment_msg_single SINGLE_QUOTE SINGLE_QUOTE SINGLE_QUOTE |
        DOUBLE_QUOTE DOUBLE_QUOTE DOUBLE_QUOTE Comment_msg_double DOUBLE_QUOTE DOUBLE_QUOTE DOUBLE_QUOTE {$$ = $4;};
Comment_msg_single:  PURE_COMMENT_SINGLE | Comment_msg_single SINGLE_QUOTE Comment_msg_single{$$ = concat_str(3,$1,"\'",$3);} | Comment_msg_single SINGLE_QUOTE SINGLE_QUOTE Comment_msg_single{$$ = concat(3,$1,"\'\'",$4);};
Comment_msg_double:  PURE_COMMENT_DOUBLE | Comment_msg_double DOUBLE_QUOTE Comment_msg_double{$$ = concat_str(3,$1,"\'",$3);} | Comment_msg_double DOUBLE_QUOTE DOUBLE_QUOTE Comment_msg_double{$$ = concat(3,$1,"\'\'",$4);};
*/
