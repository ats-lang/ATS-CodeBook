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

fun
is_solved
( w0: string
, guess: list0(char)
) : bool =
(w0).forall()
(lam(c0) => is_guessed(c0, guess))
and
is_guessed
( c0: char
, guess: list0(char)
) : bool =
(guess).exists()(lam(c1) => c0=c1)
and
is_contained
( c0: char
, word0: string
) : bool =
(word0).exists()(lam(c1) => c0=c1)

(* ****** ****** *)

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

#define
Channel01Insert
"http://cs320.herokuapp.com/api/channel01/insert"

(* ****** ****** *)

#define
Channel00Readall
"http://cs320.herokuapp.com/api/channel00/readall"
#define
Channel00Clearall
"http://cs320.herokuapp.com/api/channel00/clearall"

(* ****** ****** *)
//
fun
channel01_insert_msg
  (msg: string): void = let
  val opt =
  $BUCS520.streamopt_url_char<>
  (string_append3
    (Channel01Insert, "/", msg))
in
  case+ opt of
  | ~None_vt() => ()
  | ~Some_vt(cs) => free(stream2list_vt(cs))
end // end of [channel01_insert_msg]
//
(* ****** ****** *)

fun
channel00_clearall
  ((*void*)): void = let
  val opt =
  $BUCS520.streamopt_url_char<>
    (Channel00Clearall)
in
  case+ opt of
  | ~None_vt() => ()
  | ~Some_vt(cs) => free(stream2list_vt(cs))
end // end of [channel00_clearall]

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
val ns =
auxlst(0, xs) where
{
fun
auxlst
(
i: int
,
xs: stream_vt(char)
) : List0_vt(int) =
(
case+ !xs of
| ~stream_vt_nil
   () => list_vt_nil()
| ~stream_vt_cons
   (x0, xs) =>
  (
   if x0 != c0
     then auxlst(i+1, xs)
     else list_vt_cons(i, auxlst(i+1, xs))
  ) (* end of [stream_vt_cons] *)
)
val xs = streamize_string_char(w0)
} (* end of [val] *)
//
val ns = list_vt_reverse(ns)
val ns = list_vt_mapfree_cloptr<int><jsonval>(ns, lam(n)=>jsonval_int(n))
val ns = JSONarray(list_vt2t(ns))
val ns = jsonval_tostring(ns)
val () = channel01_insert_msg($UN.strptr2string(ns))
val ((*freed*)) = strptr_free(ns)
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

local

#staload
"./Hangman3_channel.dats"

in (* in-of-local *)

fun
streamize_channel00
(
// argless
) : stream_vt(string) = let
//
val
CH0 = $UN.cast{channel}(0)
//
implement
channel_readall<>(ch) = let
  val opt =
  $BUCS520.streamopt_url_char<>
    (Channel00Readall)
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
  streamize_channel<>(CH0)
end // end of [streamize_channel00]

end // end of [local]

(* ****** ****** *)
//
extern
fun
GameMain(): void
//
implement
GameMain((*void*)) =
{
//
val nt = 6
val w0 = "camouflage"
//
val () =
channel00_clearall()
//
val () = println!("Start!")
//
val () =
channel01_insert_msg
(strptr2string
(jsonval_tostring
 (jsonval_int(nw)))) where
{
  val nw = sz2i(length(w0))
}
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
val
cs = auxmain(lines) where
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
GameLoop(state, cs)
where
{ reassume input_t0ype }
//
val ((*void*)) = println! ("Game Over: ", ntime)
//
} (* end of [GameMain] *)

(* ****** ****** *)

implement main0() = GameMain()

(* ****** ****** *)

(* end of [Hangman3_player0.dats] *)
