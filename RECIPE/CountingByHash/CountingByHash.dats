(* ****** ****** *)

#include
"share/atspre_staload.hats"
#include
"share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

abstype item
abstype itemopt(bool)

(* ****** ****** *)

extern
fun{}
itemopt_is_some
(x0: itemopt(b)): [b==true] void
extern
fun{}
itemopt_is_none
(x0: itemopt(b)): [b==false] void

(* ****** ****** *)

extern
fun{}
itemopt_unsome(itemopt(true)): item
extern
fun{}
itemopt_unnone(itemopt(false)): item

(* ****** ****** *)

extern
fun{}
counting$get(): item

(* ****** ****** *)

(* end of [CountingByHash.dats] *)
