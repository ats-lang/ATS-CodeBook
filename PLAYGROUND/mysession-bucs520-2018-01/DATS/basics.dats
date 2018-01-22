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
typedef role = int
//
(* ****** ****** *)
//
implement
print_ssdt(dt) =
fprint_ssdt(stdout_ref, dt)
implement
prerr_ssdt(ssdt) =
fprint_ssdt(stderr_ref, ssdt)
//
implement
fprint_ssdt
(out, ssdt0) =
(
case+ ssdt0 of
//
| SSDTint() =>
  fprint(out, "SSDTint()")
//
| SSDTbool() =>
  fprint(out, "SSDTbool()")
//
| SSDTdouble() =>
  fprint(out, "SSDTdouble()")
| SSDTstring() =>
  fprint(out, "SSDTstring()")
//
| SSDTlist(ssdt1) =>
  fprint!(out, "SSDTlist(", ssdt1, ")")
//
) (* end of [fprint_ssdt] *)
//
(* ****** ****** *)

implement
print_prtcl(prot) =
fprint_prtcl(stdout_ref, prot)
implement
prerr_prtcl(prot) =
fprint_prtcl(stderr_ref, prot)

(* ****** ****** *)

implement
fprint_val<prtcl> = fprint_prtcl

implement
fprint_prtcl
(out, prot0) =
(
case+ prot0 of
//
| PRTCLnil() =>
  fprint(out, "PRTCLnil()")
//
| PRTCLbmsg(r, ssdt) =>
  fprint!(out, "PRTCLbmsg(", r, ", ", ssdt, ")")
//
| PRTCLlazy(lprot) =>
  fprint!(out, "PRTCLlazy(", "...", ")")
//
| PRTCLjoin(prots) =>
  fprint!(out, "PRTCLjoin(", prots, ")")
//
| PRTCLaconj(r, prots) =>
  fprint!(out, "PRTCLaconj(", r, ", ", "...", ")")
| PRTCLmconj(r, prots) =>
  fprint!(out, "PRTCLmconj(", r, ", ", "...", ")")
)
//
// end of [ssprot]

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

local

reassume protocol_vtype

in (* in-of-local *)

implement
{}(*tmp*)
chanprot_elim_nil
(
  CH, prot
) = let
  val P0 = prot
in
(
case+ P0 of
| PRTCLnil() => ()
| ((*rest-of-PRTCL*)) =>
  let
    val () =
    prerrln!
    ("chanprot_elim_nil: prot = ", P0)
  in
    let val () =
      assertloc(false) in ((*void*)) end
    // end of [if]
  end (* end of [let] *)
)
end // end of [chanprot_elim_nil]

end // end of [local]

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
end // end of [chanprot_bmsg_recv_int]

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
end // end of [chanprot_bmsg_send_int]

end // end of [local]

(* ****** ****** *)
//
implement
chanprot_bmsg_recv<int> = chanprot_bmsg_recv_int<>
implement
chanprot_bmsg_send<int> = chanprot_bmsg_send_int<>
//
implement
chanprot_bmsg_recv<bool> = chanprot_bmsg_recv_bool<>
implement
chanprot_bmsg_send<bool> = chanprot_bmsg_send_bool<>
//
(* ****** ****** *)

(* end of [basics.dats] *)
