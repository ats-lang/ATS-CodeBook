(* ****** ****** *)
(*
** HX-2018-01:
** Hangman2:
** a word-guessing game
*)
(* ****** ****** *)
//
abst@ype state_t0ype
abst@ype input_t0ype
//
typedef state = state_t0ype
typedef input = input_t0ype
//
(* ****** ****** *)

datatype
status =
| STATUSsolved of ()
| STATUStimeup of ()
| STATUSasking of ()

(* ****** ****** *)
//
extern
fun
state_check
(&state): status

extern
fun
state_update
(&state >> _, input): int

extern
fun
state_initize
( state: &state? >> _
, ntime: int, word0: string): int

(* ****** ****** *)
//
extern
fun
GameLoop
(&state >> _, stream_vt(input)): int
and
GameLoop_solved
(&state >> _, stream_vt(input)): int
and
GameLoop_timeup
(&state >> _, stream_vt(input)): int
and
GameLoop_asking
(&state >> _, stream_vt(input)): int
//
(* ****** ****** *)

implement
GameLoop
(state, xs) = let
//
val
status = state_check(state)
//
in
  case+ status of
  | STATUSsolved() => GameLoop_solved(state, xs)
  | STATUStimeup() => GameLoop_timeup(state, xs)
  | STATUSasking() => GameLoop_asking(state, xs)
end // end of [GameLoop]

(* ****** ****** *)

#include
"share/atspre_staload.hats"
#include
"share/atspre_staload_libats_ML.hats"

(* ****** ****** *)
//
extern
fun
GameMain(): void
//
implement main0() = GameMain((*void*))
//
(* ****** ****** *)
//
extern
fun
stream_by_url_
(url: string): streamopt_vt(char)
extern
fun
streamize_channel00
((*channel00*)): stream_vt(string)
//
(* ****** ****** *)

local

#include
"$PATSHOMELOCS\
/atscntrb-libjson-c/mylibies.hats"
#include
"$PATSHOMELOCS\
/atscntrb-libjson-c/mylibies_link.hats"

#include
"$PATSHOMELOCS\
/atscntrb-hx-teaching-bucs/mylibies.hats"

#staload $JSON_ML

#staload
UN = "prelude/SATS/unsafe.sats"
#staload
STDLIB = "libats/libc/SATS/stdlib.sats"
#staload
UNISTD = "libats/libc/SATS/unistd.sats"

#staload
BUCS520 =
$BUCS520_2018_Spring

#define
Channel00Readall
"http://cs320.herokuapp.com/api/channel00/readall"
#define
Channel00Clearall
"http://cs320.herokuapp.com/api/channel00/clearall"

in (* in-of-local *)

implement
stream_by_url_(url) =
$BUCS520.streamopt_url_char<>(url)

implement
streamize_channel00
  ((*void*)) = let
//
fun
auxone
(n0: int):
List0_vt(string) = let
//
val opt =
stream_by_url_
(Channel00Readall)
//
val input =
(
case+ opt of
| ~None_vt() => ""
| ~Some_vt(input) =>
  strptr2string
  (
    string_make_stream_vt
    ($UN.castvwtp0(input))
  )
) : string // end of [val]
//
val-
JSONarray(jsvs) =
jsonval_ofstring(input)
//
in
//
auxone2(n0, jsvs, list_vt_nil)
//
end // end [auxone]
//
and
auxone2
(
n0: int
,
xs: jsonvalist
,
cs: List0_vt(string)
) : List0_vt(string) =
(
case+ xs of
| list_nil() =>
  (list_vt_reverse(cs))
| list_cons(x0, xs) => let
    val-JSONstring(x0) = x0
    val i0 = $STDLIB.atoi(x0)
  in
    if
    i0 <= n0
    then
    list_vt_reverse(cs)
    else
    auxone2(n0, xs, list_vt_cons(x0, cs))
  end // end of [list_cons]
)
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
    val _ = $UNISTD.sleep(1)
  }
| ~list_vt_cons
    (x0, xs) =>
    stream_vt_cons(x0, auxjoin2(x0, xs))
