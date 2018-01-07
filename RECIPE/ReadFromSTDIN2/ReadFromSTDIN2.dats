(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

fun
prompts
(
// argless
) : stream_vt(int) =
stream_vt_map_cloptr<int><int>
( xs
, lam(i) =>
  (println!("Please input an integer or type Ctrl-D:"); i)
) where
{
  val xs = intGte_stream_vt(0) // HX: generating 0, 1, 2, 3, ...
}

(* ****** ****** *)

fun
tally() = let
  val ps = prompts()
  val xs =
  streamize_fileref_line(stdin_ref)
  val xs =
  (xs).filter()(lam(x) => isneqz(x))
  val ys =
  stream_vt_map2_cloptr<int,string><int>(ps, xs, lam(p, x) => g0string2int(x))
in
  stream_vt_foldleft_cloptr<int><int>(ys, 0, lam(r, y) => r + y)
end // end of [tally]

(* ****** ****** *)

implement
main0() = let
  val res = tally() in println!("The tally of all the integers equals ", res)
end // end of [main0]

(* ****** ****** *)

(* end of [ReadFromSTDIN2.dats] *)
