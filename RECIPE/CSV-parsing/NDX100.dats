//usr/bin/env myatscc "$0"; exit
(* ****** ****** *)
//
(*
##myatsccdef=\
patsopt --constraint-ignore --dynamic $1 | \
tcc - -run -DATS_MEMALLOC_LIBC -I${PATSHOME} -I${PATSHOME}/ccomp/runtime -L${PATSHOME}/ccomp/atslib/lib -latslib
*)
//
(* ****** ****** *)

#include "./myread.dats"

(* ****** ****** *)
//
#define
NDX100_csv "./DATA/NDX100.csv"
//
(* ****** ****** *)

val
NDX100_table =
mytable where
{
//
val-
~Some_vt(inp) =
fileref_open_opt
(NDX100_csv, file_mode_r)
//
val
mytable =
dframe_read_fileref(inp)
//
val () = fileref_close(inp)
//
} (* end of [val] *)
//
val nday =
length(NDX100_table)
//
val () =
println!("|NDX100_table| = ", nday)
//
(*
val () =
println!("|NDX100_table[0]| = ", NDX100_table[0])
*)
//
(* ****** ****** *)

val
double_t = TYPE{double}
val
string_t = TYPE{string}

(* ****** ****** *)
//
val
NDX100_Date =
(
NDX100_table
).map(string_t)
(lam(kxs) =>
 let
(*
   val x =
     kxs["Date"]
   val () =
     println! ("x = ", x)
*)
 in
   GVstring_uncons(kxs["Date"])
 end
)
//
val () =
println!
("|NDX100_Date| = ", length(NDX100_Date))
//
(* ****** ****** *)

val
NDX100_AdjClose =
(
NDX100_table
).map(double_t)
(lam(kxs) =>
 let
(*
   val x =
     kxs["Adj Close"]
   val () =
     println! ("x = ", x)
*)
 in
   g0string2float_double
   (GVstring_uncons(kxs["Adj Close"]))
 end
)
//
val () =
println!
("|NDX100_AdjClose| = ", length(NDX100_AdjClose))
//
(* ****** ****** *)

val
NDX100_PChange =
array0_tabulate<double>
(
g1ofg0
(
size(NDX100_AdjClose)
)
,
lam(i) =>
(
if i = 0
  then
  (0.0)
  else
  (NDX100_AdjClose[i]/NDX100_AdjClose[i-1])-1
)
)
//
val () =
println!
("|NDX100_PChange| = ", length(NDX100_PChange))
val () =
println!("NDX100_PChange[0] = ", NDX100_PChange[0])
val () =
println!("NDX100_PChange[1] = ", NDX100_PChange[1])
val () =
println!("NDX100_PChange[2] = ", NDX100_PChange[2])
val () =
println!("NDX100_PChange[3] = ", NDX100_PChange[3])
//
(* ****** ****** *)
//
extern
fun
f_NDX100_MPChange
(k0: intGte(1)): array0(double)
//
(* ****** ****** *)

implement
f_NDX100_MPChange(k0) = let
//
val n0 = length(NDX100_PChange)
//
fun
auxmain
( i: int
, k: int
, s1: double
) : stream_vt(double) = $ldelay
(
if
(i >= n0)
then stream_vt_nil()
else let
  val xi =
  NDX100_PChange[i]
  val s1 = s1 + xi
(*
  val () = println! ("s1+ = ", s1)
*)
in
  if
  (k < k0)
  then let
    val k = k + 1
    val avg = s1/k
  in
    stream_vt_cons(avg, auxmain(i+1, k, s1))
  end // end of [then]
  else let
    val xj =
    NDX100_PChange[i-k]
    val s1 = s1 - xj
(*
    val () = println! ("s1- = ", s1)
*)
    val avg = s1/k
  in
    stream_vt_cons(avg, auxmain(i+1, k, s1))
  end // end of [else]
end
)
in
  array0_make_stream_vt<double>(auxmain(0, 0, 0.0))
end // end of [f_NDX100_MPChange]

(* ****** ****** *)
//
#define K0 21
//
val
NDX100_MPChange = f_NDX100_MPChange(K0)
val () =
println!
("|NDX100_MPChange| = ", length(NDX100_MPChange))
// (*
local
val n0 = length(NDX100_MPChange)
in(*in-of-local*)
val () =
println!
("NDX100_MPChange[0] = ", NDX100_MPChange[0])
val () =
println!
("NDX100_MPChange[1] = ", NDX100_MPChange[1])
val () =
println!
("NDX100_MPChange[2] = ", NDX100_MPChange[2])
val () =
println!
("NDX100_MPChange[3] = ", NDX100_MPChange[3])
val () =
println!
("NDX100_MPChange[-1] = ", NDX100_MPChange[n0-1])
val () =
println!
("NDX100_MPChange[-2] = ", NDX100_MPChange[n0-2])
val () =
println!
("NDX100_MPChange[-3] = ", NDX100_MPChange[n0-3])
val () =
println!
("NDX100_MPChange[-4] = ", NDX100_MPChange[n0-4])
end // end of [local]
// *)
//
(* ****** ****** *)
//
extern
fun
f_NDX100_table_dateseg
( start: string
, finish: string): array0(gvhashtbl)
//
implement
f_NDX100_table_dateseg
  (start, finish) = let
//
macdef uns = GVstring_uncons
//
val start =
array0_bsearch<gvhashtbl>
( NDX100_table
, lam(x) => strcmp(start, uns(x["Date"])))
val finish =
array0_bsearch<gvhashtbl>
( NDX100_table
, lam(x) => strcmp(finish, uns(x["Date"])))
//
val start = min(start, finish)
val finish = max(start, finish)
//
in
  array0_make_subarray(NDX100_table, start, finish-start)
end // end of [f_NDX100_table_dateseg]
//
(* ****** ****** *)

val
NDX100_20100101 =
array0_bsearch<string>
( NDX100_Date
, lam(x) => compare(date, x)
) where
{
  val date = "2010-01-01"
}
val
NDX100_20180101 =
array0_bsearch<string>
( NDX100_Date
, lam(x) => compare(date, x)
) where
{
  val date = "2018-01-01"
}
//
(*
val () =
println!
("NDX100_20100101 = ", NDX100_20100101)
val () =
println!
("NDX100_20180101 = ", NDX100_20180101)
*)
//
(* ****** ****** *)
//
val
NDX100_table_dataseg =
f_NDX100_table_dateseg("2010-01-01", "2018-01-01")
//
val () =
println!
("|NDX100_table_dataseg| = ", length(NDX100_table_dataseg))
//
(* ****** ****** *)

implement main0 ((*void*)) = ()

(* ****** ****** *)

(* end of [NDX100.dats] *)
