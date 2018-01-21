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

#staload "./../SATS/basics.sats"

(* ****** ****** *)

local

#define int SSDTint
#define bool SSDTbool
#define sslist SSDTlist
#define double SSDTdouble
#define string SSDTstring

#define nil PRTCLnil
#define bmsg PRTCLbmsg
//
#define ssjoin PRTCLjoin
//
#define sslazy PRTCLlazy
//
#define ssaconj PRTCLaconj
#define ssmconj PRTCLmconj

in

fun
test01(): prtcl =
ssjoin
(
list0_tuple<prtcl>
( bmsg(0, int), bmsg(0, int)
, bmsg(1, int), bmsg(0, bool)
)
)

end // end of [local]

(* ****** ****** *)

extern
fun
myserver
{id:int}
(CH: channel(id), prot: protocol(id)): void

extern
fun
myclient
{id:int}
(CH: channel(id), prot: protocol(id)): void

(* ****** ****** *)

#define N 100

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
    if x1*x2 = y3 then true else false
  ) : bool // end of [val]
  val () =
  chanprot_bmsg_send<bool>(CH, prot, x4)
in
  chanprot_elim_nil(CH, prot)
end // end of [myserver]

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
  val x4 =
  chanprot_bmsg_recv<bool>
    (CH, prot)
//
  val () =
  chanprot_elim_nil(CH, prot)
//
in
  if x4
  then println!("Correct!")
  else println!("Incorrect!")
end // end of [myclient]

(* ****** ****** *)

#staload "./../DATS/basics.dats"

(* ****** ****** *)

implement
main0() = () where
{

} (* end of [main0] *)

(* ****** ****** *)

(* end of [test01.dats] *)
