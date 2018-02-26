/*
* Author:HanRuobing
*Created on:2018-2-9
*Description:lexical analysis for tensorflow's network construction
*/
%{
#include "stdio.h"
#include "stdlib.h"
#include "syntactic_analysis.tab.h"
#include "util.h"
%}
type int|float
NONE None
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while
PLUS \+
MINUS -
MUL \*
DIV \/
INTEGER [1-9]+[0-9]*|0
FLOAT   [0-9]+\.[0-9]*
BOOL True|False
SPACE [ \t\r]*
EOL \n
SEMI ;
COMMA ,
WELL #
ASSIGNOP =
RELOP >|<|>=|<=|==|!=
AND &&
OR \|\|
DOT \.
NOT !
LP \(
RP \)
LB \[
RB \]
LC \{
RC \}
MATMUL tf\.matmul
CONSTANT tf\.constant
RESHAPE tf\.reshape
MAX_POOL tf\.nn\.max_pool
DTYPE tf\.float32
PLACEHOLDER tf\.placeholder
RELU tf\.nn\.relu
BIAS_ADD tf\.nn\.bias_add
CONV2D tf\.nn\.conv2d
TFVARIABLE tf\.Variable
LRN tf\.nn\.lrn
DROPOUT tf\.nn\.dropout
RANDOM_NORMAL tf\.random_normal
VARIABLE [a-z_A-Z][a-zA-Z_0-9]*
STRING [\'\"][a-zA-Z_0-9]*[\'\"]
AERROR .
MASS [.]*
%%
{ASSIGNOP} {return ASSIGNOP;}
{EOL} {}
{RELU} {return RELU;}
{BIAS_ADD} {return BIAS_ADD;}
{CONV2D} {return CONV2D;}
{TFVARIABLE} {return TFVARIABLE;}
{RANDOM_NORMAL} {return RANDOM_NORMAL;}
{FLOAT} {printf("get float:%s\n",yytext);
        yylval.str = malloc(sizeof(char*) * strlen(yytext));
        strcpy(yylval.str,yytext);
        return FLOAT;}
{DTYPE} {printf("get dtype:%s\n",yytext);
        yylval.str = malloc(sizeof(char*) * strlen(yytext));
        strcpy(yylval.str,yytext);
        return DTYPE;}
{INTEGER} {printf("get integer:%s\n",yytext);
        yylval.str = malloc(sizeof(char*) * strlen(yytext));
        strcpy(yylval.str,yytext);
        return INTEGER;}
True|False {printf("get bool:%s\n",yytext);
            yylval.str = malloc(sizeof(char*) * strlen(yytext));
            strcpy(yylval.str,yytext);
            return BOOL;}
{PLUS} {yylval.str = "+";return PLUS;}
{MINUS} {yylval.str = "-";return MINUS;}
{MUL} {yylval.str = "*";return MUL;}
{DIV} {yylval.str = "//";return DIV;}
{NONE} {yylval.str = "None";return NONE;}
{PLACEHOLDER} {yylval.str = "placeholder";return PLACEHOLDER;}
{MATMUL} {yylval.str = "matmul";return MATMUL;}
{CONSTANT} {yylval.str = "constant";return CONSTANT;}
{RESHAPE} {yylval.str = "reshape";return RESHAPE;}
{MAX_POOL} {return MAX_POOL;}
{LRN} {return LRN;}
{DROPOUT} {return DROPOUT;}
{LP} {yylval.str = "(";return LP;}
{RP} {yylval.str = ")";return RP;}
{LB} {yylval.str = "[";return LB;}
{RB} {yylval.str = "]";return RB;}
{COMMA} {yylval.str = ",";return COMMA;}
{WELL} {yylval.str = "#";return WELL;}
{VARIABLE} {printf("get variable:%s\n",yytext);
            yylval.str = malloc(sizeof(char*) * strlen(yytext));
            strcpy(yylval.str,yytext);
            return VARIABLE;}
{STRING} {printf("get string:%s\n",yytext);
            yylval.str = malloc(sizeof(char*) * strlen(yytext));
            strcpy(yylval.str,yytext);
            return STRING;}
{MASS} {printf("mass:%s\n",yytext);yylval.str = malloc(sizeof(char*) * strlen(yytext));
        strcpy(yylval.str,yytext);
        return MASS;}
{SPACE} {}
%%
int yywrap()
{
    return 1;
}
