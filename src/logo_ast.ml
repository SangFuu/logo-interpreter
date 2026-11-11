(***************************************)
(*                                     *)
(*  Syntaxe abstraite pour un langage  *)
(*  "à la Logo"                        *)
(*                                     *)
(***************************************)

open Env
;;

open Turtle

(* Decommenter si tortue graphique *)
(*
open Turtle_graphic
;;
*)

(*--------------------------------------------*)
(* type pour représenter l'état de la mémoire *)
(* La mémoire est l'ensemble des liaisons     *)
(* (variable, valeur) et une tartue           *)
(*--------------------------------------------*)
type t_state =
  Env.t_env * Turtle.t_turtle
;;

(*---------------------------------------------*)
(* types pour représenter la syntaxe abstraite *)
(* du langage                                  *)
(*---------------------------------------------*)

(*--------------------------------------------------------------*)
(* Le type pour la syntaxe abstraite des expressions            *)
(* Pour le moment, il n'y a que les constantes et les variables *)
(*--------------------------------------------------------------*)
type t_expr =
  | Cst of int
  | Var of t_ident
  | Add of t_expr * t_expr
  | Mns of t_expr * t_expr
  | Mul of t_expr * t_expr
  | Div of t_expr * t_expr
;;

(*--------------------------------------------------------------*)
(* Le type pour la syntaxe abstraite des commandes de la tortue *)
(*--------------------------------------------------------------*)
type t_cmd =
  | Forward of t_expr
  | Backward of t_expr
  | Right of t_expr
  | Left of t_expr
  | PenUp
  | PenDown
  | Clear
;;

type t_opcmp =
  | Egal
  | Sup
  | Inf
;;

 type t_bexpr =
  | Cmp of t_opcmp * t_expr * t_expr
;;

(*-------------------------------------------------------------------*)
(* Le type pour la syntaxe abstraite des instructions du langage     *)
(* Pour le moment, il y a la définition de la valeur d'une variable, *)
(* une commande pour la tartue et une suite d'instructions           *)
(*-------------------------------------------------------------------*)
type t_instr =
  | Define of t_ident * t_expr
  | Cmd of t_cmd
  | Seq of t_instr * t_instr
  | Repeat of t_expr * t_instr
  | If of t_bexpr * t_instr * t_instr
;;

(*------------------------------------------------------------------------*)
(* Fonctions d'interprétation                                             *)
(*------------------------------------------------------------------------*)

(*------------------------------------------------*)
(* Interprétation d'une expression                *)
(*   @param env : environnement qui contient les  *)
(*                valeurs des variables           *)
(*   @param e   : l'expression à interpéter       *)
(*                                                *)
(*   @return    : valeur de l'expression          *)
(*------------------------------------------------*)
let rec interp_expr (env : t_env) (e : t_expr) : int =
  match e with
  | Cst n -> n
  | Var id -> Env.value_of id env
  | Add (e1, e2) -> (interp_expr env e1) + (interp_expr env e2)
  | Mns (e1, e2) -> (interp_expr env e1) - (interp_expr env e2)
  | Mul (e1, e2) -> (interp_expr env e1) * (interp_expr env e2)
  | Div (e1, e2) -> 
      let val2 = interp_expr env e2 in
      if val2 = 0 then failwith "Erreur : Division par zéro !"
      else (interp_expr env e1) / val2
;;

(*-----------------------------------------------------*)
(* Interprétation d'une commande                       *)
(*   @param c   : la commande à interpéter             *)
(*   @param s   : un état composé d'un environnement   *) 
(*                et de la tortue courante             *)
(*                                                     *)
(*   @return    : la nouvelle tortue après l'exécution *)
(*                de la commande                       *)
(*-----------------------------------------------------*)
let interp_bexpr (env : Env.t_env) (b : t_bexpr) : bool =
  match b with
  | Cmp (op, e1, e2) ->
      let val1 = interp_expr env e1 in
      let val2 = interp_expr env e2 in
      match op with
      | Egal -> val1 = val2
      | Sup  -> val1 > val2
      | Inf  -> val1 < val2
;;

let interp_cmd (c : t_cmd) (s : t_state) : t_turtle =
  let (env, turtle) = s in 
  match c with
  | Forward e  -> move_fwd turtle (interp_expr env e)
  | Backward e -> move_bck turtle (interp_expr env e)
  | Right e    -> turn_right turtle (interp_expr env e)
  | Left e     -> turn_left turtle (interp_expr env e)
  | PenDown    -> draw turtle
  | PenUp      -> nodraw turtle
  | Clear      -> reset ()
;;

(*-----------------------------------------------------*)
(* Interprétation d'une instruction                    *)
(*   @param c   : l'instruction à interpéter           *)
(*   @param s   : un état composé d'un environnement   *) 
(*                et de la tortue courante             *)
(*                                                     *)
(*   @return    : le nouvel état après l'exécution     *)
(*                de l'instruction                     *)
(*-----------------------------------------------------*)
let rec iterate n f a =
  if n > 0 
  then iterate (n - 1) f (f a) 
  else a
;;

let rec interp_instr (i : t_instr) (s : t_state) : t_state =
  let (env, turtle) = s in
  match i with
  | Define (id, e) -> (add_binding env id (interp_expr env e), turtle)
  | Cmd c          -> (env, interp_cmd c s)
  | Seq (i1, i2)   -> interp_instr i2 (interp_instr i1 s)
  | Repeat (e, i_body) -> 
      (*tous d'abord on regarde l'expression pour savoir le nbr de fois ou nous allons la boucler *)
      let n = interp_expr env e in
      (*ensuite nous avons crée la fonction qui prends un etat et qui va executer la boucle*)
      let f etat_courant = interp_instr i_body etat_courant in
      (*Enfin nous testons n fois la situation initiale qui est s ici*)
      iterate n f s
  | If (cond, instr_then, instr_else) ->
      let est_vrai = interp_bexpr env cond in
      if est_vrai then
        interp_instr instr_then s
      else
        interp_instr instr_else s
;;