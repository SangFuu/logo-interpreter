########################## User's variables ########################
#
# Lexer source file name
LEXER = logo_lexer

# Parser source file name
PARSER = logo_parser

############@ VARIABLE AVEC TORTUE GRAPHIQUE ############################
#
# The Caml sources files needed, must appear in dependencies order
#
# avec tortue graphique
# SOURCES = env.ml geometry.ml turtle.ml turtle_graphic.ml logo_ast.ml

# Path to the graphic library
# avec tortue graphique

# SI VOUS AVEZ INSTALLÉ OCAML ET LA BIBLIOTHÈQUE GRAPHIQUE AVEC OPAM
# SUR VOTRE MACHINE PERSONNELLE
# On peut trouver le chemin de la bibliothèque graphique au moment où
# l'on charge celle-ci dans l'interpréteur ocaml avec la directive #require "graphics"
# 
# LIBS = /chemin_vers_votre_repertoire/.opam/version_d_ocaml_ou_default/lib/graphics
#
# Exemple sur ma machine (LF)
# LIBS = -I /Users/lfuchs/.opam/5.3.0/lib/graphics
#
# SI VOUS UTILISEZ LES MACHINES DES SALLES DE TP
#LIBS = -I /opt/opam/default/lib/graphics

#OBJLIBS = graphics.cma
#########################################################################
#
############@ VARIABLE SANS TORTUE GRAPHIQUE ############################
#
# The Caml sources files needed, must appear in dependencies order
#
# sans tortue graphique
SOURCES = env.ml geometry.ml turtle.ml logo_ast.ml
#
# sans tortue graphique
LIBS=

OBJLIBS=

# The file to generate the executable

EXEC = repl_logo

#################### No change is needed below ######################

OBJS = $(SOURCES:.ml=.cmo)

all : $(OBJS) $(EXEC)

$(EXEC) : $(OBJS) $(PARSER).cmo $(LEXER).cmo $(EXEC).cmo
	ocamlc $(LIBS) $(OBJLIBS) -o  $(EXEC) $(OBJS) $(LEXER).cmo $(PARSER).cmo $(EXEC).cmo

$(LEXER).ml : $(OBJS) $(LEXER).mll
	ocamllex $(LEXER).mll

$(PARSER).ml : $(OBJS) $(LEXER).mll $(PARSER).mly 
	ocamlyacc $(PARSER).mly

$(PARSER).cmo : $(LEXER).ml $(PARSER).ml
	ocamlc -c $(PARSER).mli
	ocamlc -c $(PARSER).ml

$(LEXER).cmo : $(LEXER).ml
	ocamlc -c $(LEXER).ml

$(OBJS) : $(SOURCES)
	ocamlc $(LIBS) -c $^

$(EXEC).cmo:  $(SOURCES) $(LEXER).mll $(PARSER).mly $(EXEC).ml
	ocamlc $(LIBS) -c $(EXEC).ml

clean :
	rm -f *.cm[io]
	rm -f $(LEXER).ml
	rm -f $(PARSER).ml
	rm -f $(PARSER).mli
	rm -f $(EXEC)

