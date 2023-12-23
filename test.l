%{
#include "test.tab.h"  // Bison header file
%}

%option noyywrap

digit           [0-9]
letter          [a-zA-Z]
id              {letter}({letter}|{digit})*
num             {digit}+
real            {num}("."{num}+)?([eE][+-]?{num})?

%%

"{"             { return LBRACE; }
"}"             { return RBRACE; }
"["             { return LBRACKET; }
"]"             { return RBRACKET; }
";"             { return SEMICOLON; }
"int"           { return INT; }
"float"         { return FLOAT; }
"while"         { return WHILE; }
"do"            { return DO; }
"if"            { return IF; }
"else"          { return ELSE; }
"break"         { return BREAK; }
"true"          { return TRUE; }
"false"         { return FALSE; }
{id}            { yylval.name = strdup(yytext); return ID; }
{num}           { yylval.number = atoi(yytext); return NUM; }
{real}          { yylval.real = atof(yytext); return REAL; }
"="             { return ASSIGN; }
"<"             { return LESS; }
"<="            { return LEQ; }
">"             { return GREATER; }
">="            { return GEQ; }
"=="            { return EQ; }
"!="            { return NEQ; }
"&&"            { return AND; }
"||"            { return OR; }
"!"             { return NOT; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return TIMES; }
"/"             { return DIVIDE; }
"("             { return LPAREN; }
")"             { return RPAREN; }
[ \t\n]         ; // Skip whitespace

.               { fprintf(stderr, "Unexpected character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}