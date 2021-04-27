%{
	#include<stdio.h>
	#include<ctype.h>
	#include<stdlib.h>
	#include<string.h>
	#include<math.h>
	int yylex(void);
	int yyerror(const char *s);
	int success = 1;
	
	
	typedef struct token_node
	{
		int line;
		char* var_name;
		int value;
		char* type;
		int scope;
		struct token_node* next; 
	} token_node;
	token_node* head=NULL;
	extern int enc_line[100];
	extern int no_of_entries;
	char varr[100];
	extern char var_name[100];
	extern int line;
	extern int scope;
	int array = 0;
	int t=0;
	extern char type[100];
	token_node* make_node(int line, char* var_name, int value, char* type,int scope);
	void search_and_replace_or_add(int line,char* var_name,int value,char* type,int scope);
	token_node* create_head();
	void print_list();

	token_node* make_node(int line, char* var_name, int value, char* type,int scope)
	{
		token_node* node= (token_node*)malloc(sizeof(token_node));
		node->line=line;
		node->var_name=(char*)malloc(sizeof(char)*strlen(var_name));
		
		node->type=(char*)malloc(sizeof(char)*strlen(type));
		node->scope=scope;    
		strcpy(node->var_name,var_name);
		node->value=value;
		strcpy(node->type,type);
		node->next=NULL;
		return node;
	}
	void print_list()
	{
		if(head==NULL)
		{   
			printf("IT IS EMPTY\n");
			return;
		}
		printf("Line number \t Var name \t Value \t\t Type \t\t Scope\n");
		token_node* temp=head;
		while(temp!=NULL)
		{
			printf("%d \t\t %s \t\t %d \t\t %s \t %d\n",temp->line,temp->var_name,temp->value,temp->type,temp->scope);
			temp=temp->next;
		}
		
	}

	void search_and_replace_or_add(int line,char* var_name,int value,char* type,int scope)
	{
		
		if(head==NULL)
		{
			token_node* node=make_node(line,var_name,value,type,scope);
			head=node;
			return;
		}
		else{
		token_node* temp=head;
		token_node* prev=head;
		int found=0;
		while(temp!=NULL)
		{
			if(found==0 && temp->scope==scope && strcmp(temp->var_name,var_name)==0)
			{
				temp->line=line;
				temp->value=value;
				strcpy(temp->type,type);
				found=1;
			}
			prev=temp;
			temp=temp->next;
		}
		
		if(!found){
		token_node* node=make_node(line,var_name,value,type,scope);
		prev->next=node;}}
        return;
	}
	int symval(char* var_name,int scope)
	{
		token_node* temp=head;
		token_node* prev=head;
		int val=0;
		int found=0;
		while(temp!=NULL)
		{
			if(found==0 && temp->scope==scope && strcmp(temp->var_name,var_name)==0)
			{
				found=1;
				val=temp->value;
			}
			prev=temp;
			temp=temp->next;
		}
		return val;
	}
	
struct  quadruple
{
    char operator[10];
    char operand1[10];
    char operand2[10];
    char result[10];
} quad[50];

struct Stack
{
    char *items[30];
    int top;
}Stk;
  
int Index=0;

void display_quadruple()
{
  int i;
  printf("\n \t\t\t ---- The  Qadruple Table ---- ");
  printf("\nOperator \t Operand1 \t Operand2 \t Result \n");
  for(i=0;i<Index;i++)
    printf("%s \t\t %s \t\t %s \t\t %s\n", quad[i].operator, quad[i].operand1, quad[i].operand2, quad[i].result);
  printf("\n");
}

void push(char *str)
{
  Stk.top++;
    Stk.items[Stk.top]=(char *)malloc(strlen(str)+1);
  strcpy(Stk.items[Stk.top],str);
}
char * pop()
{
  int i;
  if(Stk.top==-1)
  {
     printf("\nStack Empty!! \n");
     exit(0);
  }
  char *str=(char *)malloc(strlen(Stk.items[Stk.top])+1);;
  strcpy(str,Stk.items[Stk.top]);
  Stk.top--;
  return(str);
}

void addquadruple(char op[10],char op1[10],char op2[10],char res[10]){
    strcpy( quad[Index].operator,op);
	strcpy( quad[Index].operand2,op2);
    strcpy( quad[Index].operand1,op1);
    strcpy( quad[Index].result,res);
    Index++;
}
int l=0;	
char r[3];	
char str1c[5]="L";
char str1e[5]="L";
char st1c[5]="L";
char st1e[5]="L";
%}


%token ID NUM VAR LET CONST FOR DO WHILE new STR DOC CON
%token T_COL T_SEMICOL T_GT T_LT T_GTE T_LTE T_EQ T_NEQ T_PL T_MI T_MUL T_DIV T_OSB T_CSB T_EQUAL T_OP T_CP T_AUG T_OFB T_CFB T_C T_I T_D
%left T_PL T_MI T_GT T_LT T_GTE T_LTE T_EQ T_NEQ
%left T_MUL T_DIV

%%
start : prog{printf("Valid Input\n");printf("\t\t\t----- Symbol Table -----\n");print_list(head);display_quadruple();};
prog	:prog S
		|
	;
	
