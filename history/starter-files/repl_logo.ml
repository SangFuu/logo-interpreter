(*-----------------------------------------------------------------*)
(* Le module Repl_logo pour la gestion de la boucle d'interaction  *)
(*-----------------------------------------------------------------*)

open Env
open Turtle

(* Decommenter si tortue graphique *)
(*
open Turtle_graphic
;;
*)

open Logo_ast
open Logo_lexer

(*---------------------------------------------------------*)
(* La boucle d'interaction maintient un état de la mémoire *)
(* c'est-à-dire un environnement et une tortue             *)
(*---------------------------------------------------------*)

let mem = ref (Env.init())

let turtle = ref (init())


(*-----------------------------------------------------------*)
(* Un boucle d'interaction semblable à celle utilisée en TP  *)
(*                                                           *)
(* Dans cette version l'état de la mémoire est affiché après *)
(* chaque interpétation.                                     *)
(*-----------------------------------------------------------*)

let () =
  print_string (string_of_turtle !turtle) ;
  print_string ":> " ; flush stdout ;
  let lexbuf = Lexing.from_channel stdin in
  try
    while true do
      (try
         let pgm = Logo_parser.main Logo_lexer.read_lexeme lexbuf
         in
         print_string "Voilà j'ai analysé ! " ;
         print_newline () ;
         let (e, t) = interp_instr pgm (!mem, !turtle)
         in
         mem := e ;
         turtle := t ;
         (* Ici on affiche l'état de la mémoire *)
         (* après chaque interprétation         *)
         print_string (string_of_turtle !turtle) ;
         print_string "l'environnement est : \n" ;
         print_string (string_of_env !mem) ;
         print_newline() ;
       with
       | Failure message -> print_endline ("Erreur : " ^ message)
       | Env.Undefined_var id -> print_endline ("Variable non définie : " ^ id)
       | Not_recognized ->
          print_string "Lexème non reconnu, on reprend" ;
          print_newline () ;
          Lexing.flush_input lexbuf
       | Stdlib.Parsing.Parse_error ->
          print_string "Erreur de syntaxe, on reprend" ;
          print_newline () ; 
          Lexing.flush_input lexbuf
      ) ;
      print_string ":> " ; flush stdout
    done
  with
  | Quit | End_of_file ->
     print_string "À bientôt !" ;
     print_newline () ;
     close_turtle () ;
     exit 0

