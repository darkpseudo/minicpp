# 4 "lexer.mll"
 
  open Lexing
  open Parser
  (*open Lexerhack*)
   
  exception Lexing_error of string

  (* tables des mots-cl�s *)
  let kwd_tbl = 
    ["class", CLASS; "else", ELSE; "false", FALSE;
     "if", IF; "for", FOR; "int", INT; "new", NEW;
     "NULL", NULL; "public", PUBLIC;
     "return", RETURN; "this", THIS; "true", TRUE;  "virtual", VIRTUAL; "void", VOID; "while", WHILE
    ]

  let table = Hashtbl.create 17 ;; (* la table du lexer hack *)

  Hashtbl.add table "void" () ;;

  Hashtbl.add table "int" () ;;

  let id_or_kwd = 
    let h = Hashtbl.create 17 in
    List.iter (fun (s,t) -> Hashtbl.add h s t) kwd_tbl;
    fun s -> 
      try List.assoc s kwd_tbl with _ -> if Hashtbl.mem table s then TIDENT s else IDENT s

  let newline lexbuf =
    let pos = lexbuf.lex_curr_p in
    lexbuf.lex_curr_p <- 
      { pos with pos_lnum = pos.pos_lnum + 1; pos_bol = pos.pos_cnum }


# 36 "lexer.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base = 
   "\000\000\216\255\217\255\078\000\088\000\221\255\222\255\223\255\
    \224\255\225\255\020\000\002\000\003\000\237\255\049\000\239\255\
    \001\000\049\000\032\000\244\255\100\000\086\000\247\255\248\255\
    \249\255\043\000\115\000\192\000\004\000\255\255\011\001\086\001\
    \036\000\050\000\039\000\034\000\036\000\250\255\043\000\055\000\
    \047\000\039\000\057\000\057\000\146\000\099\000\055\000\050\000\
    \058\000\058\000\061\000\075\000\080\000\070\000\145\000\252\255\
    \104\000\100\000\123\000\123\000\136\000\150\000\155\000\144\000\
    \192\000\251\255\233\255\246\255\241\255\245\255\229\255\242\255\
    \228\255\219\255\220\255\231\255\230\255\227\255\161\001\184\001\
    \199\001\241\000\253\255\254\255\208\000\255\255\018\001\253\255\
    \254\255\255\255\014\002\246\255\247\255\248\255\249\255\108\002\
    \095\002\252\255\253\255\254\255\255\255\181\002\251\255";
  Lexing.lex_backtrk = 
   "\255\255\255\255\255\255\037\000\037\000\255\255\255\255\255\255\
    \255\255\255\255\039\000\029\000\023\000\255\255\017\000\255\255\
    \015\000\019\000\012\000\255\255\020\000\021\000\255\255\255\255\
    \255\255\039\000\002\000\002\000\001\000\255\255\002\000\002\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\037\000\
    \037\000\255\255\255\255\255\255\001\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\005\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255";
  Lexing.lex_default = 
   "\001\000\000\000\000\000\255\255\255\255\000\000\000\000\000\000\
    \000\000\000\000\255\255\255\255\255\255\000\000\255\255\000\000\
    \255\255\255\255\255\255\000\000\255\255\255\255\000\000\000\000\
    \000\000\255\255\255\255\255\255\255\255\000\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\000\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\000\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\255\255\255\255\
    \255\255\083\000\000\000\000\000\255\255\000\000\088\000\000\000\
    \000\000\000\000\091\000\000\000\000\000\000\000\000\000\255\255\
    \255\255\000\000\000\000\000\000\000\000\255\255\000\000";
  Lexing.lex_trans = 
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\028\000\029\000\000\000\000\000\028\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \028\000\018\000\024\000\025\000\028\000\013\000\016\000\072\000\
    \009\000\008\000\015\000\017\000\007\000\020\000\019\000\014\000\
    \004\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \003\000\003\000\006\000\005\000\021\000\011\000\012\000\076\000\
    \075\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\074\000\071\000\070\000\033\000\026\000\
    \073\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\027\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\023\000\010\000\022\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \079\000\079\000\079\000\079\000\079\000\079\000\079\000\079\000\
    \077\000\068\000\067\000\066\000\038\000\034\000\035\000\036\000\
    \037\000\039\000\040\000\041\000\042\000\043\000\044\000\056\000\
    \047\000\048\000\069\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\049\000\050\000\051\000\
    \052\000\053\000\045\000\054\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\046\000\055\000\
    \078\000\057\000\026\000\058\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\059\000\060\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\061\000\062\000\063\000\064\000\065\000\085\000\
    \002\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\084\000\089\000\000\000\000\000\026\000\
    \000\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\030\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\000\000\000\000\
    \000\000\000\000\026\000\000\000\026\000\026\000\026\000\031\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \032\000\000\000\000\000\000\000\000\000\000\000\000\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\000\000\000\000\000\000\000\000\026\000\000\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\080\000\080\000\080\000\080\000\080\000\080\000\080\000\
    \080\000\080\000\080\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\080\000\080\000\080\000\080\000\080\000\080\000\
    \079\000\079\000\079\000\079\000\079\000\079\000\079\000\079\000\
    \000\000\082\000\000\000\000\000\000\000\000\000\000\000\080\000\
    \080\000\080\000\080\000\080\000\080\000\080\000\080\000\080\000\
    \080\000\000\000\080\000\080\000\080\000\080\000\080\000\080\000\
    \080\000\080\000\080\000\080\000\080\000\080\000\000\000\000\000\
    \000\000\000\000\087\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \080\000\080\000\080\000\080\000\080\000\080\000\093\000\093\000\
    \094\000\093\000\093\000\093\000\093\000\093\000\093\000\093\000\
    \093\000\093\000\093\000\093\000\093\000\093\000\093\000\093\000\
    \093\000\093\000\093\000\093\000\093\000\093\000\093\000\093\000\
    \093\000\093\000\093\000\093\000\093\000\093\000\093\000\093\000\
    \093\000\093\000\093\000\093\000\093\000\093\000\093\000\093\000\
    \093\000\093\000\093\000\093\000\093\000\093\000\093\000\093\000\
    \093\000\093\000\093\000\093\000\093\000\093\000\093\000\093\000\
    \093\000\093\000\095\000\093\000\093\000\093\000\093\000\093\000\
    \093\000\093\000\093\000\093\000\093\000\093\000\093\000\093\000\
    \093\000\093\000\093\000\093\000\093\000\093\000\093\000\093\000\
    \093\000\093\000\093\000\093\000\093\000\093\000\093\000\093\000\
    \093\000\093\000\093\000\093\000\093\000\093\000\098\000\101\000\
    \101\000\101\000\101\000\101\000\101\000\101\000\101\000\101\000\
    \101\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \101\000\101\000\101\000\101\000\101\000\101\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \101\000\101\000\101\000\101\000\101\000\101\000\000\000\000\000\
    \097\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\100\000\000\000\000\000\000\000\000\000\000\000\
    \099\000\000\000\000\000\000\000\096\000\102\000\102\000\102\000\
    \102\000\102\000\102\000\102\000\102\000\102\000\102\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\102\000\102\000\
    \102\000\102\000\102\000\102\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\092\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\102\000\102\000\
    \102\000\102\000\102\000\102\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000";
  Lexing.lex_check = 
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\255\255\255\255\028\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\000\000\000\000\000\000\028\000\000\000\000\000\016\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\011\000\
    \012\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\014\000\017\000\018\000\032\000\000\000\
    \014\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\003\000\003\000\
    \003\000\003\000\003\000\003\000\003\000\003\000\003\000\003\000\
    \004\000\004\000\004\000\004\000\004\000\004\000\004\000\004\000\
    \010\000\020\000\021\000\021\000\025\000\033\000\034\000\035\000\
    \036\000\038\000\039\000\040\000\041\000\042\000\043\000\045\000\
    \046\000\047\000\020\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\048\000\049\000\050\000\
    \051\000\052\000\044\000\053\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\044\000\054\000\
    \004\000\056\000\026\000\057\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\058\000\059\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\060\000\061\000\062\000\063\000\064\000\084\000\
    \000\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\081\000\086\000\255\255\255\255\027\000\
    \255\255\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\030\000\030\000\030\000\030\000\030\000\
    \030\000\030\000\030\000\030\000\030\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\030\000\030\000\030\000\030\000\
    \030\000\030\000\030\000\030\000\030\000\030\000\030\000\030\000\
    \030\000\030\000\030\000\030\000\030\000\030\000\030\000\030\000\
    \030\000\030\000\030\000\030\000\030\000\030\000\255\255\255\255\
    \255\255\255\255\030\000\255\255\030\000\030\000\030\000\030\000\
    \030\000\030\000\030\000\030\000\030\000\030\000\030\000\030\000\
    \030\000\030\000\030\000\030\000\030\000\030\000\030\000\030\000\
    \030\000\030\000\030\000\030\000\030\000\030\000\031\000\031\000\
    \031\000\031\000\031\000\031\000\031\000\031\000\031\000\031\000\
    \031\000\255\255\255\255\255\255\255\255\255\255\255\255\031\000\
    \031\000\031\000\031\000\031\000\031\000\031\000\031\000\031\000\
    \031\000\031\000\031\000\031\000\031\000\031\000\031\000\031\000\
    \031\000\031\000\031\000\031\000\031\000\031\000\031\000\031\000\
    \031\000\255\255\255\255\255\255\255\255\031\000\255\255\031\000\
    \031\000\031\000\031\000\031\000\031\000\031\000\031\000\031\000\
    \031\000\031\000\031\000\031\000\031\000\031\000\031\000\031\000\
    \031\000\031\000\031\000\031\000\031\000\031\000\031\000\031\000\
    \031\000\078\000\078\000\078\000\078\000\078\000\078\000\078\000\
    \078\000\078\000\078\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\078\000\078\000\078\000\078\000\078\000\078\000\
    \079\000\079\000\079\000\079\000\079\000\079\000\079\000\079\000\
    \255\255\081\000\255\255\255\255\255\255\255\255\255\255\080\000\
    \080\000\080\000\080\000\080\000\080\000\080\000\080\000\080\000\
    \080\000\255\255\078\000\078\000\078\000\078\000\078\000\078\000\
    \080\000\080\000\080\000\080\000\080\000\080\000\255\255\255\255\
    \255\255\255\255\086\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \080\000\080\000\080\000\080\000\080\000\080\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\090\000\090\000\
    \090\000\090\000\090\000\090\000\090\000\090\000\095\000\096\000\
    \096\000\096\000\096\000\096\000\096\000\096\000\096\000\096\000\
    \096\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \096\000\096\000\096\000\096\000\096\000\096\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \096\000\096\000\096\000\096\000\096\000\096\000\255\255\255\255\
    \095\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\095\000\255\255\255\255\255\255\255\255\255\255\
    \095\000\255\255\255\255\255\255\095\000\101\000\101\000\101\000\
    \101\000\101\000\101\000\101\000\101\000\101\000\101\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\101\000\101\000\
    \101\000\101\000\101\000\101\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\090\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\101\000\101\000\
    \101\000\101\000\101\000\101\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255";
  Lexing.lex_base_code = 
   "";
  Lexing.lex_backtrk_code = 
   "";
  Lexing.lex_default_code = 
   "";
  Lexing.lex_trans_code = 
   "";
  Lexing.lex_check_code = 
   "";
  Lexing.lex_code = 
   "";
}

