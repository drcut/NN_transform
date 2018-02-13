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
STRUCT struct
RETURN return
IF if
ELSE else
WHILE while
PLUS \+
MINUS -
INTEGER [1-9]+[0-9]*|0
FLOAT   [0-9]+\.[0-9]*
VARIABLE [a-z_A-Z][a-zA-Z_0-9]*
SPACE [ \t\r]*
EOL \n
SEMI ;
COMMA ,
WELL #
ASSIGNOP =
RELOP >|<|>=|<=|==|!=
STAR \*
DIV \/
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
MATMUL tf.matmul
CONSTANT tf.constant
AERROR .
MASS [.]*
%%
{ASSIGNOP} {return ASSIGNOP;}
{EOL} {}
{FLOAT} {printf("get float:%s\n",yytext);
        yylval.str = malloc(sizeof(char*) * strlen(yytext));
        strcpy(yylval.str,yytext);
        return FLOAT;}
{VARIABLE} {printf("get variable:%s\n",yytext);
            yylval.str = malloc(sizeof(char*) * strlen(yytext));
            strcpy(yylval.str,yytext);
            return VARIABLE;}
{MATMUL} {yylval.str = "matmul";return MATMUL;}
{CONSTANT} {yylval.str = "constant";return CONSTANT;}
{LP} {yylval.str = "(";return LP;}
{RP} {yylval.str = ")";return RP;}
{LB} {yylval.str = "[";return LB;}
{RB} {yylval.str = "]";return RB;}
{COMMA} {yylval.str = ",";return COMMA;}
{WELL} {yylval.str = "#";return WELL;}
{MASS} {yylval.str = malloc(sizeof(char*) * strlen(yytext));
        strcpy(yylval.str,yytext);
        return MASS;}
{SPACE} {}
%%
int yywrap()
{
    return 1;
}
