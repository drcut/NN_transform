/*
 * Author:HanRuobing
 * Created on :2018-2-11
 * Description : Refer to util.h
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include "util.h"
#define MAXN 100
char* name_list[MAXN];
int id_list[MAXN];
struct node* node_list[MAXN];
int tail = 0;
int edge_num = 0;
int node_num = 0;
int edge_start[MAXN];
int edge_end[MAXN];
int visit[MAXN];
char* node_name[MAXN];
char* node_attr[MAXN];
char* node_op[MAXN];
struct node* new_node(char* node_op_name,int num,...)//construct node of NN DAG
{
    struct node* tmp = (struct node*)malloc(sizeof(struct node));
    va_list valist;
    va_start(valist,num);
    tmp->op_name = node_op_name;
    tmp->input_cnt = num;
    tmp->input = malloc(num * sizeof(struct node*));
    tmp->pid = -1;//use to dfs
    int i;
    for(i = 0;i<num;i++)
        tmp->input[i] = va_arg(valist, struct node*);
    va_end(valist);
    return tmp;
}
void dfs(struct node* root)
{
    if(visit[root->pid])return;//already visited
    visit[root->pid] = 1;
    node_name[root->pid] = root->node_name;
    node_attr[root->pid] = root->attrs;
    node_op[root->pid] = root->op_name;
    int i = 0;
    for(i = 0;i<root->input_cnt;i++)
    {
        if(root->input[i]->pid == -1)
            root->input[i]->pid = node_num++;
        edge_end[edge_num] = root->pid;
        edge_start[edge_num] = root->input[i]->pid;
        edge_num++;
    }
    for(i = 0;i<root->input_cnt;i++)
        dfs(root->input[i]);
}
void travel_node(struct node* start)
{
    edge_num = node_num = 0;
    memset(visit,0,sizeof(visit));
    int i;
    /* 
    printf("name=%s\n",start->node_name);
    printf("op name=%s\nattrs=%s\n",start->op_name,start->attrs);
    printf("son_num=%d\n",start->input_cnt);
    
    for(i = 0;i<start->input_cnt;i++)
        travel_node(start->input[i]);
    */
    start->pid = node_num++; 
    dfs(start);
    FILE* fp;
    if((fp=fopen("net_file.txt","w"))==NULL)
    {
        printf("can not open file\n");
        return;
    }
    fprintf(fp,"%d %d\n",node_num,edge_num);
    for(i = 0;i<node_num;i++)
        fprintf(fp,"%s\n%s\n%s\n",node_name[i],node_op[i],node_attr[i]);
    for(i = 0;i<edge_num;i++)
        fprintf(fp,"%d %d\n",edge_start[i],edge_end[i]);
    fclose(fp);
    return;
    
}
char* concat_str(int num,...)
{
    va_list valist;
    va_list tmp_list;
    va_start(tmp_list,num);
    int i ;
    unsigned int total_size = 1; // for '\0'
    for( i = 0;i<num;i++)
        total_size += strlen(va_arg(tmp_list,const char*));
    va_end(tmp_list);
    va_start(valist,num);
    char* res = malloc(total_size * sizeof(char));
    for(i = 0;i<num;i++)
    {
        char* t = va_arg(valist,char*);
        strcat(res,t);
    }
    va_end(valist);
    return res;
}
void yyerror(char*s,...) //变长参数错误处理函数
{
        va_list ap;
        va_start(ap,s);
        vfprintf(stderr,s,ap);
        fprintf(stderr,"\n");
        va_end(ap);
}
char* get_name(char* raw_name)
{
    int i;
    for(i = 0;i<tail;i++)
        if(!strcmp(raw_name,name_list[i]))
            break;
    if(i==tail)
    {
        tail++;
        name_list[i] = raw_name;
    }
}

struct node* get_node(char* variable_name)
{
    int i;
    for(i = 0; i<tail;i++)
        if(!strcmp(variable_name,name_list[i]))
            break;
    if(i==tail)
    {
        fprintf(stderr,"Don't have name %s\n",variable_name);
        struct node* res = new_node("init",0);
        res->node_name = variable_name;
        return res;
    }
    return node_list[i]; 
}

void add_node(char* node_name,struct node* p)
{
    int i;
    for(i = 0; i<tail;i++)
        if(!strcmp(node_name,name_list[i]))
            break;
    if(i==tail)
        tail++;
    node_list[i] = p;
    name_list[i] = node_name;
}

void add_input(struct node* p,struct node* input_node)
{
    struct node** new_input = malloc((p->input_cnt + 1) * sizeof(struct node*));
    memcpy(new_input,p->input,p->input_cnt * sizeof(struct node*));
    new_input[p->input_cnt] = input_node;
    ++p->input_cnt;
    p->input = new_input;
}
int main()
{
    return yyparse();
}
