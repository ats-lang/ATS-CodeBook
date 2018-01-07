(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

(*
fun
echo() = let
  fun
  loop(xs: stream_vt(string)): void =
  (
    case+ !xs of
    | ~stream_vt_nil() => ()
    | ~stream_vt_cons(x, xs) => (println!(x); loop(xs))
  )
in
  loop(streamize_fileref_line(stdin_ref))
end //  end of [echo]
*)

(* ****** ****** *)

fun
tally(): int = let
  fun
  loop
  (xs: stream_vt(string), res: int): int =
  (
    case+ !xs of
    | ~stream_vt_nil() => res
    | ~stream_vt_cons(x, xs) =>
      let
        val () =
        if isneqz(x) then prompt()
      in
        loop(xs, res+g0string2int(x))
      end
  ) (* end of [loop] *)

  and
  prompt(): void =
  println!
  ("Please input more or type Ctrl-D:")

in
  println!("Please input one integer:");
  loop(streamize_fileref_line(stdin_ref), 0)
end // end of [tally]

(* ****** ****** *)

implement
main0() = () where
{
  val res = tally()
  val () = println!("The tally of the input integers equals ", res)
}

(* ****** ****** *)

(* end of [ReadFromSTDIN.dats] *)
