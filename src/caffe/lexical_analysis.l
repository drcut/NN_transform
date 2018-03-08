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
PARAM [a-zA-Z_0-9]*_param
NAME name
TYPE type
TOP top
BOTTOM bottom
LAYER layer
STRING [\'\"][a-zA-Z_0-9]*[\'\"]
AERROR .
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
{LC} {return LC;}
{RC} {return RC;}
{COMMA} {yylval.str = ",";return COMMA;}
{WELL} {yylval.str = "#";return WELL;}
{STRING} {printf("get string:%s\n",yytext);
            yylval.str = malloc(sizeof(char*) * strlen(yytext));
            strcpy(yylval.str,yytext);
            /*yylval.str[strlen(yytext)-1] = '\0';
            ++yylval.str;*/
            return STRING;}
{SPACE} {}
%%
int yywrap()
{
    return 1;
}
