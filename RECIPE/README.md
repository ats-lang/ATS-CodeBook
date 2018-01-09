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

## [WordFrqncyCount](./WordFrqncyCount)

This example gives a stream-based implementation that counts words in
a given on-line source and then sorts these words according to their
frequencies. It also explains a bit about using an npm-based package
in ATS.

