(***************************************)
(* Analyseur Lexical pour ProjeT      *)
(***************************************)

{
  (* On ouvre le module généré par OCamlyacc *)
  (* IL contiendra la définition de tous nos lexemes *)
  open Logo_parser
  exception Not_recognized
  exception Quit
}

(*-------------------------------------------------*)
(* Définition des expressions régulières*)
(*-------------------------------------------------*)

let digit = ['0'-'9']
(* En effet, les entiers peuvent être positifs ou négatifs *)
let integer = ['-' '+']? digit+

let letter = ['a'-'z' 'A'-'Z']
(* identificateur commence par une lettre ou un '_' *)
(* et peut contenir des lettres, des chiffres ou '_'   *)
let ident = (letter | '_') (letter | digit | '_')*

(* Les espace, tabulations et sauts de ligne à ignorer *)
let space = [' ' '\t' '\n' '\r']


(*-------------------------------------------------*)
(* Règles d'analyse lexicale                       *)
(*-------------------------------------------------*)

rule read_lexeme = parse
  | space+      { read_lexeme lexbuf } (* on va ignorer les caractères non significatifs en relançant l'analyse *)
  
  (* nbrs entiers *)
  | integer as s { INT (int_of_string s) }
  
  (* Mots-clés *)
  | "Def"       { DEF }
  | "Avance"    { AVANCE }
  | "Recule"    { RECULE }
  | "Gauche"    { GAUCHE }
  | "Droite"    { DROITE }
  | "Efface"    { EFFACE }
  | "Dessine"   { DESSINE }
  | "Deplace"   { DEPLACE }
  
  (* Ponctuations et symboles *)
  | ':'         { DEUXPOINTS }      (* ppur accéder à la valeur d'une variable :toto *)
  | ';'         { PNTVRG }  (* séparateur de séquence *)
  | '.'         { POINT }        (* FIn du programme *)
  
  (* Identificateurs : donc noms de variables *)
  | ident as id { IDENT id }
  
  (* Fin de fichier *)
  | eof         { EOF }
  
  (* Gestion des erreurs *)
  | _            { raise Not_recognized }