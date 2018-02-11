/*
 * Authro:HanRuobing
 * Created on :2018-2-11
 * Description : Define DAG's node
 */
extern char* yytext;
void yyerror(char*s,...); //变长参数错误处理函数
struct node
{
    char* name;
    int input_cnt;
    struct node** input;
};
struct node* new_node(char* name,int num,...); 

