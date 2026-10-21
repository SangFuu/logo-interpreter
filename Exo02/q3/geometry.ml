(*--------------------------------------------------*)
(* Le module Geometry pour les cacluls géométriques *)
(*--------------------------------------------------*)

(*---------------------------------*)
(* Conversion d'un angle exprimé   *)
(* en degre en un angle exprime en *)
(* radians                         *)
(*---------------------------------*)
let deg_to_rad ang =
  (Float.of_int ang) *. Float.pi /. 180.
;;

(*----------------------------------*)
(* Calcul de la coordonnée x        *)
(* d'un déplacement d'une           *)
(* longueur dist selon un angle ang *)
(*----------------------------------*)
let dx dist ang =
  Int.of_float ((Float.of_int dist) *. (Float.cos (deg_to_rad ang)))
;;
(*----------------------------------*)
(* Calcul de la coordonnée y        *)
(* d'un déplacement d'une           *)
(* longueur dist selon un angle ang *)
(*----------------------------------*)
let dy dist ang =
  Int.of_float ((Float.of_int dist) *. (Float.sin (deg_to_rad ang)))
;;
