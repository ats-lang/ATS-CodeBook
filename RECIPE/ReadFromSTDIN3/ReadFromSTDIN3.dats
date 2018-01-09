(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

typedef line = string

(* ****** ****** *)

local

#include
"$PATSHOMELOCS\
/atscntrb-hx-teaching-bucs/mylibies.hats"

#staload $BUCS520_2016_FALL

in (* in-of-local *)

fun
stream_vt_lineto2line
(
xs:
stream_vt(lineto)
) : stream_vt(line) = $ldelay
(
case+ !xs of
| ~stream_vt_nil() =>
   stream_vt_nil()
| ~stream_vt_cons(x0, xs) =>
  (
    case+ x0 of
    | ~LNTOline(line) =>
       stream_vt_cons
       ( strptr2string(line)
       , stream_vt_lineto2line(xs))
    | ~LNTOtimeout((*void*)) =>
       (~(xs); stream_vt_nil((*void*)))
  )
, lazy_vt_free(xs)
)

fun
streamize_fileref_line_
(
  inp: FILEref
) : stream_vt(line) =
(
stream_vt_lineto2line
(streamize_fileref_lineto<>(inp, 5(*nwait=5sec*)))
)

end // end of [local]

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
  streamize_fileref_line_(stdin_ref)
  val xs = (xs).filter()(lam(x) => isneqz(x))
  val ys =
  stream_vt_map2_cloptr<int,string><int>(ps, xs, lam(p, x) => g0string2int(x))
in
  stream_vt_foldleft_cloptr<int><int>(ys, 0, lam(r, y) => r + y)
end // end of [tally]

(* ****** ****** *)

#staload
"libats/libc/SATS/signal.sats"

implement
main0() = let
var
sigact: sigaction
val () =
ptr_nullize<sigaction>
  (__assert__() | sigact) where
{
  extern
  prfun
  __assert__ :
    () -> is_nullable(sigaction)
} (* end of [val] *)
//
val () =
sigact.sa_handler :=
sighandler(lam(sgn) => ((*void*)))
//
val () =
assertloc
(sigaction_null(SIGALRM, sigact) = 0)
//
val res = tally() in println!("The tally of all the integers equals ", res)
//
end // end of [main0]

(* ****** ****** *)

(* end of [ReadFromSTDIN3.dats] *)
