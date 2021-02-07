D [0-9]
L [A-Za-z_]
INI_COMMENT "/*"
STR_DELIMITER ["]
ID ({L}|[$])([$]|{L}|{D})*
INT {D}+
FLOAT {INT}("."{INT})?([Ee]("+"|"-")?{INT})?

    /* espaço em branco */
WS [ \t\n]

FOR ([Ff][Oo][r])
IF ([Ii][Ff])
STRING ({STR_DELIMITER}(\\.|[^"\\])*{STR_DELIMITER})*
SIMPLE_COMMENT \/\/[^\n\r\t]*
COMPLEX_COMMENT (\/\*)(\*[^\/]|[^\*])*(\*\/) 
COMENTARIO ({SIMPLE_COMMENT}|{COMPLEX_COMMENT})


%%
    /* Padrões e ações. Nesta seção, comentários devem ter um tab antes */

{WS}	{ /* ignora espaços, tabs e '\n' */ }    
{FOR}        { return _FOR; }
{IF}         { return _IF; }
{INT}	     { return _INT; }
{FLOAT}	     { return _FLOAT; }
{ID}	     { return _ID; }
{STRING}     { return _STRING; } 
">="	     { return _MAIG; }
"<="	     { return _MEIG; }
"=="         { return _IG; }
"!="         { return _DIF; }
{COMENTARIO} { return _COMENTARIO; } 
.            { return *yytext; }
.       { return *yytext; 
          /* Essa deve ser a última regra. Dessa forma qualquer caractere isolado será retornado pelo seu código ascii. */ }

%%

/* Não coloque nada aqui - a função main é automaticamente incluída na hora de avaliar e dar a nota. */