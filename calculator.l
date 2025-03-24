%{
#include "calculator.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
%}



/*[0-9]+                   { yylval.ival = atoi(yytext); return NUMBER; }*/
/*Number tanımını floating pt kapsayan şekilde değiştirilmiş regex aşşada:*/
%%
[0-9]+(\.[0-9]+)?       { yylval.fval = atof(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]*     { yylval.sval = strdup(yytext); return IDENTIFIER; }
"="                      { return ASSIGN; }
"+"                      { return PLUS; }
"-"                      { return MINUS; }
"*"                      { return TIMES; }
"/"                      { return DIVIDE; }
"("                      {return LPAREN;}
")"                      { return RPAREN;  }
[ \t]+                   {/* Boşlukları yoksay */}
\n                       { return '\n'; }
"^"                     {return EXPONENT;}
"**"                    {return EXPONENT;}
.                        { printf("Bilinmeyen karakter: %s\n", yytext); }
%%
int yywrap(void) {
    return 1;
}
