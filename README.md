# octo-couscous-omega (ATIAM 2015-2016 Hybrid synthesis project)

This repository offers a MATLAB implementation of two hybrid guitar synthesis
solutions as described in Woodhouse's *On the synthesis of guitar plucks*
paper: an FRF synthesis method and a modal analysis/synthesis process.

Interfaces demonstrating the implementation are available under
`matlab/interfaces`.

## Known bugs

Note that these implementations are prototypes, and there are some bugs.

For instance, the modal synthesis approache has a hard time dealing with
excitation position features (e.g. reproducing the observation that
a dirac of force applied to the middle of the string will only activate
the uneven harmonics).
Indeed, in the middle-excitation case, it gives different results depending
on the parity of the chosen number of string modes (and in the case of an
excitation at string_length/4, will depend on the number of string modes
modulo 4, and so forth...)
