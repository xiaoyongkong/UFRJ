%{
#include <string>
#include <iostream>
#include <map>
#include <vector>

using namespace std;

struct Atributos {
  vector<string> v;
  int id;
};

#define YYSTYPE Atributos

#define fst first
#define jump "#"
#define get "@"
#define set "="
#define jumpTrue "?"
#define let "&"
#define getProp "[@]"
#define setProp "[=]"
#define callFunc "$"
#define retFunc "~"
#define pop "^"
#define halt "."

void erro( string msg );
void NewInstruc( string fst ); //nova instrução
void NewInstruc( vector<string> &fst );
void NewInstrucF( string fst ); //nova instrução dentro de funcao
void NewInstrucF( vector<string> &fst );
void NewLine();
void showCode();
void getVar(vector<string> v);
void setVar(vector<string> v);

string generateBeginLabel(string pref,int id);
string generateEndingLabel(string pref,int id);

int getId();
int getIdFunc();
int yylex();

void yyerror( const char* );

int retorna( int tk );
int linha = 1;
int coluna = 1;

vector<string> codigo;
vector<string> func_codigo;
map<string,int> var_globais;

%}

%token NUM NEGNUM STR ID LET NEWOBJ NEWARRAY IF ELSE IGUAL MAI_IG MEN_IG

%left '.'
%left '+' '-'
%left '*' '/'

%right '='

%%

START : CMD
;

CMD : LET Decl CMD
  | P CMD
  | IF_LINHA CMD
  | ID '(' PARAM ')' { 
  NewInstruc( $1.v ); 
  NewInstruc(let); 
  NewInstruc( $1.v );
  NewInstruc("{}");
  NewInstruc(set);
  NewInstruc("'&funcao'");
  NewInstruc(generateBeginLabel("FUNC",getIdFunc()));
  NewInstruc(setProp);
  NewInstruc(pop);
  } '{' CMD '}'';' {NewLine();}CMD
  |
;


CMD_LINHA : A';'
  | LET Decl
  | IF_LINHA CMD
;

BLOCO: CMD_LINHA
  | '{' CMD '}'
  |
;

IF_LINHA : IF '('COND')' {$1.id=getId();}
  {NewInstruc(generateBeginLabel("INI_IF",$1.id));NewInstruc(jumpTrue);
  NewLine();
  NewInstruc(generateBeginLabel("ELSE_IF",$1.id));NewInstruc(jump);
  NewLine();
  NewInstruc(generateEndingLabel("INI_IF",$1.id));}
  BLOCO 
  {NewInstruc(generateBeginLabel("FIM_IF",$1.id));NewInstruc(jump);}
  ELSE_LINHA 
  {NewInstruc(generateEndingLabel("ELSE_IF",$1.id));}
  BLOCO{NewInstruc(generateEndingLabel("FIM_IF",$1.id));} 
;

ELSE_LINHA:
  | ELSE
;

Decl : ID { NewInstruc( $1.v ); setVar($1.v); NewInstruc(let); NewLine();} ',' Decl
  | ID { NewInstruc( $1.v ); setVar($1.v); NewInstruc(let); NewLine();} ';' 
  | Adecl ',' Decl
  | Adecl ';'
;

Adecl : ID { NewInstruc( $1.v ); setVar($1.v); NewInstruc(let); NewInstruc( $1.v ); }'=' RVALUE { NewInstruc( set ); NewInstruc( pop ); NewLine(); }
;

P : A ';' P
  | A ';'
;

A : ID { NewInstruc( $1.v ); getVar($1.v);} '=' RVALUE { NewInstruc( set ); NewInstruc( pop ); NewLine(); }
  | LVALUEPROP '=' RVALUE { NewInstruc( setProp ); NewInstruc( pop ); NewLine(); }
  | ID RVALUE { NewInstruc( "print" ); NewInstruc( jump ); NewLine(); }
;

LVALUEPROP : E '.' LVALUEPROPSUFFIX
  | E'['E']''.'{NewInstruc(getProp);}LVALUEPROPSUFFIX
  | E'['E']'
;

LVALUEPROPSUFFIX: ID { NewInstruc( $1.v );}
  | ID { NewInstruc( $1.v );}{NewInstruc(getProp);}'['ELPROP']'
  | ID { NewInstruc( $1.v );}'.'{NewInstruc(getProp);}LVALUEPROPSUFFIX
  | ID { NewInstruc( $1.v );}'.'{NewInstruc(getProp);}LVALUEPROPSUFFIX'['ELPROP']'
;


RVALUE : E
  | NEWOBJ {NewInstruc("{}");}
  | NEWARRAY {NewInstruc("[]");}
  | A { NewInstruc( $1.v ); getVar($1.v); NewInstruc(get);}
  | ID '('PARAM')' {NewInstruc($1.v); NewInstruc(get); NewInstruc(callFunc);}
;

E : E '+' E { NewInstruc( "+" ); }
  | E '-' E { NewInstruc( "-" ); }
  | E '*' E { NewInstruc( "*" ); }
  | E '/' E { NewInstruc( "/" ); }
  | F
