
/* Analyseur syntaxique pour Arith */

%{
  open Ast
  open Lexer
  (*open Lexerhack*)
%}

%token <int> INTEGER
%token <string> IDENT
%token <string> TIDENT
%token <string> CHAINE
%token VOID TRUE FALSE NULL INT
%token INCLUDEIOS EOF PUBLIC THIS CLASS VIRTUAL NEW
%token COMMA SDEREF DOT IF  ELSE RETURN
%token CHEVRON
%token NOT INCR DECR LAND 
%token LACC RACC
%token LPAR RPAR COLON SEMICOLON WHILE FOR
%token TIMES DIV MODULO
%token PLUS MINUS
%token LT LE GT GE
%token EQ NEQ
%token AND
%token OR
%token ASSIGN
%token STDCOUT


/* D�finitions des priorit�s et associativit�s des tokens */


%right ASSIGN 
%left OR
%left AND
%left EQ NEQ
%left LT LE GT GE
%left PLUS MINUS
%left TIMES DIV MODULO
%right NOT INCR DECR LAND UNAIRE
%left  SDEREF DOT LPAR


%nonassoc IFX
%nonassoc ELSE

/* Point d'entr�e de la grammaire */
%start <Ast.file>fichier

/* Type des valeurs retourn�es par l'analyseur syntaxique */

%%

fichier:
| INCLUDEIOS  ; x = decl * ; EOF { {bincludeios = true ; declarations =  x} }
| x = decl * ; EOF { {bincludeios = false ; declarations =  x }}

;

decl:
| x = decl_vars { Dv (x) }
| x = decl_class { Dc (x) }
| x = proto ; y = bloc { Db (x,y)}
;

decl_vars:
| x = typ; y = separated_nonempty_list(COMMA, var) ; SEMICOLON { Declv (x,y) }
;



/* On veut pouvoir d�clarer des attributs du type de la classe, il faut donc enregistrer que la classe est un nouveau type. */

debut_decl_class:
| CLASS ; z = IDENT; { Hashtbl.add (Lexer.table) z () ; z }

decl_class:
| z = debut_decl_class ; x = boption(supers)  ; LACC ; PUBLIC; COLON; y = member * ; RACC ; SEMICOLON 
{  Class (x,z,y) }
;

supers:
|COLON; PUBLIC; z = separated_nonempty_list(COMMA, TIDENT) { Super z }
;


member:
| x = decl_vars { Mvar (x) }
| VIRTUAL; x = proto ; SEMICOLON { Mvir (true,x) }
| x = proto ; SEMICOLON { Mvir (false,x) }

;


proto: x = typ ; y = qvar ; LPAR ; z = separated_list(COMMA, argument) ; RPAR 
 { Plong ( x, y, z) }
 | x = TIDENT ;  LPAR ; z = separated_list(COMMA, argument) ; RPAR 
 { Pshort (x , z)}
 | x = TIDENT  ; COLON ; COLON  ; y = TIDENT ; LPAR ; z = separated_list(COMMA, argument) ; RPAR 
   { Pdouble ( x, y, z) } 
;

typ:
| VOID { Void }
| INT { Int }
| s = TIDENT  { Tid s }
;

argument: x = typ ; y = var { Arg (x,y) } 
;

var:
| x = IDENT { Ident x}
| TIMES ; x = var { Po x }
| LAND ; x = var { Ad x }
; 

qvar:
| x = qident { Qvar x }
| TIMES ; x = qvar { Qpo x }
| LAND ; x = qvar { Qad x  }
; 


qident:
| x = IDENT { Qident x }
| x = TIDENT ; COLON ; COLON ; y = IDENT { Double (x,y) }
;

expr:
| x = expr; y = operateur; z = expr { Op (y,x,z)}
| LAND; x = expr { Land x }
| NOT; x = expr { Not x }
| MINUS; x = expr %prec UNAIRE { Op(Sub, Eint 0, x) }
| PLUS; x = expr %prec UNAIRE { x }
| TIMES; x = expr %prec UNAIRE { Pointeur (x) }
| INCR; x = expr { Lincr x }
| DECR; x = expr { Ldecr x }
| x = expr; DOT; y = IDENT { Attr (x,y) }
| x = expr; SDEREF; y = IDENT { Sderef (x,y) }
| x = expr; ASSIGN; y = expr { Assign (x,y) }
| x = expr; LPAR; y = separated_list(COMMA, expr) ; RPAR { Fcall (x,y) }
| x = expr; INCR { Rincr x }
| x = expr; DECR { Rdecr x }
| x = INTEGER { Eint x }
| THIS { This } 
| FALSE { Ebool false}
| TRUE { Ebool true }
| NULL { Null }
| x = qident { Eqident x }
| LPAR; x = expr; RPAR { Par x }
| NEW; x = TIDENT; LPAR; y = separated_list(COMMA, expr) ; RPAR { New (x,y) }
;

%inline operateur:
| EQ {Eq}| NEQ {Neq}| LT {Lt} | LE {Le} | GT {Gt} | GE {Ge} 
| PLUS {Add} | MINUS {Sub} | TIMES {Mul} | DIV {Div} | MODULO {Mod} 
| AND {And} | OR {Or}
;


vinstruction: CHEVRON ; e = expr_str { e }
;

instruction:
| SEMICOLON { Nothing }
| e = expr ; SEMICOLON { Iexpr e }
| t = typ; v = var ; SEMICOLON { Idecls (t,v) }
| t = typ; v = var ; ASSIGN; e = expr SEMICOLON { Idecl (t,v,e) }
| t = typ; v = var ; ASSIGN; s = TIDENT ; LPAR; e = separated_list(COMMA, expr) ; RPAR ; SEMICOLON
{Aidecl (t,v,s,e) }
| IF ; LPAR ; e = expr ; RPAR ; i = instruction %prec IFX { If (e,i) }
| IF ; LPAR ; e = expr ; RPAR ; i = instruction ; ELSE ; y = instruction 
{Ifelse (e,i,y) }
| WHILE ; LPAR ; e = expr ; RPAR ; i = instruction  { While (e,i) }
| FOR LPAR ; e = separated_list (COMMA , expr); SEMICOLON;  x = expr  ; SEMICOLON;
 f = separated_list (COMMA , expr) ; RPAR ; i = instruction { For (e,x,f,i) }
| FOR LPAR ; e = separated_list (COMMA , expr); SEMICOLON; SEMICOLON;
f = separated_list (COMMA , expr)  ; RPAR ; i = instruction { Afor (e,f,i) }
| b = bloc { Ibloc b }
| STDCOUT ; l = nonempty_list (vinstruction); SEMICOLON { Cout l }
| RETURN ; e = expr  ; SEMICOLON  { Return e }
| RETURN ; SEMICOLON { Areturn }
;

expr_str:
| x = expr { Esexpr x }
| x = CHAINE { Estring x}
;

bloc:
  LACC; x = instruction * ; RACC { Bloc x }
;

