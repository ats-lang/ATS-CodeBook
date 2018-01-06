# Hello, World!

I suppose that you have already
gained access to the commands patscc, patsopt
and myatscc. If you have not, there are plenty
of resources on-line that can guide you through
the process of installing ATS (more precisely, ATS2)
on your own machine. For instance, you can find various
scripts [on-line](http://www.ats-lang.org/Downloads.html#Scripts_for_installing_ATS_Postiats)
for installing ATS on Linux and MacOS.

Let us go through the few lines of code in [HelloWorld.dats](./HelloWorld.dats) quickly.
One can form a line-comment in ATS by starting the line with two slashes (//). One can also
form a block-comment in ATS by using the ML-style of commenting:

```ats
(*
...here-is-a-block-comment...
*)
```

The following lines are for staloading (that is, statically loading)
some library code that the ATS compiler (ATS/Postiats) may need for the purpose
of compilation. I will give some explanation elsewhere on using library functions
in the construction of ATS programs:

```ats
#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"
```

In order to compile a program into an executable, the special function
named ```main``` need to be implemented. In the following code,
```main0``` is a variant of ```main```:

```ats
implement
main0() = println! ("Hello", ", world!")
```

Note that the body of ```main0``` is required to be of the type
```void```. The function-like ```println!``` prints its arguments to
the standard output and then prints a new line at the end. I use the
name function-like to refer to something in ATS that is like a
function but is not actually a function.

Happy coding!!!