;

COND : E '<' E { NewInstruc( "<" ); }
  | E '>' E { NewInstruc( ">" ); }
  | E IGUAL E { NewInstruc( "==" ); }
  | E MAI_IG E { NewInstruc( ">=" ); }
  | E MEN_IG E { NewInstruc( "<=" ); }
;

ELPROP: ELPROP '+' ELPROP { NewInstruc( "+" ); }
  | ELPROP '-' ELPROP { NewInstruc( "-" ); }
  | ELPROP '*' ELPROP { NewInstruc( "*" ); }
  | ELPROP '/' ELPROP { NewInstruc( "/" ); }
  | FLPROP
;

FLPROP: ID { NewInstruc( $1.v ); }
  | NUM { NewInstruc(	$1.v ); }
  | NEGNUM {int sz=$1.v.size()-1; $1.v[sz]=$1.v[sz].substr(1);NewInstruc("0"); NewInstruc($1.v[sz] ); NewInstruc("-");}
  | STR { NewInstruc(	$1.v ); }
  | '(' RVALUE ')'
  | ID '(' PARAM ')' { NewInstruc( $1.v ); NewInstruc(jump) ;}
;

F : ID { NewInstruc( $1.v ); getVar($1.v); NewInstruc(get); }
  | NUM { NewInstruc(	$1.v ); }
  | NEGNUM {int sz=$1.v.size()-1; $1.v[sz]=$1.v[sz].substr(1);NewInstruc("0"); NewInstruc($1.v[sz] ); NewInstruc("-");}
  | STR { NewInstruc(	$1.v ); }
  | '(' RVALUE ')'
  | LVALUEPROP {NewInstruc(getProp);}
;

PARAM : ARGs
  |
;

ARGs : RVALUE ',' ARGs
  | RVALUE
;

%%

#include "lex.yy.c"

map<int,string> nome_tokens = {
  { STR, "string" },
  { ID, "nome de identificador" },
  { NUM, "número" }
};

string nome_token( int token ) {
  if( nome_tokens.find( token ) != nome_tokens.end() )
    return nome_tokens[token];
  else {
  string r;
    r = token;
    return r;
  }
}

int retorna( int tk ) {	
  yylval.v.push_back(yytext); 
  coluna += strlen( yytext ); 
  return tk;
}

void yyerror( const char* msg ) {
  cerr << msg << endl;
  exit( 1 );
}

void NewLine() {
  codigo.push_back("\n");
}

void showCode(vector<string> &codigo) {
  int cont=0;
  for(int i=0;i<codigo.size();i++){
    cout<<codigo[i];
    if(codigo[i]!="\n")
      cout<<' ';
	}
}

void getVar(vector<string> v) {
  string w = v[v.size()-1];
  if(var_globais.count(w)==0) {
    string msg = "Erro: a variável '"+w+"' não foi declarada.";
    yyerror(msg.c_str());
  }

}
void setVar(vector<string> v) {
  string w = v[v.size()-1];
  if(var_globais.count(w)!=0) {
    string msg = "Erro: a variável '"+w+"' já foi declarada na linha "+to_string(var_globais[w])+halt;
    yyerror(msg.c_str());
  }
	else {
    var_globais[w]=linha;
  }
}

vector<string> operator+( vector<string> a, vector<string> b ) {
  a.insert( a.end(), b.begin(), b.end() );
  return a;
}

vector<string> operator+( vector<string> a, string b ) {
  a.push_back(b);
  return a;
}
vector<string> operator+( string a, vector<string> b ) {
  return b+a;
}

void NewInstruc( string fst ) {
  codigo.push_back(fst);
}

void NewInstruc( vector<string> &fst ) {
  NewInstruc(fst[fst.size()-1]);
}

void NewInstrucF( string fst ) {
  func_codigo.push_back(fst);
}

void NewInstrucF( vector<string> &fst ) {
  NewInstruc(fst[fst.size()-1]);
}

int getId() {
  static int id;
  return id++;
}

int getIdFunc() {
  static int id;
  return id++;
}

string generateBeginLabel(string pref,int id) {
  return pref+to_string(id)+":";
}
string generateEndingLabel(string pref, int id) {
  return ":"+pref+to_string(id)+":";
}

vector<string> resolve_enderecos( vector<string> &entrada ) {
  map<string,int> label;
  vector<string> saida;
  int cont=0;

  for( int i = 0; i < entrada.size(); i++ ) 
    if( entrada[i][0] == ':' ) 
        label[entrada[i].substr(1)] = cont;
    else {
      if(entrada[i]!="\n")cont++;
      saida.push_back( entrada[i] );
    }
  for( int i = 0; i < saida.size(); i++ ) 
    if( label.count( saida[i] ) > 0 )
      saida[i] = to_string(label[saida[i]]);
  return saida;
}

int main() {
  yyparse();
  codigo = resolve_enderecos(codigo);
  showCode(codigo);
  cout<<".\n";
  return 0;
}