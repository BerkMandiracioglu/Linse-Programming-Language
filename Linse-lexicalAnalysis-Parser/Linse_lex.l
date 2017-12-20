

%{
#include <stdio.h>
#include <stdlib.h>


int lineNo = 1;
void incrementLine();

%}

%x S2 S3 S4
letter     [A-Za-z_] 
digit          [0-9] 
alphanumeric   ({letter}|{digit}) 
variable {letter}{alphanumeric}*
constant \".*\"
implication \-\>|\<\- 
predicate_keyword   predicate
predicate {variable}
%% 
"//" BEGIN(S2);
"/*" BEGIN(S3);
<S2>(\n) {BEGIN(INITIAL); incrementLine();}
<S2>. ;
<S3>"*" BEGIN(S4);
<S3>[^*\n] ;
<S3>(\n) incrementLine();
<S4>[^*/\n] BEGIN(S3);
<S4>(\n) incrementLine();
<S4>"/" {BEGIN(INITIAL); }
= {return (ASSIGN);}
true {return (TRUE_VAL);}
false {return (FALSE_VAL);}
{implication} {return (IMPL);}
! { return (NEG);}
: {return (COLON);}
\+ {return (OR);}
\* {return (AND);}
if {return (IF);}
main return (MAIN);
"[" { return (LS);}
"]" {return (RS);}
{digit}+ { return (INT);}
else {return (ELSE);}
\( {return (LP);}
== {return (EQ);}
\) {return (RP);}
\{ {return (LBRA);}
\} {return (RBRA);}
IN[ \t]*\>\>  {return (IN);}
OUT[ \t]*<<  {return (OUT);}
while {return (WHILE);}
{predicate_keyword} {return (PRED);}
return {return (RETURN);}
\, {return (COMMA);}
{constant} {return (CONST);}
variable {return (IDE);}
{predicate} {return (IDE);}
. ;
(\n) incrementLine();
%%

void incrementLine(){
	lineNo++;
}
int yywrap(){ return 1;}