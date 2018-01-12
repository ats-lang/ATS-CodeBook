(* ****** ****** *)
(*
** HX-2018-01:
** Hangman: a word-guessing game
*)
(* ****** ****** *)
//
abstype state
abstype reply
//
(* ****** ****** *)

datatype
status =
| STATUSfound of ()
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
GameLoop_found
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
  | STATUSfound() => GameLoop_found(state, xs)
  | STATUStimeup() => GameLoop_timeup(state, xs)
  | STATUSasking() => GameLoop_asking(state, xs)
end // end of [GameLoop]

(* ****** ****** *)

(* end of [Hangman.dats] *)