//
end // end of [auxjoin_con]
//
and
auxjoin2
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
    stream_vt_cons(x1, auxjoin2(x1, xs))
), (list_vt_free(xs))
)
//
in
//
auxjoin(0) where
{
  val
  opt =
  stream_by_url_(Channel00Clearall)
  val
  ((*freed*)) =
  (case+ opt of
   | ~None_vt() => ()
   | ~Some_vt(cs) => free(stream2list_vt(cs)))
} (* end of [where] *)
//
end // end of [streamize_channel00]

end // end of [local]

(* ****** ****** *)

fun
is_guessed
( c0: char
, guess: list0(char)
) : bool =
(guess).exists()(lam(c1) => c0=c1)

fun
word_display
( word0: string
, guess: list0(char)
) : void =
(
(word0).foreach()
(lam(c0) =>
 print_char
 (if is_guessed(c0, guess) then c0 else '_')
)
) (* end of [word_display] *)

(* ****** ****** *)

local

assume
state_t0ype = @{
  ntime= int
,
  word0= string
,
  guess= list0(char)
}

assume input_t0ype = char

fun
is_contained
( c0: char
, word0: string
) : bool =
(word0).exists()(lam(c1) => c0=c1)

fun
is_solved
( w0: string
, guess: list0(char)
) : bool =
(w0).forall()
(lam(c0) => is_guessed(c0, guess))

in (* in-of-local *)

implement
state_check
  (state) = let
//
val word0 = state.word0
val guess = state.guess
//
in
//
(
ifcase
| is_solved
  (word0, guess) => STATUSsolved()
| state.ntime = 0 => STATUStimeup()
| _ (*otherwise*) => STATUSasking()
)
//
end // end of [state_check]

implement
state_update
(state, input) = let
//
val c0 = input
val nt = state.ntime
val w0 = state.word0
val cs = state.guess
//
in
//
ifcase
| is_guessed
    (c0, cs) => (0)
| is_contained
    (c0, w0) =>
    (state.guess := list0_cons(c0, cs); 0)
| _ (* otherwise *) =>
    (state.ntime := nt-1;
     state.guess := list0_cons(c0, cs); 1)
//
end // end of [state_update]

implement
state_initize
( state
, ntime, word0) = (0) where
{
//
val () = (state.ntime := ntime)
val () = (state.word0 := word0)
val () = (state.guess := list0_nil())
//
} // end of [state_initize]

implement
GameLoop_solved
  (state, xs) =
  state.ntime where
{
  val () = free(xs)
  val () = println! ("You solved it: ", state.word0)
}

implement
GameLoop_timeup
  (state, xs) =
  state.ntime where
{
  val () = free(xs)
  val () = println! ("Sorry, you have no more chances.")
}

implement
GameLoop_asking
  (state, xs) = let
//
val () =
println!
("Chances: ", state.ntime)
val () =
println!
("Guessed: ", state.guess)
val () =
word_display
(state.word0, state.guess)
//
val () = println!((*void*))
//
in
//
case+ !xs of
| ~stream_vt_nil() => (~1) where
  {
    val () =
    println!
    ("ERROR: no input from the player!!!")
  }
| ~stream_vt_cons(x0, xs) =>
  let
    val err =
    state_update(state, x0) in GameLoop(state, xs)
  end
//
end // end of [GameLoop_asking]

end // end of [local]

(* ****** ****** *)

implement
GameMain() =
{
//
val nt = 6
val w0 = "camouflage"
//
val () = println!("Start!")
//
var
state: state
val err =
state_initize(state, nt, w0)
//
val lines =
streamize_channel00()
val lines =
stream_vt_map<string><string>
  (lines) where
{
//
#staload UN = $UNSAFE
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
val chars = auxmain(lines) where
{
//
fun
auxmain
(
xs:
stream_vt(string)
) : stream_vt(char) = $ldelay
(
(
case+ !xs of
| ~stream_vt_nil() =>
   stream_vt_nil()
| ~stream_vt_cons(x0, xs) => let
    val x0 = g1ofg0(x0)
  in
    if
    iseqz(x0)
    then !(auxmain(xs))
    else stream_vt_cons(x0[0], auxmain(xs)) 
  end // end of [stream_vt_cons]
)
, (lazy_vt_free(xs))
)
}
//
val
ntime =
GameLoop(state, chars)
where
{ reassume input_t0ype }
//
val ((*void*)) = println! ("Game Over: ", ntime)
//
} (* end of [GameMain] *)

(* ****** ****** *)

(* end of [Hangman2.dats] *)
