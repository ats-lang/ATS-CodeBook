(* ****** ****** *)

#include
"share/atspre_staload.hats"
#include
"share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

#include
"$PATSHOMELOCS\
/atscntrb-libjson-c/mylibies.hats"
#include
"$PATSHOMELOCS\
/atscntrb-libjson-c/mylibies_link.hats"

#staload $JSON_ML

fun
jsonval_int
(x: int) = JSONint(g0i2i(x))

(* ****** ****** *)
//
#staload UN = $UNSAFE
//
(* ****** ****** *)
//
#include
"$PATSHOMELOCS\
/atscntrb-hx-teaching-bucs/mylibies.hats"
//
(* ****** ****** *)
//
abst@ype state_t0ype
//
typedef state = state_t0ype
//
(* ****** ****** *)

#define
Channel00Insert
"http://cs320.herokuapp.com/api/channel00/insert"

(* ****** ****** *)

#define
Channel01Readall
"http://cs320.herokuapp.com/api/channel01/readall"

(* ****** ****** *)
//
fun
channel00_insert_msg
  (msg: string): void = let
  val opt =
  $BUCS520.streamopt_url_char<>
  (string_append3
    (Channel00Insert, "/", msg))
in
  case+ opt of
  | ~None_vt() => ()
  | ~Some_vt(cs) => free(stream2list_vt(cs))
end // end of [channel00_insert_msg]
//
(* ****** ****** *)
//
extern
fun
state_check
(&state >> _): int
extern
fun
state_update
(&state >> _, char): void
extern
fun
state_initize
( state: &state? >> _
, nword: int, ntime: int): void
//
(* ****** ****** *)

local

assume
state_t0ype = @{
  ntime= int
,
  guess= list0(char)
,
  word0=array0(char)
}

in

val int_t = TYPE{int}()

implement
state_check
  (state) =
(
(
state.word0
).foldleft(int_t)
  (0, lam(r, c) => if c = '_' then r else r+1)
)

implement
state_initize
  (state, nw, nt) =
{
  val () = state.ntime := nt
  val () = state.guess := list0_nil()
  val () = state.word0 := array0_make_elt(nw, '_')
}

end // end of [local]

(* ****** ****** *)

local

#staload
"./Hangman3_channel.dats"

in (* in-of-local *)

fun
streamize_channel01
(
// argless
) : stream_vt(string) = let
//
val
CH1 = $UN.cast{channel}(1)
//
implement
channel_readall<>(ch) = let
  val opt =
  $BUCS520.streamopt_url_char<>
    (Channel01Readall)
in
  case+ opt of
  | ~None_vt() =>
     None_vt()
  | ~Some_vt(xs) =>
     Some_vt
     (strptr2string
      (string_make_stream_vt($UN.castvwtp0(xs)))
     ) (* end of [Some_vt] *)
end // end of [channel_readall]
//
in
  streamize_channel<>(CH1)
end // end of [streamize_channel01]

end // end of [local]

(* ****** ****** *)
//
extern
fun
GameMain(): void
extern
fun
GameLoop
(&state >> _, stream_vt(string), stream_vt(string)): int
and
GameLoop_guess
(&state >> _, stream_vt(string), stream_vt(string)): int
//
implement
GameMain((*void*)) =
{
//
val nt = 6
//
var
state: state
//
val lines =
streamize_channel01()
val lines =
stream_vt_map<string><string>
  (lines) where
{
//
implement
stream_vt_map$fopr<string><string>
  (line) =
  trunc(string2ptr(line)) where
{
//
fun
trunc(p0: ptr): string = let
//
val c0 = $UN.ptr0_get<char>(p0)
//
in
//
if
iseqz(c0)
then "" else
(
if
(c0 != ':')
then
trunc(ptr_succ<char>(p0))
else
$UN.cast{string}(ptr_succ<char>(p0))
)
//
end // end of [trunc]
} (* end of [stream_vt_map$fopr] *)
}
//
val-
~stream_vt_cons
  (l0, lines) = !lines
val-
JSONint(nw) =
  jsonval_ofstring(l0)
//
val nw =
$UN.cast{int}(nw)
val () =
state_initize(state, nw, nt)
//
val
lns =
streamize_fileref_line
  (stdin_ref)
val
lns =
stream_vt_filter_cloptr
  (lns, lam(ln) => isneqz(ln))
//
val
ntime = GameLoop(state, lns, lines)
//
} (* end of [GameMain] *)
//
(* ****** ****** *)
//
fun
word_display
(w0: array0(char)): void =
(w0).foreach()(lam(c) => print(c))
//
(* ****** ****** *)

implement
GameLoop
( state
, lns, lines) = let
//
reassume state_t0ype
//
val nt = state.ntime
val w0 = state.word0
val () = word_display(w0)
val () = println!((*void*))
val () = println!("Chances: ", nt)
//
val
is_solved =
(w0).forall()
(lam(c) => c != '_')
//
in
//
if
is_solved
then
(
let
  val () = free(lns)
  val () = free(lines)
  val () =
  println! ("Solved!") in nt
end
)
else
(
if
(nt > 0)
then
GameLoop_guess
(state, lns, lines)
else
let
  val () = free(lns)
  val () =
  println! ("No more chances!")
  val () =
  (
    case+ !lines of
    | ~stream_vt_nil
        ((*void*)) => ()
    | ~stream_vt_cons
        (l0, lines) => let
        val () = lazy_vt_free(lines)
      in
        println! ("The chosen word: ", l0)
      end // end of [stream_vt_cons]
  ) : void // end of [val]
in
  (0)
end // end of [else]
)
//
end // end of [GameLoop]

(* ****** ****** *)

implement
GameLoop_guess
( state
, lns, lines) = let
//
reassume state_t0ype
//
val-
~stream_vt_cons
  (l0, lns) = !lns
//
val
l0 = g1ofg0(l0)
val () =
assertloc(isneqz(l0))
//
val c0 = l0[0]
val nt = state.ntime
val w0 = state.word0
//
val () =
channel00_insert_msg(l0)
//
val-
~stream_vt_cons
  (l0, lines) = !lines
val-
JSONarray(jsvs) =
  jsonval_ofstring(l0)
//
val () =
(jsvs).foreach()
(lam(jsv) => let
   val-JSONint(n) = jsv
   val n = $UN.cast{int}(n)
 in
   array0_set_at<char>(w0, n, c0) 
 end
)
//
val () =
if length(jsvs) = 0 then state.ntime := nt-1
//
in
  GameLoop(state, lns, lines)
end // end of [GameLoop_guess]

(* ****** ****** *)

implement main0() = GameMain()

(* ****** ****** *)

(* end of [Hangman3_player1.dats] *)
