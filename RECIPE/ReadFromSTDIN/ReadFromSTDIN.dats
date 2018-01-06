(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

fun
tally(): int = let
  fun
  loop
  (xs: stream_vt(string), res: int): int =
  (
    case+ !xs of
    | ~stream_vt_nil() => res
    | ~stream_vt_cons(x, xs) => let
        val () =
        println! ("Please input more or type Ctrl-D to end:")
      in
        loop(xs, res+g0string2int(x))
      end
  )
in
  loop(streamize_fileref_line(stdin_ref), 0)
end // end of [tally]

(* ****** ****** *)

implement
main0() = () where
{
  val () = println!("Please input an integer:")
  val res = tally()
  val () = println!("The tally of all the integers equals ", res)
}

(* ****** ****** *)

(* end of [ReadFromSTDIN.dats] *)