let rec token lexbuf =
    __ocaml_lex_token_rec lexbuf 0
and __ocaml_lex_token_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 50 "lexer.mll"
            ( newline lexbuf; token lexbuf )
# 341 "lexer.ml"

  | 1 ->
# 51 "lexer.mll"
            ( token lexbuf )
# 346 "lexer.ml"

  | 2 ->
let
# 52 "lexer.mll"
             id
# 352 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 52 "lexer.mll"
                ( id_or_kwd id )
# 356 "lexer.ml"

  | 3 ->
# 53 "lexer.mll"
                         ( INCLUDEIOS )
# 361 "lexer.ml"

  | 4 ->
# 54 "lexer.mll"
                          ( INCLUDEIOS )
# 366 "lexer.ml"

  | 5 ->
# 55 "lexer.mll"
                ( STDCOUT )
# 371 "lexer.ml"

  | 6 ->
# 56 "lexer.mll"
            ( CHAINE (String.concat "" (chaine lexbuf) ))
# 376 "lexer.ml"

  | 7 ->
# 57 "lexer.mll"
            ( LACC )
# 381 "lexer.ml"

  | 8 ->
# 58 "lexer.mll"
            ( RACC )
# 386 "lexer.ml"

  | 9 ->
# 59 "lexer.mll"
            ( CHEVRON )
