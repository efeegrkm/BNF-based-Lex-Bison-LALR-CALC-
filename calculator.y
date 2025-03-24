%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

/* Basit sembol tablosu: Değişken isimleri ve değerlerini saklar */
typedef struct {
    char *name;
    int value;
} symbol;

#define TABLE_SIZE 100
symbol symtab[TABLE_SIZE];
int sym_count = 0;

/* Belirtilen isimdeki değişkenin değerini döndürür (bulunamazsa 0 döner) */
int lookup_symbol(char *name) {
    for (int i = 0; i < sym_count; i++) {
        if (strcmp(symtab[i].name, name) == 0)
            return symtab[i].value;
    }
    return 0;
}

/* Değişkeni günceller ya da yeni ekler */
void update_symbol(char *name, int value) {
    for (int i = 0; i < sym_count; i++) {
        if (strcmp(symtab[i].name, name) == 0) {
            symtab[i].value = value;
            return;
        }
    }
    symtab[sym_count].name = strdup(name);
    symtab[sym_count].value = value;
    sym_count++;
}

/* Yylex fonksiyonu Lex tarafından sağlanır */
int yylex(void);
void yyerror(const char *s);
%}

%union {
    float fval; /*floating value bonus için*/
    int ival;
    char *sval;
}
/* İşlem önceliklerini belirlediğim alan (left to right assoc olarank)*/
%left PLUS MINUS
%left TIMES DIVIDE
%left EXPONENT

/* Token identification alanı*/
%token <fval> NUMBER /*bonus için burası da fvale çevirdim*/
%token <sval> IDENTIFIER
%token ASSIGN
%token PLUS MINUS TIMES DIVIDE EXPONENT
%token LPAREN RPAREN


/* Non-terminal'ların tiplerini tanımlamaları burada ama sadece 1 tane */
%type <fval> expr statement line
%%

/* input alıp output verme işlemleri burada  */
input:
      /* boş */
    | input line
    ;
line: 
      '\n' { $$ = 0; }
    | statement '\n' {
          printf("Sonuc = %f\n", $1); /*SOnucu float yazdırmak için burasını da dden fe geçirdim*/
          $$ = $1;
      }
    ;

/* İfade atama işlemleri alanı */
statement:
      expr                    { $$ = $1; }
    | IDENTIFIER ASSIGN expr  { update_symbol($1, $3); $$ = $3; free($1); }
    ;

/* Calculation alanı */
expr:
      expr PLUS expr   { $$ = $1 + $3; }
    | expr MINUS expr  { $$ = $1 - $3; }
    | expr TIMES expr  { $$ = $1 * $3; }
    | expr DIVIDE expr {
                           if ($3 == 0) {
                               yyerror("Divided by zero exception. Cevap: INF");
                               $$ = 0;
                           } else {
                               $$ = $1 / $3;
                           }
                         }
    | expr EXPONENT expr{$$ = pow($1,$3);}
    | MINUS expr %prec EXPONENT { $$ = -$2; }  /* Negatif sayı desteği grammar eki */
    | LPAREN expr RPAREN { $$ = $2; }
    | NUMBER           { $$ = $1; }
    | IDENTIFIER       { $$ = lookup_symbol($1); free($1); }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Hata: %s\n", s);
}

int main(void) {
    printf("BNF Calculator: Type in your arithmatic expression\n");
    return yyparse();
}
