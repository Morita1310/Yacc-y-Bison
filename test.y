%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
void yyerror(const char *s);

%}

%union {
    int num;
    char *str;
}

%token <num> NUM
%token <str> ID
%token TYPE WHILE DO IF ELSE TRUE
%token BREAK

%left '+' '-'
%left '*' '/'

%%

program: declarations WHILE '(' TRUE ')' '{' statements '}'
    ;

declarations: declarations declaration
    | /* empty */
    ;

declaration: TYPE ID ';'    { printf("Declaración válida de variable\n"); }
    | TYPE ID '[' NUM ']' ';'    { printf("Declaración válida de array\n"); }
    | TYPE ID    { yyerror("Error: falta punto y coma al final de la declaración de variable"); }
    | TYPE ID '[' NUM ']'    { yyerror("Error: falta punto y coma al final de la declaración de array"); }
    ;

statements: statements statement
    | /* empty */
    ;

statement: '{' statements '}'
    | WHILE '(' TRUE ')' '{' statements '}'
    | DO statement WHILE '(' expr ')' ';'   { printf("Bucle do-while válido\n"); }
    | DO statement WHILE '(' expr ')'   { yyerror("Error: falta punto y coma al final del bucle do-while"); }
    | IF '(' expr ')' '{' statements '}' ELSE '{' statements '}'
    | IF '(' expr ')' '{' statements '}'
    | ID '=' expr ';'
    | BREAK ';'    { printf("Sentencia break válida\n"); }
    | BREAK    { yyerror("Error: falta punto y coma al final de la sentencia break"); }
    ;

expr: expr '+' expr
    | expr '-' expr
    | expr '*' expr
    | expr '/' expr
    | ID
    | NUM
    | ID '[' expr ']'
    | '(' expr ')'
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s <nombre_del_archivo>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror(argv[1]);
        return 1;
    }

    yyparse();

    fclose(yyin);
    return 0;
}