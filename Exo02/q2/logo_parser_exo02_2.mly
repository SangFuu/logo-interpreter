%{
(***************************************)
(* Analyseur syntaxique pour Logo      *)
(***************************************)

open Logo_ast
%}

/*-------------------------------------------------*/
/* Déclaration des lexèmes (tokens)                */
/*-------------------------------------------------*/

%token <int> INT
%token <string> IDENT
%token DEF
%token AVANCE RECULE GAUCHE DROITE
%token EFFACE DESSINE DEPLACE
%token DEUXPOINTS PNTVRG POINT
%token REPETE
%token CROCHOU CROCHFE
%token EOF

/*-------------------------------------------------*/
/* Priorités                                       */
/*-------------------------------------------------*/

/* Le point-virgule est associatif à gauche pour gérer les séquences */
%left PNTVRG

/*-------------------------------------------------*/
/* Point d'entrée de la grammaire                  */
/*-------------------------------------------------*/

%start main
%type <Logo_ast.t_instr> main

%%

/*-------------------------------------------------*/
/* Règles de production                            */
/*-------------------------------------------------*/

main:
  | instruction POINT { $1 }
  | EOF { raise End_of_file }
  | instruction EOF   { $1 }
;

instruction:
  | DEF IDENT expression           { Define($2, $3) }
  | commande                       { Cmd($1) }
  | instruction PNTVRG instruction { Seq($1, $3) }
  | REPETE expression CROCHOU instruction CROCHFE { Repeat($2, $4) }
;

commande:
  | AVANCE expression { Forward($2) }
  | RECULE expression { Backward($2) }
  | GAUCHE expression { Left($2) }
  | DROITE expression { Right($2) }
  | EFFACE            { Clear }
  | DESSINE           { PenDown }
  | DEPLACE           { PenUp }
;

expression:
  | INT              { Cst($1) }
  | DEUXPOINTS IDENT { Var($2) }
;
