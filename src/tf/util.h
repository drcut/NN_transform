/*
 * Authro:HanRuobing
 * Created on :2018-2-11
 * Description : Define DAG's node
 */
#include <vector>
extern char* yytext;
struct node
{
    char* name;
    int input_cnt;
    struct node** input;
    node(char* name,int num,...);
};
    

