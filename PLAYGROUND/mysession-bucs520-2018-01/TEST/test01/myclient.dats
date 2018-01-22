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
myclient
{id:int}
(CH: channel(id), prot: protocol(id)): void

(* ****** ****** *)
//
#staload UN = $UNSAFE
//
#staload "./mybasis.dats"
//
(* ****** ****** *)

implement
myclient
(CH, prot) = let
//
  var prot = prot
//
  val x1 =
  chanprot_bmsg_recv<int>
    (CH, prot)
  val x2 =
  chanprot_bmsg_recv<int>
    (CH, prot)
//
  val () =
  chanprot_bmsg_send<int>
    (CH, prot, x1 * x2)
//
  val () =
  println! ("x1 = ", x1)
  val () =
  println! ("x2 = ", x2)
//
  val x4 =
  chanprot_bmsg_recv<int>(CH, prot)
//
  val () =
  println! ("x4 = ", x4)
//
  val () =
  chanprot_elim_nil(CH, prot)
//
in
//
if (x4 > 0)
then println!("Correct!") else println!("Incorrect!")
//
end // end of [let] // end of [myclient]

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
prot = myprtcl((*void*))
val
[id:int]
prot =
$UN.castvwtp0{protocol()}(prot)
//
val CH =
$UN.cast
{channel(id)}(list0_tuple<int>(1))
//
val ((*void*)) = myclient(CH, prot)
//
} (* end of [main0] *)

end // end of [local]

(* ****** ****** *)

(* end of [myclient.dats] *)
