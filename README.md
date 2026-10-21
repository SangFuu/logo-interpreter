# Logo Interpreter

I created this language-theory project with Adnane Serrai as a pair project. We progressively built a Logo interpreter in OCaml.

The goal was to turn commands written in a language into their analysis and execution. I worked on expressions, variables, loops, conditions and error handling.

## Structure

- `Exo01`: first analysis and interpretation steps.
- `Exo02`: language extensions.
- `Exo03`: later versions, including the assembled version in `q4`.
- `Fichiers_fournis`: starter files from the assignment.

I kept the exercise steps, so some folders are partial versions rather than standalone applications.

## Build an assembled version

With OCaml (`ocamlc`, `ocamllex`, `ocamlyacc`) and GNU Make:

```sh
cd Exo03/q4
make
./repl_logo
```

The Makefile uses a terminal turtle without a graphical interface. Original commands for the graphical variant remain in the Makefiles. Run Make in sequential mode.

## Tests

```sh
python3 tests/check.py
```

The tests require OCaml, GNU Make and Python 3. They cover executable versions, examples, calculations, conditions and recovery after some errors. The graphical variant is not covered.
