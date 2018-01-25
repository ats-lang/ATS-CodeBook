(* ****** ****** *)

#include
"share/atspre_staload.hats"
#include
"share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

#include
"$PATSHOMELOCS\
/atscntrb-hx-libjson-c/mylibies.hats"
#include
"$PATSHOMELOCS\
/atscntrb-hx-libjson-c/mylibies_link.hats"

#staload $JSON_ML

(* ****** ****** *)

#staload
UN = "prelude/SATS/unsafe.sats"
#staload
STDLIB = "libats/libc/SATS/stdlib.sats"
#staload
UNISTD = "libats/libc/SATS/unistd.sats"

(* ****** ****** *)

abstype channel_type = ptr
typedef channel = channel_type

(* ****** ****** *)
//
extern
fun{}
linenum_get(string): int
//
implement
{}(*tmp*)
linenum_get
  (line) = $STDLIB.atoi(line)
//
(* ****** ****** *)
//
// HX-2018-01-16:
// [channel_readall]
// returns a representation of
// a JSON-array of JSON-strings
//
extern
fun{}
channel_readall
  (ch: channel): Option_vt(string)
//
(* ****** ****** *)
//
extern
fun{}
channel_readall_pause(channel): void
//
implement
{}(*tmp*)
channel_readall_pause
  (ch) =
  ignoret($UNISTD.usleep(1000000))
//
(* ****** ****** *)
//
extern
fun{}
streamize_channel
  (ch: channel): stream_vt(string)
extern
fun{}
streamize_channel_gte
  (ch: channel, n0: int): stream_vt(string)
//
(* ****** ****** *)
//
implement
{}(*tmp*)
streamize_channel
  (ch) =
(
streamize_channel_gte<>(ch, 0(*n0*))
)
//
(* ****** ****** *)

implement
{}(*tmp*)
streamize_channel_gte
  (ch, n0) =
  auxjoin(0) where
{
//
fun
auxone
(n0: int):
List0_vt(string) = let
//
val opt =
channel_readall<>(ch)
//
in
//
case+ opt of
| ~None_vt() =>
   list_vt_nil()
| ~Some_vt(jsn) => let
    val jsv =
    jsonval_ofstring(jsn)
  in
    case+ jsv of
    | JSONarray(jsvs) =>
      auxone_arr(n0, jsvs, list_vt_nil)
    | _ (*non-JSONarray*) => list_vt_nil()
  end // end of [Some_vt]
//
end // end of [auxone]
//
and
auxone_arr
(
n0: int
,
xs: jsonvalist
,
cs: List0_vt(string)
) : List0_vt(string) =
(
case+ xs of
| list_nil() => cs
| list_cons(x0, xs) => let
    val-JSONstring(x0) = x0
    val i0 = linenum_get<>(x0)
  in
    if
    i0 <= n0
    then (cs)
    else
    auxone_arr(n0, xs, list_vt_cons(x0, cs))
  end // end of [list_cons]
) (* end of [auxone_arr] *)
//
fun
auxjoin
(
n0: int
) :
stream_vt(string) =
$ldelay(auxjoin_con(n0))
//
and
auxjoin_con
(
n0: int
) :
stream_vt_con(string) =
let
  val xs = auxone(n0)
in
//
case+ xs of
| ~list_vt_nil
    () =>
    auxjoin_con(n0) where
  {
    val () =
    channel_readall_pause<>(ch)
  }
| ~list_vt_cons
    (x0, xs) =>
    stream_vt_cons(x0, auxjoin_lst(x0, xs))
//
end // end of [auxjoin_con]
//
and
auxjoin_lst
(
x0: string
,
xs: List0_vt(string)
) : stream_vt(string) = $ldelay
(
(
case+ xs of
| ~list_vt_nil
    () => !
    (auxjoin($STDLIB.atoi(x0)))
| ~list_vt_cons
    (x1, xs) =>
    stream_vt_cons(x1, auxjoin_lst(x1, xs))
), (list_vt_free(xs))
)
//
} (* end of [streamize_channel_gte] *)

(* ****** ****** *)

(* end of [Hangman3_channel.dats] *)
