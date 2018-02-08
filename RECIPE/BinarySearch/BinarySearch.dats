(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

typedef
freal = cfun(double, double)
typedef
interval = $tup(double, double)

(* ****** ****** *)

fun
interval
(
 a: double, b: double
) : interval =
(
  if a <= b then $tup(a, b) else $tup(b, a)
)

(* ****** ****** *)
//
fun
BinarySearch
(
f : freal
,
a : double, b : double
) : stream(interval) = $delay
let
//
  val m = (a+b) / 2
//
in
  if f(m) >= 0
    then stream_cons(interval(a, b), BinarySearch(f, a, m))
    else stream_cons(interval(a, b), BinarySearch(f, m, b))
  // end of [if]
end // end of [BinarySearch]
//
(* ****** ****** *)

implement
main0() = let
//
val f =
lam
(
x: double
): double =<cloref1>
  (x * x * x - x - 2.0)
//
#define EPSILON 1E-6
//
val
intervals =
BinarySearch(f, 1.0, 2.0)
val
intervals =
(intervals).filter()(lam($tup(a, b)) => (b-a) < EPSILON)
//
val $tup(a, b) = intervals[0]
//
in
  println! ("intervals[0] = ", (a+b)/2)
end // end of [main0]

(* ****** ****** *)

(* end of [BinarySearch.dats] *)