# 391 "lexer.ml"

  | 10 ->
# 60 "lexer.mll"
            ( SDEREF )
# 396 "lexer.ml"

  | 11 ->
# 61 "lexer.mll"
            ( DOT )
# 401 "lexer.ml"

  | 12 ->
# 62 "lexer.mll"
            ( NOT )
# 406 "lexer.ml"

  | 13 ->
# 63 "lexer.mll"
            ( INCR )
# 411 "lexer.ml"

  | 14 ->
# 64 "lexer.mll"
            ( DECR )
# 416 "lexer.ml"

  | 15 ->
# 65 "lexer.mll"
            ( LAND )
# 421 "lexer.ml"

  | 16 ->
# 66 "lexer.mll"
            ( TIMES )
# 426 "lexer.ml"

  | 17 ->
# 67 "lexer.mll"
            ( DIV )
# 431 "lexer.ml"

  | 18 ->
# 68 "lexer.mll"
            ( MODULO)
# 436 "lexer.ml"

  | 19 ->
# 69 "lexer.mll"
            ( PLUS )
# 441 "lexer.ml"

  | 20 ->
# 70 "lexer.mll"
            ( MINUS )
# 446 "lexer.ml"

  | 21 ->
# 71 "lexer.mll"
            ( LT )
# 451 "lexer.ml"

  | 22 ->
# 72 "lexer.mll"
             ( LE )
# 456 "lexer.ml"

  | 23 ->
# 73 "lexer.mll"
            ( GT )
