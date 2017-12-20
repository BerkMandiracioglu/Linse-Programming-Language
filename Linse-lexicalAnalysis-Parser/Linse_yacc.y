/* print-int.y */ 
%{
#include <stdio.h>
#include <string.h>
int yylex();
int yyerror(char *s);
extern FILE *yyin;
extern int lineNo;
%}


%token CONST ASSIGN TRUE_VAL FALSE_VAL IMPL NEG COLON OR AND IF ELSE LP EQ RP LBRA RBRA IN OUT WHILE PRED IDE RETURN COMMA LS RS INT MAIN
%%
program:  MAIN LBRA stmt_declrs RBRA {printf("this is a valid Linse program :)\n");}
;

stmt_declrs : stmt_declr| stmt_declrs stmt_declr ;
stmt_declr : stmt | predicate_declr ;



stmt_list: stmt 
| stmt_list stmt 
; 

stmt : if | input_stmt | assign_stmt | output_stmt | return_stmt | while_stmt | type_declr | arr_declr  ;




if
  : IF LP expr RP LBRA stmt_list RBRA
  | IF LP expr RP LBRA stmt_list RBRA ELSE LBRA stmt_list RBRA
;


assign_stmt : type ASSIGN expr COLON | IDE LS INT RS ASSIGN expr COLON ;
expr : term | expr IMPL term ;
term : factor | term EQ factor;
factor : fact | factor OR fact ;
fact : reality | fact AND reality ;
reality : id | NEG reality ;
id : LP expr RP | type | predicate_call | truth_values  | IDE LS INT RS;
type: IDE | CONST ;
type_list : type | type_list COMMA type ;
truth_values: TRUE_VAL | FALSE_VAL ;
predicate_call : IDE LP parameter_list RP ;
parameter_list : expr | parameter_list COMMA expr ;

while_stmt : WHILE LP expr RP LBRA stmt_list RBRA ;
input_stmt : IN expr COLON;
output_stmt : OUT expr COLON ;
return_stmt : RETURN expr COLON ;

type_declr : type COLON ;
predicate_declr : PRED IDE LP type_list RP LBRA stmt_list RBRA ;
arr_declr : IDE LS parameter_list RS  COLON| IDE LS INT RS COLON ;






%%
#include "lex.yy.c"
int yyerror(char *s) { fprintf(stderr,"%s on line: %d\n",s, lineNo); exit(1);} 
int main() {

return yyparse(); 
printf("valid program");
}
