(* ****** ****** *)
(*
**
** HX-2018-01:
** For testing
** broadcast-based sessions
** that are dynamically typed
**
*)
(* ****** ****** *)

#include
"share/atspre_staload.hats"
#include
"share\
/atspre_staload_libats_ML.hats"

(* ****** ****** *)

#staload"./../../SATS/basics.sats"
#staload"./../../DATS/basics.dats"

(* ****** ****** *)

extern
fun
myserver
{id:int}
(CH: channel(id), prot: protocol(id)): void
extern
fun
myserver_optrep
{id:int}
( CH: channel(id)
, prot: protocol(id), lines: stream_vt(string)): void

(* ****** ****** *)

#define N 100

(* ****** ****** *)
//
#staload UN = $UNSAFE
//
#staload "./mybasis.dats"
//
(* ****** ****** *)

implement
myserver
(CH, prot) = let
//
  var prot = prot
//
(*
val () =
println!
( "myserver: prot = "
, $UN.castvwtp1{prtcl}(prot))
*)
//
  val x1 = randint(N)
  val x2 = randint(N)
  val () =
  chanprot_bmsg_send<int>
    (CH, prot, x1)
  val () =
  chanprot_bmsg_send<int>
    (CH, prot, x2)
//
  val y3 =
  chanprot_bmsg_recv<int>(CH, prot)
//
  val () =
  println!("x1 = ", x1)
  val () =
  println!("x2 = ", x2)
  val () =
  println!("y3 = ", y3)
//
  val z4 =
  chanprot_bmsg_recv<int>(CH, prot)
//
  val () =
  chanprot_elim_nil(CH, prot)
in
//
if (z4 > 0)
then println!("Correct!") else println!("Incorrect!")
//
end // end of [let] // end of [myserver]

(* ****** ****** *)

implement
myserver_optrep
(CH, prot, lines) = let
//
var prot = prot
//
val () =
println! (">>test or quit?")
(*
val () =
println!
( "myserver_optrep: prot = "
, $UN.castvwtp1{prtcl}(prot))
*)
//
in
//
case+ !lines of
| ~stream_vt_nil() => let
    val () =
    chanprot_conj_apos<>
      (CH, prot, 0(*exit*))
  in
    chanprot_elim_nil<>(CH, prot)
  end // end of [stream_vt_nil]
| ~stream_vt_cons
   (line, lines) =>
  (
    case+ line of
    | "quit" => let
        val () =
        lazy_vt_free(lines)
        val () =
        chanprot_conj_apos<>
          (CH, prot, 0(*exit*))
        // end of [val]
      in
        chanprot_elim_nil<>(CH, prot)
      end // end of [quit]
    | _(*non-quit*) => let
        val () =
        chanprot_conj_apos<>
          (CH, prot, 1(*exit*))
        // end of [val]
        val-
        ~Some_vt(P0) =
        prtcl_join_uncons(prot)
        val () = myserver(CH, P0)
      in
        myserver_optrep(CH, prot, lines)
      end // end of [non-quit]
  )
end (* end of [myserver_optrep] *)

(* ****** ****** *)

local

#dynload"./mybasis.dats"

#include
"./../../DATS/basics.dats"

in (*in-of-local*)

implement
main0() = () where
{
//
val
prot =
prtcl_optrep(0, myprtcl())
val
[id:int]
prot =
$UN.castvwtp0{protocol()}(prot)
//
val () = channel00_clearall()
val () = channel01_clearall()
val () = channel02_clearall()
//
val CH =
$UN.cast
{channel(id)}(list0_tuple<int>(0))
//
val ((*void*)) =
myserver_optrep
  (CH, prot, lines) where
{
  val
  lines =
  streamize_fileref_line(stdin_ref)
}
//
} (* end of [main0] *)

end // end of [local]
 
(* ****** ****** *)

(* end of [myserver.dats] *)
