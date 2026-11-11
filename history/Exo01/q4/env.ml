(*------------------------------------------------------------------------------*)
(* Le module Env pour les environnements qui stockent les valeurs des variables *)
(*------------------------------------------------------------------------------*)

(*-----------------------------*)
(* le type des identificateurs *)
(*-----------------------------*)
type t_ident = string
;;

(*-----------------------------*)
(* le type des environnements  *)
(*-----------------------------*)
type t_env = (t_ident * int) list
;;

(*---------------------------------*)
(* Exception levée par la fonction *) 
(* value_of si la variable n'est   *)
(* pas définie                     *)
(*---------------------------------*)
exception Undefined_var of t_ident
;;

(*----------------------------------*)
(* Création d'un environnement vide *)
(*----------------------------------*)
let init() : t_env = []
;;

(*------------------------------------*)
(* Ajout d'une liaison à une variable *)
(*------------------------------------*)
let add_binding (env : t_env) (v : t_ident) (a : int) =
  (v, a)::env
;;

(*------------------------------------------*)
(* Récupération de la valeur de la première *)
(* liaison d'une variable                   *)
(*------------------------------------------*)
let rec value_of (v : t_ident) (env : t_env) =
  match env with
  | []                        -> raise (Undefined_var v)
  | (key, value)::env_next -> if (key = v) then value else value_of v env_next
;;

(*------------------------------------------------------*)
(* Conversion d'une liaison en une chaîne de caractères *)
(*------------------------------------------------------*)
let string_of_env (e : t_env) : string =
  let rec string_of_env_aux env =
    match env with
    | []                                -> ""
    | (variable_name, value)::[]        -> variable_name
                                           ^ " = " ^ (string_of_int value)
    | (variable_name, value)::env_next -> variable_name
                                           ^ " = " ^ (string_of_int value)
                                           ^ "; " ^ (string_of_env_aux env_next)
  in
  "[" ^ (string_of_env_aux e) ^ "]"
;;
