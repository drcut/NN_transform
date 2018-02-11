/*
 * Author:HanRuobing
 * Created on :2018-2-11
 * Description : Refer to util.h
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "util.h"
int i;
struct node* new_node(char* node_name,int num,...)//construct node of NN DAG
{
    struct node* tmp = (struct node*)malloc(sizeof(struct node));
    va_list valist;
    tmp->name = node_name;
    tmp->input_cnt = num;
    tmp->input = malloc(num * sizeof(char*));
    for(i = 0;i<num;i++)
        tmp->input[i] = va_arg(valist, struct node*);
    return tmp;
}
void yyerror(char*s,...) //变长参数错误处理函数
{
        va_list ap;
        va_start(ap,s);
        //fprintf(stderr,"%d:error:",yylineno);//错误行号
        vfprintf(stderr,s,ap);
        fprintf(stderr,"\n");
}
int main()
{
    return yyparse();
}
