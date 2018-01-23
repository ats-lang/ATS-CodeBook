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
( CH: channel(id)
, prot: protocol(id)
, lines: stream_vt(string)): stream_vt(string)
extern
fun
myclient_optrep
{id:int}
( CH: channel(id)
, prot: protocol(id), lines: stream_vt(string)): void

(* ****** ****** *)
//
#staload UN = $UNSAFE
//
#staload "./mybasis.dats"
//
(* ****** ****** *)

implement
myclient
(CH, prot, lines) = let
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
  println! ("x1 = ", x1)
  val () =
  println! ("x2 = ", x2)
//
  val () =
  println!
  (">>Input your answer:")
//
  val-
  ~stream_vt_cons
   (line, lines) = !lines
  val y3 =
  g0string2int(line)
  val () =
  chanprot_bmsg_send<int>
    (CH, prot, y3)
  val () =
  println! ("y3 = ", y3)
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
lines where
{
val () =
if (x4 > 0)
then println!("Correct!") else println!("Incorrect!")
}
//
end // end of [let] // end of [myclient]

(* ****** ****** *)

implement
myclient_optrep
(CH, prot, lines) = let
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
("myclient_optrep: opt = ", opt)
*)
//
in
//
if
(opt=0)
then let
val () =
chanprot_elim_nil<>
  (CH, prot)
in
  free(lines);
  println!("It is over!")
end // end of [then]
else let
  val-
  ~Some_vt(P0) =
  prtcl_join_uncons(prot)
  val lines =
  myclient(CH, P0, lines)
in
  myclient_optrep(CH, prot, lines)
end // end of [else]
//
end // end of [myclient_optrep]

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
val CH =
$UN.cast
{channel(id)}(list0_tuple<int>(1))
//
val ((*void*)) =
myclient_optrep
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

(* end of [myclient.dats] *)
