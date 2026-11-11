(*-------------------------------------------------------------*)
(* Le module Turtle pour la gestion non graphique d'une tortue *)
(*-------------------------------------------------------------*)

open Geometry
;;

(*--------------------------------------------------*)
(* le type d'une tortue                             *)
(*   @param x_loc, y_loc : coordonnées d'une tortue *)
(*   @param ang          : cap d'une tortue         *)
(*   @param pen          : trace d'une tortue       *)
(*--------------------------------------------------*)
type t_turtle = {
    x_loc  : int   ;
    y_loc  : int   ;
    ang    : int   ;
    pen    : bool  ;
  }
;;

(* ------------------------------------------------------------------ *)
(* Cycle de vie                                                       *)
(* ------------------------------------------------------------------ *)

(*--------------------------------*)
(* Création d'une tortue initiale *)
(*--------------------------------*)
let reset() =
  { x_loc = 0     ;
    y_loc = 0     ;
    ang = 0       ;
    pen = false   ;
  }
;;

(*---------------------------------*)
(* Synonyme d'une tortue initiale, *)
(* utile pour la version graphique *)
(*---------------------------------*)
let init() = reset()
;;

(*------------------------------------*)
(* Synonyme pour la version graphique *)
(*------------------------------------*)
let close_turtle() = ()
;;

(* ------------------------------------------------------------------ *)
(* Mouvements                                                         *)
(* ------------------------------------------------------------------ *)

(* ----------------------------------------------------*)
(* Création d'une tortue déplacée                      *)
(*   @param  bf : choix entre avancer ou reculer       *)
(*   @param  t  : la tortue à partir de laquelle       *)
(*                on calcule le déplacement            *)
(*   @param  d  : longueur du déplacement              *)
(*                                                     *)
(*   @return : un tortue avec les nouvelles coordonées *)
(* ----------------------------------------------------*)
let move (bf : bool) (t : t_turtle) (d : int) : t_turtle =
  { x_loc = if bf
            then t.x_loc + (dx d (t.ang))
            else t.x_loc - (dx d (t.ang)) ;
    y_loc = if bf
            then t.y_loc + (dy d (t.ang))
            else t.y_loc - (dy d (t.ang)) ;
    ang = t.ang ;
    pen = t.pen ;
}
;;

let move_fwd = move true
;;

let move_bck = move false
;;

(* ----------------------------------------------------------*)
(* Création d'une tortue avec un cap modifé                  *)
(*   @param  rl   : choix entre tourner à gauche ou à droite *)
(*   @param  t    : la tortue à partir de laquelle           *)
(*                  on calcule le nouveau cap                *)
(*   @param  ang  : la valeur à ajouter au cap               *)
(*                                                           *)
(*   @return : un tortue avec le nouveau cap                 *)
(* ----------------------------------------------------------*)
let turn (rl : bool) (t : t_turtle) (a : int) : t_turtle =
  { x_loc = t.x_loc ;
    y_loc = t.y_loc ;
    ang = (let a = (if rl
                   then (t.ang - a)
                   else (t.ang + a))
                   mod 360
           in
           if a < 0
           then a + 360
           else a) ;
    pen = t.pen ;
  }
;;

let turn_right = turn true
;;

let turn_left = turn false
;;

(* ---------------------------------------------------*)
(* Création d'une tortue avec une trace ou non        *)
(*   @param  ud   : choix entre tracer ou non         *)
(*   @param  t    : la tortue à partir de laquelle    *)
(*                  on construit la nouvelle tortue   *)
(*                                                    *)
(*   @return : un tortue avec le statut pour la trace *)
(* ---------------------------------------------------*)
let trace (ud : bool) (t : t_turtle)  : t_turtle =
  { x_loc = t.x_loc ;
    y_loc = t.y_loc ;
    ang = t.ang ;
    pen = ud ;
  }
;;

let draw = trace true
;;

let nodraw = trace false
;;

(*------------------------------------*)
(* Conversion en chaîne de caractères *)
(*------------------------------------*)
let string_of_turtle (t : t_turtle) : string =
  "Le tortue est en x : " ^ (string_of_int t.x_loc)
  ^ "  y : " ^ (string_of_int t.y_loc) ^ "\n"
  ^ "Elle regarde vers le cap : " ^ (string_of_int t.ang) ^ "\n"
  ^ (if t.pen then "Son crayon est baissé." else "Son crayon est levé.")
  ^ "\n"
;;

