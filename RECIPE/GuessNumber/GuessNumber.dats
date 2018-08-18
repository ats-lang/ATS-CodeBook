(* ****** ****** *)
(*
//
A simple game of guessing
a number in a given range.
//
The computer tries to guess
a number chosen by the player.
//
This implementations in memory-clean
in the sense that every allocated byte
is freed *before* the program exits.
//
*)
(* ****** ****** *)
//
#include
"share/atspre_staload.hats"
//
(* ****** ****** *)

(*
//
[resp] is like enum:
No memory allocation happens
//
*)
datatype
resp =
Lower | Higher | Okay | Error

(* ****** ****** *)

datavtype
state =
State of
(int(*lower*), int(*high*))

(* ****** ****** *)

fun
stateFree(s0: state): void = 
let
val+~State(L, H) = s0 in (*nothing*)
end

fun
stateGuess(s0: !state): int = 
let
val+State(L, H) = s0 in (L+H)/2
end

(* ****** ****** *)

fun
stateUpdate
( s0: !state >> _
, r0: resp): void =
let
  val+
  @State(L, H) = s0
in
//
fold@(s0) where
{
val () =
  case+ r0 of
  | Okay() => ()
  | Lower() => H := (L+H)/2-1
  | Higher() => L := (L+H)/2+1
  | Error() => ()
}
//
end // end of [stateUpdate]

(* ****** ****** *)

fun
doGame
( s0: !state >> _
, rs: stream_vt(resp)): void =
(
println!
("Guess = ", stateGuess(s0));
case+ !rs of
| ~stream_vt_nil() => ()
| ~stream_vt_cons(r0, rs) =>
  (
    case+ r0 of
    | Okay() =>
      (println! ("Game Over!"); ~rs)
    | Error() =>
      (
      println! ("Error: ignored!"); doGame(s0, rs)
      )
    | _(*more*) =>
      (
      stateUpdate(s0, r0); doGame(s0, rs)
      )
  )
)

(* ****** ****** *)

implement
main0() = let
//
val rs =
streamize_fileref_line
  (stdin_ref)
val rs = map(rs) where
{
//
fun
map
(rs:
 stream_vt(Strptr1)
) : stream_vt(resp) = $ldelay
(
case+ !rs of
| ~stream_vt_nil() =>
   stream_vt_nil()
| ~stream_vt_cons(r0, rs) =>
   stream_vt_cons(fopr(r0), map(rs))
, stream_vt_free(rs)
) where
{
  fun
  fopr(r0: Strptr1): resp =
  let
    val r1 =
    $UNSAFE.strptr2string(r0)
    val r1 =
    (
    case+ r1 of
    | "okay" => Okay
    | "lower" => Lower()
    | "higher" => Higher()
    | _(*unrecognized*) => Error()
    ) : resp
  in
    r1 where { val () = strptr_free(r0) }
  end
}
//
}
//
val s0 = State(0, 100)
//
in
  doGame(s0, rs); stateFree(s0)
end // end of [main0]

(* ****** ****** *)

(* end of [GuessNumber.dats] *)