S	:D 
	|A T_SEMICOL
	|FOR T_OP A T_SEMICOL {char strc[5];sprintf(strc, "%d", l);strcat(str1c,strc);l++;addquadruple("label","","",str1c);}cond{char stre[5];sprintf(stre, "%d", l);strcat(str1e,stre);l++;addquadruple("ifalse",pop(),"",str1e); } T_SEMICOL una T_CP T_OFB prog{ addquadruple("goto","","",str1c);} T_CFB {addquadruple("label","","",str1e);}
	|DO{char stre[5];sprintf(stre, "%d", l);strcat(st1e,stre);l++;addquadruple("label","","",st1e);} T_OFB  S  T_CFB WHILE T_OP cond{char strc[5];sprintf(strc, "%d", l);strcat(st1c,strc);l++;addquadruple("ifalse",pop(),"",st1c);addquadruple("goto","","",st1e); } T_CP T_SEMICOL {addquadruple("label","","",st1c);}
	|E T_SEMICOL 
	|cond T_SEMICOL
	|una T_SEMICOL 
	|DOC T_OP E T_CP T_SEMICOL 
	|CON T_OP E T_CP T_SEMICOL 
	;
	

	
D	:T L T_SEMICOL 
	;
T	:VAR	
	|CONST
	;
L	:X T_C L
	|X
	;
X	:ID	{search_and_replace_or_add(line,var_name,0," ",scope);}
	|A
	;
A	:ID{strcpy(varr,var_name);} T_EQUAL E	{$$=$4 ;search_and_replace_or_add(line,varr,$$ ,type,scope);
						addquadruple("=",pop(),"",varr);
							}
							
	;

una	:ID T_I	{int vv=symval(var_name,scope);
		$$ = vv+1;
		search_and_replace_or_add(line,var_name,$$ ,type,scope);
		char str[5],str1[5]="t";
                sprintf(str, "%d", t);   
                strcat(str1,str);
                t++;
                addquadruple("+",var_name,"1",str1);                               
                push(str1);
                addquadruple("=",pop(),"",var_name);
		
                }
	|ID T_D	{int vv=symval(var_name,scope);
		$$ = vv-1;
		search_and_replace_or_add(line,var_name,$$ ,type,scope);
		char str[5],str1[5]="t";
                sprintf(str, "%d", t);   
                strcat(str1,str);
                t++;
                addquadruple("-",var_name,"1",str1);                               
                push(str1);
                addquadruple("=",pop(),"",var_name);}
	|T_I ID	{int vv=symval(var_name,scope);
		$$ = vv+1;
		search_and_replace_or_add(line,var_name,$$ ,type,scope);
		char str[5],str1[5]="t";
                sprintf(str, "%d", t);   
                strcat(str1,str);
                t++;
                addquadruple("+",var_name,"1",str1);                               
                push(str1);
                addquadruple("=",pop(),"",var_name);}
	|T_D ID	{int vv=symval(var_name,scope);
		$$ = vv-1;
		search_and_replace_or_add(line,var_name,$$ ,type,scope);
		char str[5],str1[5]="t";
                sprintf(str, "%d", t);   
                strcat(str1,str);
                t++;
                addquadruple("-",var_name,"1",str1);                               
                push(str1);
                addquadruple("=",pop(),"",var_name);
                }
	;
cond	:E rel E	{if (strcmp(r,"<")==0){
				if($1<$3){  $$=1;}
				else
					 $$=0;
				}
		
			if (strcmp(r,">")==0){
				if($1>$3){  $$=1;}
				else
					 $$=0;
				}
			if (strcmp(r,">=")==0){
				if($1>=$3){  $$=1;}
				else
					 $$=0;
				}
			if (strcmp(r,"<=")==0){
				if($1<=$3){  $$=1;}
				else
					 $$=0;
				}
			if (strcmp(r,"==")==0){
				if($1==$3){  $$=1;}
				else
					 $$=0;
				}
			if (strcmp(r,"!=")==0){
				if($1!=$3){  $$=1;}
				else
					 $$=0;
				}
		char str[5],str1[5]="t";
                sprintf(str, "%d", t);   
                strcat(str1,str);
                t++;
                addquadruple(r,pop(),pop(),str1);                               
                push(str1);
				}
			
	;

rel	:T_LT	{ strcpy(r,"<");}
	|T_GT	{ strcpy(r,">");}
	|T_GTE	{ strcpy(r,">=");}
	|T_LTE	{ strcpy(r,"<=");}
	|T_EQ	{ strcpy(r,"==");}
	|T_NEQ	{ strcpy(r,"!=");}
	;


E	:E T_PL T	{$$ =$1 +$3 ;
			char str[5],str1[5]="t";
                    	sprintf(str, "%d", t);   
                         strcat(str1,str);
                    	t++;
                    	addquadruple("+",pop(),pop(),str1);                               
                    	push(str1);}
	|E T_MI T	{$$ =$1 -$3 ;
			char str[5],str1[5]="t";
                    	sprintf(str, "%d", t);   
                         strcat(str1,str);
                    	t++;
                    	addquadruple("-",pop(),pop(),str1);                               
                    	push(str1);}
	|T		{$$ =$1 ;}
	;
T	:T T_MUL G	{$$ =$1 *$3 ;
			char str[5],str1[5]="t";
                    	sprintf(str, "%d", t);   
                         strcat(str1,str);
                    	t++;
                    	addquadruple("*",pop(),pop(),str1);                               
                    	push(str1);}
	|T T_DIV G	{$$ =$1 /$3 ;
			char str[5],str1[5]="t";
                    	sprintf(str, "%d", t);   
                         strcat(str1,str);
                    	t++;
                    	addquadruple("/",pop(),pop(),str1);                               
                    	push(str1);}
	|G		{$$ =$1 ;}
	;
	

G	:ID	{$$ =symval(var_name,scope);search_and_replace_or_add(line,var_name,$$ ,type,scope); 
		push(var_name);
			}
	|NUM	{$$ =$1 ;
		char sn[10];
		sprintf(sn, "%d", $1); 
		push(sn);}
	|STR	
	;
// temp in symbol table	

%%
int main()
{
yyparse();
return 0;
}











