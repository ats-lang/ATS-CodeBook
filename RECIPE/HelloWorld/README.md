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
(* ...here-is-a-block-comment.. *)
```

```ats
#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"
```
