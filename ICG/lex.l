%{
#include<stdio.h>
#include<string.h>
int line=0;
void yyerror(char *s);
#include "y.tab.h"
extern int yylval;
char var_name[100];
int scope=0;
int s=0;
char type[100];

%}


digit	[0-9]
letter	[a-zA-Z]
id      ({letter}|\$|\_)({letter}|{digit}|\$|\_)*
digits	{digit}+
opFraction	(\.{digits})?
opExponent	([Ee][+-]?{digits})?
number	{digits}{opFraction}{opExponent}
string	\"({letter}|{digit})+\"
start	\/\*
end	\*\/
%option noyywrap
%%

[\n]	{line++;}

var	{return VAR;}
let return LET;
const	return CONST;
for	return FOR;
do	return DO;
while	return WHILE;
document.write return DOC;
console.log return CON;
{id}	{strcpy(var_name,yytext);return ID;}
{number}	{yylval = atoi(yytext);strcpy(type,"integer");return NUM;}
{string}	{strcpy(type,"string");return STR;}
":"	return T_COL;
";"	return T_SEMICOL;
">"	return T_GT;
"<"	return T_LT;
">="	return T_GTE;
"<="	return T_LTE;
"=="	return T_EQ;
"!="	return T_NEQ;
"+"	return T_PL;
"++"	return T_I;
"--"	return T_D;
"-"	return T_MI;
"*"	return T_MUL;
"/"	return T_DIV;
"["	return T_OSB;
"]"	return T_CSB;
"="	return T_EQUAL;
"("	return T_OP;
")"	return T_CP;
"{" {if(scope==0)
	{
		scope=scope+s+1;
		s=scope;
	}
	else{
		scope++;
		s++;
	}
	return T_OFB;}
"}" {scope--;return T_CFB;}
"," return T_C;
\/\/(.*)\n ;
{start}(.*\n)*{end} ;
[ /t]	{}
.	return yytext[0];
%%

void yyerror(char *s){printf("\nError in line %d, %s\n",line,s);return;}
