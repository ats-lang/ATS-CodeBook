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
mygrader
{id:int}
(CH: channel(id), prot: protocol(id)): void
extern
fun
mygrader_optrep
{id:int}
(CH: channel(id), prot: protocol(id)): void

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
mygrader
(CH, prot) = let
//
  var prot = prot
//
(*
val () =
println!
( "mygrader: prot = "
, $UN.castvwtp1{prtcl}(prot))
*)
//
  val x1 =
  chanprot_bmsg_recv<int>
    (CH, prot)
  val x2 =
  chanprot_bmsg_recv<int>
    (CH, prot)
  val () = println! ("x1 = ", x1)
  val () = println! ("x2 = ", x2)
//
  val y3 =
  chanprot_bmsg_recv<int>
    (CH, prot)
  val () = println! ("y3 = ", y3)
//
  val z4 =
  (
  if x1*x2 = y3 then 1 else 0
  // end of [if]
  ) : int // end of [val]
  val () =
  chanprot_bmsg_send<int>(CH, prot, z4)
//
  val () =
  chanprot_elim_nil(CH, prot)
in
//
if (z4 > 0)
then println!("Correct!") else println!("Incorrect!")
//
end // end of [let] // end of [mygrader]

(* ****** ****** *)

implement
mygrader_optrep
(CH, prot) = let
//
var prot = prot
//
(*
val () =
println!
( "prot = "
, $UN.castvwtp1{prtcl}(prot))
*)
//
val opt =
chanprot_conj_aneg<>(CH, prot)
(*
val
((*void*)) =
println!
("mygrader_optrep: opt = ", opt)
*)
//
in
//
if
(opt=0)
then
chanprot_elim_nil<>
  (CH, prot)
else let
  val-
  ~Some_vt(P0) =
  prtcl_join_uncons(prot)
  val () = mygrader(CH, P0)
in
  mygrader_optrep(CH, prot)
end // end of [else]
//
end // end of [mygrader_optrep]

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
val () = mygrader_optrep(CH, prot)
//
} (* end of [main0] *)

end // end of [local]
 
(* ****** ****** *)

(* end of [mygrader.dats] *)
