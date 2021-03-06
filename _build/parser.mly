
/* Analyseur syntaxique pour Mini-C++ */

%{
  open Ast
 (* open Lexer*)
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
%start <Ast.fichier>fichier

/* Type des valeurs retourn�es par l'analyseur syntaxique */

%%

fichier:
| x = position(dfichier) { x }
;

dfichier:
| y=boption(INCLUDEIOS)  ; x = decl * ; EOF { {bincludeios = y ; decls =  x} }
;

position(X):
| x = X { {v = x ; loc=($startpos, $endpos) }} 


decl:
| x = position(ddecl) { x }

ddecl:
| x = decl_vars { Dv (x) }
| x = decl_class { Dc (x) }
| x = proto ; y = bloc { Db (x,y)}
;

decl_vars:
| x = position(ddecl_vars) { x }
;

ddecl_vars:
| x = typ; y = separated_nonempty_list(COMMA, var) ; SEMICOLON { Declv (x,y) }
;



/* On veut pouvoir d�clarer des attributs du type de la classe, il faut donc enregistrer que la classe est un nouveau type. */

debut_decl_class:
| CLASS ; z = IDENT; { Hashtbl.add (Lexerhack.table) z () ; z }

decl_class:
| x = position(ddecl_class) {x}

ddecl_class:
| z = debut_decl_class ; l = optsupers  ; LACC ; PUBLIC; COLON; y = member * ; RACC ; SEMICOLON 
{  Class (z,l,y) }  
;

optsupers:
| x = option(supers) { match x with | None -> { v = (Super []) ; loc=($startpos,$endpos) }
				    | Some a -> a  
		     }
;

supers:
| x = position(dsupers) { x }
;

dsupers:
|COLON; PUBLIC; z = separated_nonempty_list(COMMA, TIDENT) { Super z } 
;



member:
| x = position(dmember) { x }
;

dmember:
| x = decl_vars { Mvar (x) }
| VIRTUAL; x = proto ; SEMICOLON { Mvir (true,x) }
| x = proto ; SEMICOLON { Mvir (false,x) }

;


proto:
| x = position(dproto) { x }

dproto: x = typ ; y = qvar ; LPAR ; z = separated_list(COMMA, argument) ; RPAR 
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

argument:
| x = position(dargument) { x }
;

dargument:
| x = typ ; y = var { Arg (x,y) } 
;


var:
| x = position(dvar) { x }
;


dvar:
| x = IDENT { Ident x}
| TIMES ; x = var { Po x }
| LAND ; x = var { Ad x }
; 

qvar:
| x = position(dqvar) { x }
;

dqvar:
| x = qident { Qvar x }
| TIMES ; x = qvar { Qpo x }
| LAND ; x = qvar { Qad x  }
; 

qident:
| x = position(dqident) { x }
;

dqident:
| x = IDENT { Qident x }
| x = TIDENT ; COLON ; COLON ; y = IDENT { Double (x,y) }
;


expr:
| x = dexpr { { dexpr = x ; loc = $startpos, $endpos } }

dexpr:
| x = expr; y = operateur; z = expr {  Eop (y,x,z) }
| LAND; x = expr { Eland x }
| NOT; x = expr { Enot x }
| MINUS; x = expr %prec UNAIRE { Euminus( x) }
| PLUS; x = expr %prec UNAIRE {Euplus( x) }
| TIMES; x = expr %prec UNAIRE { Epointeur (x) }
| INCR; x = expr { Elincr x }
| DECR; x = expr { Eldecr x }
| x = expr; DOT; y = IDENT { Eattr (x,y) }
| x = expr; SDEREF; y = IDENT { Esderef (x,y) }
| x = expr; ASSIGN; y = expr { Eassign (x,y) }
| x = expr; LPAR; y = separated_list(COMMA, expr) ; RPAR { Efcall (x,y) }
| x = expr; INCR { Erincr x }
| x = expr; DECR { Erdecr x }
| x = INTEGER { Eint x }
| THIS { Ethis } 
| FALSE { Ebool false}
| TRUE { Ebool true }
| NULL { Enull }
| x = qident { Eqident x }
| LPAR; x = expr; RPAR { Epar x }
| NEW; x = TIDENT; LPAR; y = separated_list(COMMA, expr) ; RPAR { Enew (x,y) }
;


%inline operateur:
| EQ {Eq}| NEQ {Neq}| LT {Lt} | LE {Le} | GT {Gt} | GE {Ge} 
| PLUS {Add} | MINUS {Sub} | TIMES {Mul} | DIV {Div} | MODULO {Mod} 
| AND {And} | OR {Or}
;


vinst: CHEVRON ; e = expr_str { e }
;

dinst:
| SEMICOLON { Nothing }
| e = expr ; SEMICOLON { Iexpr e }
| t = typ; v = var ; SEMICOLON { Idecls (t,v) }
| t = typ; v = var ; ASSIGN; e = expr SEMICOLON { Idecl (t,v,e) }
| t = typ; v = var ; ASSIGN; s = TIDENT ; LPAR; e = separated_list(COMMA, expr) ; RPAR ; SEMICOLON
{Aidecl (t,v,s,e) }
| IF ; LPAR ; e = expr ; RPAR ; i = inst %prec IFX { If (e,i) }
| IF ; LPAR ; e = expr ; RPAR ; i = inst ; ELSE ; y = inst 
{Ifelse (e,i,y) }
| WHILE ; LPAR ; e = expr ; RPAR ; i = inst  { While (e,i) }
| FOR LPAR ; e = separated_list (COMMA , expr); SEMICOLON;  x = expr  ; SEMICOLON;
 f = separated_list (COMMA , expr) ; RPAR ; i = inst { For (e,x,f,i) }
| FOR LPAR ; e = separated_list (COMMA , expr); SEMICOLON; SEMICOLON;
f = separated_list (COMMA , expr)  ; RPAR ; i = inst { Afor (e,f,i) }
| b = bloc { Ibloc b }
| STDCOUT ; l = nonempty_list (vinst); SEMICOLON { Cout l }
| RETURN ; e = expr  ; SEMICOLON  { Return e }
| RETURN ; SEMICOLON { Areturn }
;


inst:
| x = position(dinst) { x } 
;


expr_str:
| x = position(dexpr_str) { x }
;
dexpr_str:
| x = expr { Esexpr x }
| x = CHAINE { Estring x}
;


bloc:
| x = position(dbloc) { x }
;

dbloc:
  LACC; x = inst * ; RACC { Bloc x }
;


