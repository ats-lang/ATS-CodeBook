(* ****** ****** *)

#include
"share/atspre_staload.hats"
#include
"share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

local
//
#staload
STDLIB = "libats/libc/SATS/stdlib.sats"
//
#define
Channel00Insert
"http://cs320.herokuapp.com/api/channel00/insert"
//
in (* in-of-local *)

fun
GameKeyboard
  (): void = {
//
fun
auxmain
(
lines:
stream_vt(string)
) : void =
(
//
case+ !lines of
| ~stream_vt_nil
   ((*void*)) => ()
| ~stream_vt_cons
   (line, lines) =>
  (
   if
   isneqz(line)
   then let
//
     val url =
     string_append3
     (Channel00Insert, "/", line)
     val err =
     $STDLIB.system
     ("wget -q -O - " + url + " > /dev/null")
//
   in
      auxmain(lines)
   end // end of [then]
   else
   (
      auxmain(lines)
   ) (* end of [else] *)
  )
//
) (* end of [auxmain] *)
//
val () =
auxmain(lines) where
{
  val
  inp = stdin_ref
  val
  lines=
  streamize_fileref_line(inp)
} (* end of [val] *)
//
} (* end of [GameKeyboard] *)

end // end of [local]

(* ****** ****** *)

implement
main0 () = GameKeyboard()

(* ****** ****** *)

(* end of [Hangman2_input.dats] *)
