(*-----------------------------------------------------------------*)
(* Le module Turtle_graphic pour la gestion graphique d'une tortue *)
(*-----------------------------------------------------------------*)

open Graphics
open Geometry

(*--------------------------*)
(* constantes globales pour *)
(* le dessin d'une tortue   *)
(*--------------------------*)

let turtle_size = 7

let turtle_color = rgb 100 180 80

let turtle_width = 3

(* ------------------------------------------------------------------ *)
(* Dessin                                                             *)
(* ------------------------------------------------------------------ *)

(* ---------------------------------------------------------------------- *)
(* Le principe est d'utiliser le double buffering de la bibliothèque      *)
(* Graphics. La tortue n'est dessinée que dans le buffer "front store"    *)
(* et la trace persistente est dessinée dans le buffer "backing store".   *)
(* La fonction synchronize permet l'affichage des deux buffers            *)
(*                                                                        *)
(* plus d'informations à cet endroit                                      *) 
(* https://ocaml.org/p/graphics/latest/doc/graphics/Graphics/index.html#double-buffering *)
(* ---------------------------------------------------------------------- *)

(*-----------------------------------------*)
(* Dessin d'une tortue : un cercle avec un *)
(* rayon qui indique le cap                *)
(*-----------------------------------------*)
let draw_turtle (t : Turtle.t_turtle) =
  set_color turtle_color                  ;
  set_line_width turtle_width             ;
  draw_circle t.x_loc t.y_loc turtle_size ;
  lineto
    (t.x_loc + dx turtle_size t.ang)
    (t.y_loc + dy turtle_size t.ang)      ;
  moveto t.x_loc t.y_loc                  ;
  set_line_width 1                        ;
  set_color black 


(*----------------------------------------------*)
(* Fonctions qui gèrent l'affichage de la trace *) 
(* de la tortue et l'affichage de la tortue     *)
(*----------------------------------------------*)

(*------------------------------------------------*)
(* Le back-buffer n'accumule que la trace. On n'y *)
(* dessine jamais la tortue.                      *)
(*------------------------------------------------*)
let render_trace (t : Turtle.t_turtle) =
  display_mode false       ;
  remember_mode true       ;
  if t.pen then begin
    lineto t.x_loc t.y_loc
  end else
    moveto t.x_loc t.y_loc

(*----------------------------------------------------*)
(* On dessine la tortue dans le front-buffer après    *)
(* synchronisation. La fonction synchronize recopie   *)
(* le back-buffer vers le front-buffer. On dessine    *)
(* la tortue après pour qu'elle apparaisse par-dessus *)
(* la trace.                                          *)
(*----------------------------------------------------*)
let render_turtle  (t : Turtle.t_turtle) =
  display_mode true   ;
  remember_mode false ;
  synchronize ()      ;
  draw_turtle t
  
(* ------------------------------------------------------------------ *)
(* Cycle de vie                                                       *)
(* ------------------------------------------------------------------ *)


(*-----------------------------------------------------------*)
(* Gestion de l'affacement de la fenêtre graphique et        *)
(* repositionnement de la tortue à l'origin (en bas à gauche *)
(* de la fenêtre)                                            *)
(*-----------------------------------------------------------*)
let start_display (t: Turtle.t_turtle) =
  display_mode true      ;
  remember_mode true     ;
  clear_graph ()         ;
  display_mode false     ;
  remember_mode true     ;
  moveto t.x_loc t.y_loc ;
  display_mode true      ;
  remember_mode false    ;
  synchronize ()         ;
  draw_turtle t


(*----------------------------------------*)
(* Initialisation de la fenêtre graphique *)
(*----------------------------------------*)
let init () =
  open_graph ""                       ;
  set_window_title "Ma petite tortue" ;
  auto_synchronize false              ;
  let t = Turtle.reset () in
  start_display t                     ;
  t

(*---------------------------------------*)
(* Création d'une tortue initiale        *)
(* et effacement de la fenêtre graphique *)
(*---------------------------------------*)
let reset () =
  let t = Turtle.reset ()
  in
  start_display t ;
  t

(*-----------------------------------*)
(* Fermeture de la fenêtre graphique *)
(*-----------------------------------*)
let close_turtle () =
  close_graph ()

(* ------------------------------------------------------------------ *)
(* Mouvements                                                         *)
(* ------------------------------------------------------------------ *)

(*----------------------------------------------------------*)
(* Ajout de la partie graphique aux mouvements de la tortue *)
(*----------------------------------------------------------*)

let move (fb : bool) (t : Turtle.t_turtle) (d : int) : Turtle.t_turtle =
  let ret = Turtle.move fb t d
  in
  render_trace ret  ;
  render_turtle ret ;
  ret

let move_fwd = move true
let move_bck = move false

let turn (rl : bool) (t : Turtle.t_turtle) (a : int) : Turtle.t_turtle =
  let ret = Turtle.turn rl t a
  in
  render_turtle ret ;
  ret

let turn_right = turn true
let turn_left  = turn false

(* ------------------------------------------------------------------ *)
(* Délégation vers Turtle                                             *)
(* ------------------------------------------------------------------ *)

let trace  = Turtle.trace
let draw   = Turtle.draw
let nodraw = Turtle.nodraw
let string_of_turtle = Turtle.string_of_turtle
