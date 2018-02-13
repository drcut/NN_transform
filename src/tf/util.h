/*
 * Authro:HanRuobing
 * Created on :2018-2-11
 * Description : Define DAG's node
 */
extern char* yytext;
void yyerror(char*s,...); //变长参数错误处理函数
struct node
{
    char* op_name;
    char* node_name;
    int input_cnt;
    struct node** input;
};
struct node* new_node(char* node_op_name,int num,...);

//char* get_name(char* raw_name);// to resolve name reuse problem

struct node* get_node(char* variable_name);

void add_node(char* node_name,struct node* p);
