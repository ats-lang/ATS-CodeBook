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

(* ****** ****** *)

#define N 100

(* ****** ****** *)
//
#staload UN = $UNSAFE
//
#staload "./myprtcl.dats"
//
(* ****** ****** *)

implement
myserver
(CH, prot) = let
//
  var prot = prot
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
  val x4 =
  (
  if x1*x2 = y3
    then true else false
  // end of [if]
  ) : bool // end of [val]
  val () =
  chanprot_bmsg_send<bool>(CH, prot, x4)
//
  val () =
  chanprot_elim_nil(CH, prot)
in
//
if (x4)
then println!("Correct!") else println!("Incorrect!")
//
end // end of [let] // end of [myserver]

(* ****** ****** *)

local

#dynload"./myprtcl.dats"

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
val () = channel00_clearall()
val () = channel01_clearall()
//
val CH =
$UN.cast
{channel(id)}(list0_tuple<int>(0))
//
val ((*void*)) = myserver(CH, prot)
//
} (* end of [main0] *)

end // end of [local]
 
(* ****** ****** *)

(* end of [myserver.dats] *)
