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

#staload
"libats/ML/SATS/basis.sats"

(* ****** ****** *)
//
datatype
ssdt(a:t@ype) =
//
| SSDTint(int) of ()
| SSDTbool(bool) of ()
| SSDTdouble(double) of ()
| SSDTstring(string) of ()
//
| {a:t@ype}
  SSDTlist(list0(a)) of ssdt(a)
//
typedef ssdt() = [a:t@ype] ssdt(a)
//
(* ****** ****** *)

datatype
prtcl =
//
| PRTCLnil of ()
//
| PRTCLbmsg of
    (int, ssdt())
  // PRTCLbmsg
//
| PRTCLlazy of lazy(prtcl)
//
| PRTCLjoin of ( prtclist )
//
| PRTCLaconj of (int, prtclist)
| PRTCLmconj of (int, prtclist)
// end of [ssprot]

where prtclist = list0(prtcl)

(* ****** ****** *)
//
fun
print_ssdt
{a:t0p}(ssdt(a)): void
fun
prerr_ssdt
{a:t0p}(ssdt(a)): void
fun
fprint_ssdt :
{a:t0p} fprint_type(ssdt(a))
//
overload print with print_ssdt
overload prerr with prerr_ssdt
overload fprint with fprint_ssdt
//
(* ****** ****** *)
//
fun
print_prtcl(prtcl): void
fun
prerr_prtcl(prtcl): void
fun
fprint_prtcl : fprint_type(prtcl)
//
overload print with print_prtcl
overload prerr with prerr_prtcl
overload fprint with fprint_prtcl
//
(* ****** ****** *)
//
fun
prtcl_join
  (ps: prtclist): prtcl
and
prtcl_join_cons
  (p0: prtcl, ps: prtclist): prtcl
//
(* ****** ****** *)
//
abstype
channel_type(id:int) = ptr
typedef
channel(id:int) = channel_type(id)
//
(* ****** ****** *)
//
typedef
channel() = [id:int] channel_type(id)
//
(* ****** ****** *)
//
absvtype
protocol_vtype(id:int) = ptr
vtypedef
protocol(id:int) = protocol_vtype(id)
//
absvtype
pprotocol_vtype(id:int) = ptr
vtypedef
pprotocol(id:int) = pprotocol_vtype(id)
//
(* ****** ****** *)

vtypedef
protocol() = [id:int] protocol(id)
vtypedef
pprotocol() = [id:int] pprotocol(id)

(* ****** ****** *)

local

assume
protocol_vtype(id) = prtcl
assume
pprotocol_vtype(id) = prtcl

in
  // nothing
end // end of [local]

(* ****** ****** *)

fun{}
chanprot_elim_nil
{id:int}
(CH: channel(id), prot: protocol(id)): void

(* ****** ****** *)

fun
{a:t0p}
chanprot_bmsg_recv
{id:int}
(CH: channel(id), prot: &protocol(id) >> _): (a)

fun
{a:t0p}
chanprot_bmsg_skip
{id:int}
(CH: channel(id), prot: &protocol(id) >> _): void

fun
{a:t0p}
chanprot_bmsg_send
{id:int}
( CH: channel(id), prot: &protocol(id) >> _, x0: a): void

(* ****** ****** *)

fun{}
chanprot_bmsg_recv_int:
$d2ctype(chanprot_bmsg_recv<int>)
fun{}
chanprot_bmsg_send_int:
$d2ctype(chanprot_bmsg_send<int>)

(* ****** ****** *)

fun{}
chanprot_bmsg_recv_bool:
$d2ctype(chanprot_bmsg_recv<bool>)
fun{}
chanprot_bmsg_send_bool:
$d2ctype(chanprot_bmsg_send<bool>)

(* ****** ****** *)

fun
{a:t0p}
chanprot_conj_aneg
{id:int}
(CH: channel(id), prot: &protocol(id) >> _): void

fun
{a:t0p}
chanprot_conj_apos
{id:int}
(CH: channel(id), prot: &protocol(id) >> _, opt: int): void

(* ****** ****** *)

fun
{a:t0p}
chanprot_conj_mpos
{id:int}
( CH: channel(id)
, prot: &protocol(id) >> _): list0_vt(protocol(id))

fun
{a:t0p}
chanprot_conj_mneg
{id:int}
( CH: channel(id)
, prot: &protocol(id) >> _): list0_vt(pprotocol(id))

(* ****** ****** *)

(* end of [basics.sats] *)
