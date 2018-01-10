(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"

(* ****** ****** *)
//
fun
{a:t0p}
gfact1(n: int): a =
let
  overload * with gmul_int_val
in
  (fix
   f( i: int
    , n: int, r: a): a =>
   if i < n then f(i+1, n, (i+1)*r) else r
  )(0, n, gnumber_int<a>(1))
end // end of [let] // end of [gfact1]
//
(* ****** ****** *)

fun
{a:t0p}
gfact2(n: int): a = let
//
overload * with gmul_int_val
//
fun
loop
(xs: stream_vt(int), r0: a): a =
(
case+ !xs of
| ~stream_vt_nil
    () => r0
| ~stream_vt_cons
    (x0, xs) => loop(xs, (x0+1)*r0)
)
//
val _0_n_ =
streamize_intrange_lr<>(0, n)
//
in
  loop(_0_n_, gnumber_int<a>(1))
end // end of [let] // end of [gfact2]

(* ****** ****** *)

fun
{a:t0p}
product
(xs: stream_vt(a)): a = let
//
overload * with gmul_val_val
//
fun
loop
(xs: stream_vt(a), r0: a): a =
(
case+ !xs of
| ~stream_vt_nil() => r0
| ~stream_vt_cons(x0, xs) => loop(xs, r0*x0)
)
//
in
  loop(xs, gnumber_int<a>(1))
end // end of [product]

fun
{a:t0p}
gfact3(n: int): a =
product<a>
(stream_vt_map_cloptr
 (streamize_intrange_lr<>(0, n), lam(i) => gnumber_int<a>(i+1))
) (* end of [gfact3] *)

(* ****** ****** *)

fun
{a:t0p}
derangement
(n: intGte(1)): a = let
//
val gadd = gadd_val_val<a>
val gmul = gmul_int_val<a>
//
fun
loop(i: int, r0: a, r1: a): a =
  if i < n
  then
  loop(i+1, (i)\gmul(gadd(r0,r1)), r0)
  else r0 // end of [if]
//
in
  loop(1, gnumber_int<a>(0), gnumber_int<a>(1))
end // end of [derangement]

(* ****** ****** *)

#include
"$PATSHOMELOCS\
/atscntrb-hx-intinf/mylibies.hats"
typedef intinf = $GINTINF_t.intinf
overload print with $GINTINF_t.print_intinf

(* ****** ****** *)

#include
"$PATSHOMELOCS\
/atscntrb-hx-mytesting/mylibies.hats"

fun
{a:t0p}
my_time_spent
(
f0: cfun(a)
) : a = $TIMING.time_spent_cloref<a>(f0)

(* ****** ****** *)

implement
main0((*void*)) =
{
//
  #define N 25000
  typedef a = intinf
//
  val r1 =
  my_time_spent<a>(lam()=>gfact1<a>(N))
  val r2 =
  my_time_spent<a>(lam()=>gfact2<a>(N))
  val r3 =
  my_time_spent<a>(lam()=>gfact3<a>(N))
//
  val d0 =
  my_time_spent<a>(lam()=>derangement<a>(N))
//
(*
  val () = println! ("gfact1(", N, ") = ", r1)
  val () = println! ("gfact2(", N, ") = ", r2)
  val () = println! ("gfact2(", N, ") = ", r3)
*)
(*
  val () = println! ("derangement(", N, ") = ", d0)
*)
//
} (* end of [main0] *)

(* ****** ****** *)

(* end of [HX-intinf.dats] *)
