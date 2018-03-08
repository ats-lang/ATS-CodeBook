(* ****** ****** *)
(*
// For parsing CSV tables
*)
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
#include
"share/HATS\
/atspre_staload_libats_ML.hats"
//
(* ****** ****** *)

extern
fun
print_gvhashtbl:
print_type(gvhashtbl)
overload
print with print_gvhashtbl
implement
print_gvhashtbl(kxs) =
fprint_gvhashtbl(stdout_ref, kxs)

(* ****** ****** *)
//
#include
"\
$PATSHOMELOCS\
/atscntrb-hx-csv-parse/mylibies.hats"
//
(* ****** ****** *)
//
#staload
_(*SBF*) = "libats/DATS/stringbuf.dats"
//
(* ****** ****** *)

local
#staload
CSVPARSE = $CSV_PARSE_LINE
in(*in-of-local*)
extern
fun{}
csv_parse_line(line: string): List0_vt(string)
implement
{}(*tmp*)
csv_parse_line
  (line) = res0 where
{
//
var nerr: int = 0
val res0 =
  $CSVPARSE.csv_parse_line_nerr<>(line, nerr)
//
val res0 = $UNSAFE.castvwtp0{List0_vt(string)}(res0)
//
} (* end of [csv_parse_line] *)
end // end of [local]

(* ****** ****** *)
//
extern
fun
gvhashtbl_make_keys_itms
( ks: list0(string)
, xs: list0(string)): gvhashtbl
//
implement
gvhashtbl_make_keys_itms
  (ks, xs) = let
//
(*
val
() =
println! ("ks = ", ks)
val
() =
println! ("xs = ", xs)
*)
//
val
t0 = gvhashtbl_make_nil(8)
//
fun
auxlst
( ks: list0(string)
, xs: list0(string)): void =
(
//
case+ ks of
| list0_nil() => ()
| list0_cons(k, ks) =>
  (
  case+ xs of
  | list0_nil() => ()
  | list0_cons(x, xs) =>
    auxlst(ks, xs) where
    {
(*
      val () = println! ("k = ", k)
      val () = println! ("x = ", x)
*)
      val () = (t0[k] := GVstring(x))
    } (* end of [list0_cons] *)
  )
//
)
in
  let val () = auxlst(ks, xs) in t0 end
end // end of [gvhashtbl_make_keys_itms]
//
(* ****** ****** *)
//
staload UN = $UNSAFE
//
extern
fun
stream_vt_map_line2gvobj
(
ks: list0(string), lines: stream_vt(string)
) : stream_vt(gvhashtbl)
//
implement
stream_vt_map_line2gvobj
(ks, lines) = $ldelay
(
case+ !lines of
| ~stream_vt_nil() =>
   stream_vt_nil()
| ~stream_vt_cons
    (line, lines) => let
    val xs =
    csv_parse_line(line)
    val t0 =
    gvhashtbl_make_keys_itms
      (ks, g0ofg1($UN.list_vt2t(xs)))
    // end of [val]
  in
    let
      val () = list_vt_free(xs)
    in
      stream_vt_cons
      (t0, stream_vt_map_line2gvobj(ks, lines))
    end
  end // end of [stream_vt_cons]
, lazy_vt_free(lines) // called if the stream is freed
)
//
(* ****** ****** *)
//
extern
fun
dframe_read_fileref
  (inp: FILEref): array0(gvhashtbl)
//
(* ****** ****** *)

implement
dframe_read_fileref
  (inp) = kxs where
{
//
val
lines =
streamize_fileref_line(inp)
val
lines =
stream_vt_filter_cloptr
(lines, lam(line) => isneqz(line))
//
val-
~stream_vt_cons
 (line0, lines) = !lines
//
val ks =
csv_parse_line<>(line0)
val kxs =
stream_vt_map_line2gvobj
  (g0ofg1($UN.list_vt2t(ks)), lines)
val kxs =
array0_make_stream_vt<gvhashtbl>(kxs)
val ((*freed*)) = list_vt_free(ks)
//
} (* end of [dframe_read_fileref] *)

(* ****** ****** *)

(* end of [myread.dats] *)
