/*
 * Author:HanRuobing
 * Created on :2018-2-11
 * Description : Refer to util.h
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include "util.h"

node::node(char* node_name,int num,...)//construct node of NN DAG
{
    va_list valist;
    name = node_name;
    input_cnt = num;
    input = malloc(input_cnt * sizeof(struct node*);
    for(int i = 0;i<num;i++)
        input[i] = va_arg(valist, struct node*);
}

int main()
{
    return yyparse();
}
