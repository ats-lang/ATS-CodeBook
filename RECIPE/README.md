# Coding Examples in ATS

## [Hello](./Hello)

This example shows how to construct a simple program in ATS, compile
it and then execute it.

## [HX-intinf](./HX-intinf)

This example presents a simple method for using GMP in ATS.
It also makes use of some timing functions for measuring performance.

## [ReadFromSTDIN](./ReadFromSTDIN)

This example demonstrates a stream-based approach to constructing an
interactive program that handles input from the user.

## [ReadFromSTDIN2](./ReadFromSTDIN2)

This example is meant to be directly compared with
[ReadFromSTDIN](./ReadFromSTDIN). While the code in this one does
essentially the same as that of [ReadFromSTDIN](./ReadFromSTDIN), it
is written in a different style, which greatly stresses the use of
combinators in functional programming.

## [ReadFromSTDIN3](./ReadFromSTDIN3)

This example does essentially the same as the code in
[ReadFromSTDIN2](./ReadFromSTDIN2) except for using the alarm signal
(SIGALRM) to prevent the possible scenario of waiting indefinitely for
the user's input.

## [Hangman](./Hangman)

This example gives a straightforward implementation of Hangman, a
famous word-guessing game. A linear stream is employed to handle inputs
from the player. Also, the game-state is passed as a call-by-reference
argument to the game-loop (so as for it to be updated).
  
## [Hangman2](./Hangman2)

This example implements a distributed version of the Hangman game,
making use of a simple web service to handle I/O.
  
## [Hangman3](./Hangman3)

This example implements another distributed version of the Hangman
game for two independent players, who communicate with each other
through two untyped uni-directional channels.
  
## [WordFrqncyCount](./WordFrqncyCount)

This example gives a stream-based implementation that counts words in
a given on-line source and then sorts these words according to their
frequencies. It also explains a bit about using an npm-based package
in ATS.

