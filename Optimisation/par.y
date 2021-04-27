%{

		#include <stdio.h>
		#include <stdlib.h>
		#include <string.h>
		#define YYERROR_VERBOSE	
	 	int yylex(void);
	    extern char *yytext;
		void check_value(char **, char **, char **);
		struct SYMTAB * find_node(char *);
		void add_node(char *, char *, int);
		char * constant_fold();
		struct SYMTAB {
			   struct SYMTAB *next;
			   struct SYMTAB *prev;
			   char *name;
			   char *val;
			   int type;
		};

%}

%union{
	struct {char *value;} rvalues;
}

%token <rvalues> T_ASSIGN T_BOOLOP T_LOGOP T_MATHOP T_DELIM T_END
%token <rvalues> T_MOV T_LABEL T_FALSE T_TRUE T_TVAR
%token <rvalues> T_GOTO T_LVAR T_TVALVEC
%token <rvalues> T_NUM T_STR T_VAR
%type <rvalues> operator tvar_tnum value_constants no_num
%start start


%%

start: prog

prog: block Y;

Y:  prog
	|
	;

block:	S X
		;

X: T_DELIM
   |
   ;

S: T_TVAR T_ASSIGN value_prod
		   | T_VAR T_ASSIGN T_VAR {add_node($1.value,$3.value,2);}
		   | T_VAR T_ASSIGN value_constants {check_value(&$1.value, &$2.value, &$3.value);printf("%s %s %s\n", $1.value, $2.value, $3.value);}
		   | T_VAR T_ASSIGN value_constants operator T_VAR {check_value(&$3.value, &$4.value, &$5.value);printf("%s %s %s %s %s\n",$1.value, $2.value, $3.value, $4.value, $5.value);}
		   | T_TVAR T_ASSIGN T_NUM operator no_num {check_value(&$1.value, &$3.value, &$5.value); printf("%s %s %s %s %s\n", $1.value, $2.value, $3.value, $4.value, $5.value);}
		   | T_TVAR T_ASSIGN no_num operator T_NUM {check_value(&$1.value, &$3.value, &$5.value); printf("%s %s %s %s %s\n", $1.value, $2.value, $3.value, $4.value, $5.value);}
		   | T_TVAR T_ASSIGN T_NUM operator T_NUM {printf("%s = %s\n", $1.value, constant_fold($3.value, $4.value, $5.value));}
		   | T_TVAR T_ASSIGN no_num operator no_num {check_value(&$1.value, &$3.value, &$5.value); printf("%s %s %s %s %s\n", $1.value, $2.value, $3.value, $4.value, $5.value);}
		   | T_FALSE value_constants T_GOTO T_LVAR {check_value(&$1.value, &$2.value, &$3.value);printf("%s %s %s %s\n", $1.value, $2.value, $3.value, $4.value);}
		   | T_TRUE value_constants T_GOTO T_LVAR {check_value(&$1.value, &$2.value, &$3.value);printf("%s %s %s %s\n", $1.value, $2.value, $3.value, $4.value);}
		   | T_GOTO T_LVAR  {printf("%s %s\n", $1.value, $2.value);}
		   | T_LABEL T_LVAR {printf("%s %s\n", $1.value, $2.value);}
		   | T_TVALVEC T_ASSIGN T_TVAR {check_value(&$1.value, &$2.value, &$3.value);printf("%s %s %s\n", $1.value, $2.value, $3.value);}
		   | T_TVAR '[' tvar_tnum ']' T_ASSIGN tvar_tnum {check_value(&$1.value, &$3.value, &$6.value);printf("%s[%s] %s %s\n", $1.value, $3.value, $5.value, $6.value);}
		   | T_TVAR T_ASSIGN value_constants '[' value_constants ']' {check_value(&$1.value, &$3.value, &$5.value);printf("%s %s %s[%s]\n", $1.value, $2.value, $3.value, $5.value);}	   



no_num: T_VAR {$$.value = $1.value;}
		| T_TVAR {$$.value = $1.value;}

tvar_tnum: T_NUM {$$.value = $1.value;}
		   | T_TVAR {$$.value = $1.value;}


value_constants: T_NUM {$$.value = $1.value;}
				 | T_STR {$$.value = $1.value;}
				 | T_TVAR {$$.value = $1.value;}

value_prod: T_NUM {add_node($<rvalues>-1.value, $1.value, 0);}
	   | T_STR {add_node($<rvalues>-1.value, $1.value, 1);}
       | T_VAR {add_node($<rvalues>-1.value, $1.value, 2);}

operator: T_BOOLOP {$$.value = $1.value;}
		  | T_LOGOP {$$.value = $1.value;}
		  | T_MATHOP {$$.value = $1.value;}

%%

struct SYMTAB *head, *end;

void yyerror(char *a){printf("\n %s\n", a);return;}


char* constant_fold(char *operand1, char *operator, char *operand2)
{
	int op1 = atoi(operand1), op2 = atoi(operand2);
	int result;
	char *returnval = (char*)malloc(sizeof(char)*32);

	if(strcmp(operator, "&&") == 0){
		result = op1 && op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}
	
	if(strcmp(operator, "||") == 0){
		result = op1 || op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "<") == 0){
		result = op1 < op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, ">") == 0){
		result = op1 > op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "<=") == 0){
		result = op1 <= op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, ">=") == 0){
		result = op1 >= op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "==") == 0){
		result = op1 == op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "+") == 0){
		result = op1 + op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "-") == 0){
		result = op1 - op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "/") == 0){
		result = op1 / op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "*") == 0){
		result = op1 * op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	else
		return "NaN";

}

void check_value(char **param1, char **param2, char **param3)
{

	if(*param1 != NULL){
			struct SYMTAB *temp = find_node(*param1);
			if(temp != NULL){
					*param1 = temp->val;
			}
		}
	if(*param2 != NULL){
	     struct SYMTAB *temp = find_node(*param2);
		 if(temp != NULL){
				*param2 = temp->val;
		 }
	}

	if(*param3 != NULL){
	     struct SYMTAB *temp = find_node(*param3);
		 if(temp != NULL){
				*param3 = temp->val;
		 }
	}

}

struct SYMTAB * find_node(char *name)
{
	if(head == NULL)
		return NULL;

	struct SYMTAB *temp = head;
	while(temp != NULL){
		 if(strcmp(temp->name, name) == 0)
		 	 return temp;
		 temp = temp->next;
	}
	return NULL;
}

void add_node(char *name, char *value, int type)
{
	struct SYMTAB *temp = (struct SYMTAB*)malloc(sizeof(struct SYMTAB));
	temp->prev = end;
	temp->next = NULL;
	temp->name = strdup(name);
	temp->val = strdup(value);
	temp->type = type;
	if(head == NULL)
			head = temp;
	if(end != NULL)
		   end->next = temp;   
	end = temp;
}

int main(void)
{

	head = end = NULL;
	yyparse();
	return 0;
}
