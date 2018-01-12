(* ****** ****** *)
(*
** HX-2018-01:
** Hangman: a word-guessing game
*)
(* ****** ****** *)
//
abst@ype state
abst@ype reply
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
(&state >> _, reply): int
//
(* ****** ****** *)
//
extern
fun
GameLoop
(&state >> _, stream_vt(reply)): int
and
GameLoop_solved
(&state >> _, stream_vt(reply)): int
and
GameLoop_timeup
(&state >> _, stream_vt(reply)): int
and
GameLoop_asking
(&state >> _, stream_vt(reply)): int
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

local

assume
state =
$record{
  word0= string
,
  ntime= int
,
  guess= list0(char)
}

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

in (* in-of-local *)

implement
state_check
  (state) = let
//
val
guess = state.guess
//
in
//
(
ifcase
| state.ntime = 0 =>
  STATUStimeup()
| (state.word0).forall()
  (lam(c0) =>
   is_guessed(c0, guess)) => STATUSsolved()
| _ (*otherwise*) => STATUSasking()
)
//
end // end of [state_check]

end // end of [local]

(* ****** ****** *)

(* end of [Hangman.dats] *)
