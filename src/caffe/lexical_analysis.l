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
POOL_ATTR MAX|MIN
NONE None
PLUS \+
MINUS -
MUL \*
DIV \/
INTEGER [1-9]+[0-9]*|0
FLOAT   [0-9]+\.[0-9]*
BOOL True|False
SPACE [ \t\r]*
EOL [\n]*
SEMI ;
SEMICOLON :
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
PARAM [a-zA-Z_0-9]*param
NAME name
TYPE type
TOP top
BOTTOM bottom
LAYER layer
DIM dim
ATTR_NAME [a-zA-Z_]*
STRING [\'\"][a-zA-Z_0-9]*[\'\"]
MASS [^\{\}]+
%%
{ASSIGNOP} {return ASSIGNOP;}
{EOL} {}
{NAME} {return NAME;}
{TOP} {return TOP;}
{TYPE} {return TYPE;}
{BOTTOM} {return BOTTOM;}
{LAYER} {return LAYER;}
{SEMICOLON} {return SEMICOLON;}
{FLOAT} {printf("get float:%s\n",yytext);
        yylval.str = malloc(sizeof(char*) * strlen(yytext));
        strcpy(yylval.str,yytext);
        return FLOAT;}
{INTEGER} {printf("get integer:%s\n",yytext);
        yylval.str = malloc(sizeof(char*) * strlen(yytext));
        strcpy(yylval.str,yytext);
        return INTEGER;}
{POOL_ATTR} {printf("get pool direction:%s\n",yytext);
            yylval.str = malloc(sizeof(char*) * strlen(yytext));
            strcpy(yylval.str,yytext);
            return POOL_ATTR;}
True|False {printf("get bool:%s\n",yytext);
            yylval.str = malloc(sizeof(char*) * strlen(yytext));
            strcpy(yylval.str,yytext);
            return BOOL;}
{PLUS} {yylval.str = "+";return PLUS;}
{MINUS} {yylval.str = "-";return MINUS;}
{MUL} {yylval.str = "*";return MUL;}
{DIV} {yylval.str = "//";return DIV;}
{DOT} {return DOT;}
{NONE} {yylval.str = "None";return NONE;}
{LP} {yylval.str = "(";return LP;}
{RP} {yylval.str = ")";return RP;}
{LB} {yylval.str = "[";return LB;}
{RB} {yylval.str = "]";return RB;}
{LC} {printf("get lc\n");return LC;}
{RC} {printf("get rc\n");return RC;}
{DIM} {return DIM;}
{COMMA} {yylval.str = ",";return COMMA;}
{WELL} {yylval.str = "#";return WELL;}
{PARAM} {printf("get param:%s\n",yytext);
            yylval.str = malloc(sizeof(char*) * strlen(yytext));
            strcpy(yylval.str,yytext);
            return PARAM;}
{STRING} {printf("get string:%s\n",yytext);
            yylval.str = malloc(sizeof(char*) * strlen(yytext));
            strcpy(yylval.str,yytext);
            yylval.str[strlen(yytext)-1] = '\0';
            yylval.str++;
            return STRING;}
{SPACE} {}
{ATTR_NAME} {printf("get attr name:%s\n",yytext);
            yylval.str = malloc(sizeof(char*) * strlen(yytext));
            strcpy(yylval.str,yytext);
            return ATTR_NAME;}
%%
int yywrap()
{
    return 1;
}