# 461 "lexer.ml"

  | 24 ->
# 74 "lexer.mll"
             ( GE )
# 466 "lexer.ml"

  | 25 ->
# 75 "lexer.mll"
             ( EQ )
# 471 "lexer.ml"

  | 26 ->
# 76 "lexer.mll"
             ( NEQ )
# 476 "lexer.ml"

  | 27 ->
# 77 "lexer.mll"
             (AND)
# 481 "lexer.ml"

  | 28 ->
# 78 "lexer.mll"
            (OR)
# 486 "lexer.ml"

  | 29 ->
# 79 "lexer.mll"
            (ASSIGN)
# 491 "lexer.ml"

  | 30 ->
# 80 "lexer.mll"
            ( LPAR )
# 496 "lexer.ml"

  | 31 ->
# 81 "lexer.mll"
            ( RPAR )
# 501 "lexer.ml"

  | 32 ->
# 82 "lexer.mll"
            ( COMMA )
# 506 "lexer.ml"

  | 33 ->
# 83 "lexer.mll"
            ( COLON )
# 511 "lexer.ml"

  | 34 ->
# 84 "lexer.mll"
            ( SEMICOLON )
# 516 "lexer.ml"

  | 35 ->
# 85 "lexer.mll"
            ( comment lexbuf )
# 521 "lexer.ml"

  | 36 ->
# 86 "lexer.mll"
            ( commentendl lexbuf)
# 526 "lexer.ml"

  | 37 ->
let
# 87 "lexer.mll"
               s
# 532 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 87 "lexer.mll"
                 ( INTEGER (int_of_string s) )
# 536 "lexer.ml"

  | 38 ->
# 88 "lexer.mll"
            ( EOF )
# 541 "lexer.ml"

  | 39 ->
let
# 89 "lexer.mll"
         c
# 547 "lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 89 "lexer.mll"
            ( raise (Lexing_error ("illegal character: " ^ String.make 1 c)) )
# 551 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_token_rec lexbuf __ocaml_lex_state

and comment lexbuf =
    __ocaml_lex_comment_rec lexbuf 81
and __ocaml_lex_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 93 "lexer.mll"
            ( token lexbuf )
# 562 "lexer.ml"

  | 1 ->
# 94 "lexer.mll"
            ( comment lexbuf )
# 567 "lexer.ml"

  | 2 ->
# 95 "lexer.mll"
            ( raise (Lexing_error ("unterminated comment")) )
# 572 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_comment_rec lexbuf __ocaml_lex_state

and commentendl lexbuf =
    __ocaml_lex_commentendl_rec lexbuf 86
and __ocaml_lex_commentendl_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 98 "lexer.mll"
         ( newline lexbuf ; token lexbuf )
# 583 "lexer.ml"

  | 1 ->
# 99 "lexer.mll"
       (commentendl lexbuf)
# 588 "lexer.ml"

  | 2 ->
# 100 "lexer.mll"
        (EOF)
# 593 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_commentendl_rec lexbuf __ocaml_lex_state

and chaine lexbuf =
    __ocaml_lex_chaine_rec lexbuf 90
and __ocaml_lex_chaine_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 103 "lexer.mll"
            ( "\n"::(chaine lexbuf) )
# 604 "lexer.ml"

  | 1 ->
# 104 "lexer.mll"
            ( "\t"::(chaine lexbuf) )
# 609 "lexer.ml"

  | 2 ->
# 105 "lexer.mll"
            ( "\""::(chaine lexbuf) )
# 614 "lexer.ml"

  | 3 ->
# 106 "lexer.mll"
            ( "\\"::(chaine lexbuf) )
# 619 "lexer.ml"

  | 4 ->
let
# 107 "lexer.mll"
                                  s
# 625 "lexer.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_start_pos + 2) (lexbuf.Lexing.lex_start_pos + 4) in
# 107 "lexer.mll"
                                      ( (String.make 1 (char_of_int (int_of_string ("0x" ^ s) ) ))::(chaine lexbuf) )
# 629 "lexer.ml"

  | 5 ->
# 108 "lexer.mll"
            ( chaine lexbuf )
# 634 "lexer.ml"

  | 6 ->
# 109 "lexer.mll"
            ( [] )
# 639 "lexer.ml"

  | 7 ->
let
# 110 "lexer.mll"
                    c
# 645 "lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 110 "lexer.mll"
                      ( (String.make 1 c)::(chaine lexbuf) )
# 649 "lexer.ml"

  | 8 ->
# 111 "lexer.mll"
            ( raise (Lexing_error "End of file before a string is finished.") )
# 654 "lexer.ml"

  | 9 ->
# 112 "lexer.mll"
            ( raise (Lexing_error "Invalid char inside a string.") )
# 659 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; __ocaml_lex_chaine_rec lexbuf __ocaml_lex_state

;;

