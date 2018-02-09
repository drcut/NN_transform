/*
* Author:HanRuobing
*Created on:2018-2-9
*Description:lexical analysis for tensorflow's network construction
*/
%{
#include "stdio.h"
#include "stdlib.h"
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
FLOAT   [0-9]+\.[0-9][.]?
VARIABLE [a-z_A-Z][a-zA-Z_0-9]*
SPACE [ \t\r]*
EOL \n
SEMI ;
COMMA ,
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
%%
{FLOAT} {printf("float ");}
{VARIABLE} {printf("variable ");}
{MATMUL} {printf("matmul ");}
{CONSTANT} {printf("constant ");}
{LP} {printf("(");}
{RP} {printf(")");}
{LB} {printf("[");}
{RB} {printf("]");}
%%
int main()
{
    yylex();
    return 0;
}
int yywrap()
{
    return 1;
}
