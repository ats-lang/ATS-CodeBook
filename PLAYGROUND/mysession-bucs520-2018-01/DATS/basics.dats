(* ****** ****** *)
(*
**
** HX-2018-01:
** For implementing
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
//
#staload
UN = "prelude/SATS/unsafe.sats"
//
(* ****** ****** *)

#staload "./../SATS/basics.sats"

(* ****** ****** *)
//
typedef
role = int
//
typedef
channel() =
[id:int] channel(id)
//
(* ****** ****** *)
//
extern
fun{}
chanrole_bmsg_recv_int
  (CH: channel(), r: role): int
extern
fun{}
chanrole_bmsg_send_int
  (CH: channel(), r: role, x: int): void
//
extern
fun{}
chanrole_bmsg_recv_bool
  (CH: channel(), r: role): bool
extern
fun{}
chanrole_bmsg_send_bool
  (CH: channel(), r: role, x: bool): void
//
(* ****** ****** *)

implement
chanprot_bmsg_recv_bool<>
  (CH, r) = let
  val x =
  chanprot_bmsg_recv_int<>(CH, r)
in
  if x > 0 then true else false
end // end of [chanprot_bmsg_recv_bool]

implement
chanprot_bmsg_send_bool<>
  (CH, r, x) = let
  val x = (if x then 1 else 0): int
in
  chanprot_bmsg_send_int<>(CH, r, x)
end // end of [chanprot_bmsg_send_bool]

(* ****** ****** *)
//
implement
chanprot_bmsg_recv<int> = chanprot_bmsg_recv_int<>
implement
chanprot_bmsg_recv<bool> = chanprot_bmsg_recv_bool<>
//
(* ****** ****** *)

local

reassume protocol_vtype

in (* in-of-local *)

implement
chanprot_bmsg_recv_int<>
(
  CH, prot
) = let
  val P0 = prot
in
(
case+ P0 of
| PRTCLbmsg
    (r, dt) => let
    val-SSDTint() = dt
  in
    chanrole_bmsg_recv_int<>(CH, r)
  end // end of [PRTCLbmsg]
| ((*rest-of-PRTCL*)) =>
  let
    val () =
    prerrln!
    ("chanprot_bmsg_recv_int: prot = ", P0)
  in
    let val () =
      assertloc(false) in $UN.cast{int}(0) end
    // end of [if]
  end (* end of [let] *)
)
end // end of [channprot_bmsg_recv_int]

(* ****** ****** *)

implement
chanprot_bmsg_send_int<>
(
  CH, prot, x
) = let
  val P0 = prot
in
(
case+ P0 of
| PRTCLbmsg
    (r, dt) => let
    val-SSDTint() = dt
  in
    chanrole_bmsg_send_int<>(CH, r, x)
  end // end of [PRTCLbmsg]
| ((*rest-of-PRTCL*)) =>
  let
    val () =
    prerrln!
    ("chanprot_bmsg_send_int: prot = ", P0)
  in
    let val () = assertloc(false) in ((*void*)) end
  end (* end of [let] *)
)
end // end of [channprot_bmsg_send_int]

end // end of [local]

(* ****** ****** *)

local

reassume protocol_vtype

in (* in-of-local *)

implement
chanprot_bmsg_recv_bool<>
(
  CH, prot
) = let
  val P0 = prot
in
(
case+ P0 of
| PRTCLbmsg
    (r, dt) => let
    val-SSDTbool() = dt
  in
    chanrole_bmsg_recv_bool<>(CH, r)
  end // end of [PRTCLbmsg]
| ((*rest-of-PRTCL*)) =>
  let
    val () =
    prerrln!
    ("chanprot_bmsg_recv_bool: prot = ", P0)
  in
    let val () =
      assertloc(false) in $UN.cast{bool}(0) end
    // end of [let]
  end (* end of [let] *)
)
end // end of [channprot_bmsg_recv_bool]

(* ****** ****** *)

implement
chanprot_bmsg_send_bool<>
(
  CH, prot, x
) = let
  val P0 = prot
in
(
case+ P0 of
| PRTCLbmsg
    (r, dt) => let
    val-SSDTbool() = dt
  in
    chanrole_bmsg_send_bool<>(CH, r, x)
  end // end of [PRTCLbmsg]
| ((*rest-of-PRTCL*)) =>
  let
    val () =
    prerrln!
    ("chanprot_bmsg_send_bool: prot = ", P0)
  in
    let val () = assertloc(false) in ((*void*)) end
  end (* end of [let] *)
)
end // end of [channprot_bmsg_send_bool]

end // end of [local]

(* ****** ****** *)

(* end of [basics.dats] *)
