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

local

(* ****** ****** *)

#define ssint SSDTint
#define ssbool SSDTbool
#define sslist SSDTlist

(* ****** ****** *)

#define ssbmsg PRTCLbmsg
//
#define ssjoin PRTCLjoin
//
#define sslazy PRTCLlazy
//
#define ssaconj PRTCLaconj
#define ssmconj PRTCLmconj

(* ****** ****** *)

in

extern
fun
myprtcl(): prtcl
implement
myprtcl() = ssjoin
(
list0_tuple<prtcl>
( ssbmsg(0, ssint), ssbmsg(0, ssint)
, ssbmsg(1, ssint), ssbmsg(2, ssint)
)
)

end // end of [local]

(* ****** ****** *)
//
#include
"$PATSHOMELOCS\
/atscntrb-hx-libjson-c/mylibies.hats"
#include
"$PATSHOMELOCS\
/atscntrb-hx-libjson-c/mylibies_link.hats"
//
#staload $JSON_ML
//
(* ****** ****** *)
//
#include
"$PATSHOMELOCS\
/atscntrb-hx-teaching-bucs/mylibies.hats"
//
(* ****** ****** *)
//
#define
Channel00Insert
"http://cs320.herokuapp.com/api/channel00/insert"
#define
Channel01Insert
"http://cs320.herokuapp.com/api/channel01/insert"
#define
Channel02Insert
"http://cs320.herokuapp.com/api/channel02/insert"
//
(* ****** ****** *)

#define
Channel00Readall
"http://cs320.herokuapp.com/api/channel00/readall"
#define
Channel01Readall
"http://cs320.herokuapp.com/api/channel01/readall"
#define
Channel02Readall
"http://cs320.herokuapp.com/api/channel02/readall"

#define
Channel00Clearall
"http://cs320.herokuapp.com/api/channel00/clearall"
#define
Channel01Clearall
"http://cs320.herokuapp.com/api/channel01/clearall"
#define
Channel02Clearall
"http://cs320.herokuapp.com/api/channel02/clearall"

(* ****** ****** *)
//
extern
fun
channel00_insert_msg
  (msg: string): void
implement
channel00_insert_msg
  (msg) = let
  val opt =
  $BUCS520.streamopt_url_char<>
  (string_append3
    (Channel00Insert, "/", msg))
in
  case+ opt of
  | ~None_vt() => ()
  | ~Some_vt(cs) => free(stream2list_vt(cs))
end // end of [channel00_insert_msg]
//
extern
fun
channel01_insert_msg
  (msg: string): void
implement
channel01_insert_msg
  (msg) = let
  val opt =
  $BUCS520.streamopt_url_char<>
  (string_append3
    (Channel01Insert, "/", msg))
in
  case+ opt of
  | ~None_vt() => ()
  | ~Some_vt(cs) => free(stream2list_vt(cs))
end // end of [channel01_insert_msg]
//
extern
fun
channel02_insert_msg
  (msg: string): void
implement
channel02_insert_msg
  (msg) = let
  val opt =
  $BUCS520.streamopt_url_char<>
  (string_append3
    (Channel02Insert, "/", msg))
in
  case+ opt of
  | ~None_vt() => ()
  | ~Some_vt(cs) => free(stream2list_vt(cs))
end // end of [channel02_insert_msg]
//
(* ****** ****** *)

local
//
assume
channel_type(id) = list0(int)
//
in (* nothing *) end

(* ****** ****** *)

local

reassume channel_type

fun{}
ismem
(
CH:
channel(), r0: role
) : bool = loop(CH) where
{
fun
loop(rs: list0(int)): bool =
(
case+ rs of
| list0_nil() => false
| list0_cons(r1, rs) =>
  if r0 = r1 then true else loop(rs)
)
}

fun{}
jsonval_int
(x: int) = JSONint(g0i2i(x))

in

implement
{}(*tmp*)
chanrole_bmsg_send_int
  (CH, r, x) = let
//
val tf = ismem<>(CH, r)
//
val () =
if (tf)
then ()
else let
  val () =
  prerrln!
  ("chanrole_bmsg_send_int: non-send")
in
  assertloc(false)
end // end of [if]
//
in
//
ifcase
| (r = 0) =>
  {
    val msg = 
    jsonval_tostring(jsonval_int(x))
    val ((*send*)) =
    channel00_insert_msg($UN.strptr2string(msg))
    val ((*freed*)) = strptr_free(msg)
  }
| (r = 1) => 
  {
    val msg = 
    jsonval_tostring(jsonval_int(x))
    val ((*send*)) =
    channel01_insert_msg($UN.strptr2string(msg))
    val ((*freed*)) = strptr_free(msg)
  }
| (r = 2) => 
  {
    val msg = 
    jsonval_tostring(jsonval_int(x))
    val ((*send*)) =
    channel02_insert_msg($UN.strptr2string(msg))
    val ((*freed*)) = strptr_free(msg)
  }
| _(* else *) =>
  let
    val () =
    prerrln!("chanrole_bmsg_send_int: r = ", r)
  in
    let val () = assertloc(false) in ((*void*)) end
    // end of [if]
  end (* end of [let] *)
//
end // chanrole_bmsg_send_int

end // end of [local]

(* ****** ****** *)

#staload
UN = "prelude/SATS/unsafe.sats"
#staload
STDLIB = "libats/libc/SATS/stdlib.sats"
#staload
UNISTD = "libats/libc/SATS/unistd.sats"

(* ****** ****** *)

abstype chanraw_type = ptr
typedef chanraw = chanraw_type

(* ****** ****** *)
//
extern
fun{}
linenum_get(string): int
//
implement
{}(*tmp*)
linenum_get
  (line) = $STDLIB.atoi(line)
//
(* ****** ****** *)
//
// HX-2018-01-16:
// [chanraw_readall]
// returns a representation of
// a JSON-array of JSON-strings
//
extern
fun{}
chanraw_readall
  (ch: chanraw): Option_vt(string)
//
(* ****** ****** *)
//
extern
fun{}
chanraw_readall_pause(chanraw): void
//
implement
{}(*tmp*)
chanraw_readall_pause
  (ch) =
  ignoret($UNISTD.usleep(1000000))
//
(* ****** ****** *)
//
extern
fun{}
streamize_chanraw
  (ch: chanraw): stream_vt(string)
extern
fun{}
streamize_chanraw_gte
  (ch: chanraw, n0: int): stream_vt(string)
//
(* ****** ****** *)
//
implement
{}(*tmp*)
streamize_chanraw
  (ch) =
(
streamize_chanraw_gte<>(ch, 0(*n0*))
)
//
(* ****** ****** *)

implement
{}(*tmp*)
streamize_chanraw_gte
  (ch, n0) =
  auxjoin(0) where
{
//
fun
auxone
(n0: int):
List0_vt(string) = let
//
val opt =
chanraw_readall<>(ch)
//
in
//
case+ opt of
| ~None_vt() =>
   list_vt_nil()
| ~Some_vt(jsn) => let
    val jsv =
    jsonval_ofstring(jsn)
  in
    case+ jsv of
    | JSONarray(jsvs) =>
      auxone_arr(n0, jsvs, list_vt_nil)
    | _ (*non-JSONarray*) => list_vt_nil()
  end // end of [Some_vt]
//
end // end of [auxone]
//
and
auxone_arr
(
n0: int
,
xs: jsonvalist
,
cs: List0_vt(string)
) : List0_vt(string) =
(
case+ xs of
| list_nil() => cs
| list_cons(x0, xs) => let
    val-JSONstring(x0) = x0
    val i0 = linenum_get<>(x0)
  in
    if
    i0 <= n0
    then (cs)
    else
    auxone_arr(n0, xs, list_vt_cons(x0, cs))
  end // end of [list_cons]
) (* end of [auxone_arr] *)
//
fun
auxjoin
(
n0: int
) :
stream_vt(string) =
$ldelay(auxjoin_con(n0))
//
and
auxjoin_con
(
n0: int
) :
stream_vt_con(string) =
let
  val xs = auxone(n0)
in
//
case+ xs of
| ~list_vt_nil
    () =>
    auxjoin_con(n0) where
  {
    val () =
    chanraw_readall_pause<>(ch)
  }
| ~list_vt_cons
    (x0, xs) =>
    stream_vt_cons(x0, auxjoin_lst(x0, xs))
//
end // end of [auxjoin_con]
//
and
auxjoin_lst
(
x0: string
,
xs: List0_vt(string)
) : stream_vt(string) = $ldelay
(
(
case+ xs of
| ~list_vt_nil
    () => !
    (auxjoin($STDLIB.atoi(x0)))
| ~list_vt_cons
    (x1, xs) =>
    stream_vt_cons(x1, auxjoin_lst(x1, xs))
), (list_vt_free(xs))
)
//
} (* end of [streamize_chanraw_gte] *)

(* ****** ****** *)

local

fun
auxproc
(
xs: stream_vt(string)
) : stream_vt(string) =
stream_vt_map<string><string>
  (xs) where
{
//
implement
stream_vt_map$fopr<string><string>
  (x) =
  trunc(string2ptr(x)) where
{
//
fun
trunc(p0: ptr): string = let
//
val c0 = $UN.ptr0_get<char>(p0)
//
in
//
if
iseqz(c0)
then "" else
(
if
(c0 != ':')
then
trunc(ptr_succ<char>(p0))
else
$UN.cast{string}(ptr_succ<char>(p0))
)
//
end // end of [trunc]
} (* end of [stream_vt_map$fopr] *)
}

in

fun
streamize_channel00
(
// argless
) : stream_vt(string) = let
//
val
CH0 = $UN.cast{chanraw}(0)
//
implement
chanraw_readall<>(ch) = let
  val opt =
  $BUCS520.streamopt_url_char<>
    (Channel00Readall)
in
  case+ opt of
  | ~None_vt() =>
     None_vt()
  | ~Some_vt(xs) =>
     Some_vt
     (strptr2string
      (string_make_stream_vt($UN.castvwtp0(xs)))
     ) (* end of [Some_vt] *)
end // end of [chanraw_readall]
//
in
  auxproc(streamize_chanraw<>(CH0))
end // end of [streamize_channel00]

(* ****** ****** *)

fun
streamize_channel01
(
// argless
) : stream_vt(string) = let
//
val
CH1 = $UN.cast{chanraw}(1)
//
implement
chanraw_readall<>(ch) = let
  val opt =
  $BUCS520.streamopt_url_char<>
    (Channel01Readall)
in
  case+ opt of
  | ~None_vt() =>
     None_vt()
  | ~Some_vt(xs) =>
     Some_vt
     (strptr2string
      (string_make_stream_vt($UN.castvwtp0(xs)))
     ) (* end of [Some_vt] *)
end // end of [chanraw_readall]
//
in
  auxproc(streamize_chanraw<>(CH1))
end // end of [streamize_channel01]

fun
streamize_channel02
(
// argless
) : stream_vt(string) = let
//
val
CH2 = $UN.cast{chanraw}(2)
//
implement
chanraw_readall<>(ch) = let
  val opt =
  $BUCS520.streamopt_url_char<>
    (Channel02Readall)
in
  case+ opt of
  | ~None_vt() =>
     None_vt()
  | ~Some_vt(xs) =>
     Some_vt
     (strptr2string
      (string_make_stream_vt($UN.castvwtp0(xs)))
     ) (* end of [Some_vt] *)
end // end of [chanraw_readall]
//
in
  auxproc(streamize_chanraw<>(CH2))
end // end of [streamize_channel02]

end // end of [local]

(* ****** ****** *)

extern
fun
channel00_clearall
  ((*void*)): void
implement
channel00_clearall
  ((*void*)) = let
  val opt =
  $BUCS520.streamopt_url_char<>
    (Channel00Clearall)
in
  case+ opt of
  | ~None_vt() => ()
  | ~Some_vt(cs) => free(stream2list_vt(cs))
end // end of [channel00_clearall]

extern
fun
channel01_clearall
  ((*void*)): void
implement
channel01_clearall
  ((*void*)) = let
  val opt =
  $BUCS520.streamopt_url_char<>
    (Channel01Clearall)
in
  case+ opt of
  | ~None_vt() => ()
  | ~Some_vt(cs) => free(stream2list_vt(cs))
end // end of [channel01_clearall]

extern
fun
channel02_clearall
  ((*void*)): void
implement
channel02_clearall
  ((*void*)) = let
  val opt =
  $BUCS520.streamopt_url_char<>
    (Channel02Clearall)
in
  case+ opt of
  | ~None_vt() => ()
  | ~Some_vt(cs) => free(stream2list_vt(cs))
end // end of [channel02_clearall]

(* ****** ****** *)

local

val
theCH00 =
ref<ptr>(the_null_ptr)
val
theCH01 =
ref<ptr>(the_null_ptr)
val
theCH02 =
ref<ptr>(the_null_ptr)

in

(* ****** ****** *)
//
extern
fun
channel00_pop_msg
((*void*)): string
extern
fun
channel01_pop_msg
((*void*)): string
extern
fun
channel02_pop_msg
((*void*)): string
//
(* ****** ****** *)

implement
channel00_pop_msg
  ((*void*)) = let
//
val p0 = theCH00[]
//
in
  if
  isneqz(p0)
  then let
    val xs =
    $UN.castvwtp0{stream_vt(string)}(p0)
  in
    case- !xs of
    | ~stream_vt_cons(x0, xs) => x0 where
      {
        val () =
        theCH00[] := $UN.castvwtp0{ptr}(xs)
      }
  end // end of [then]
  else let
    val xs =
    streamize_channel00()
    val () =
    theCH00[] :=
    $UN.castvwtp0{ptr}(xs) in channel00_pop_msg()
  end // end of [else]
end // end of [channel00_pop_msg]

implement
channel01_pop_msg
  ((*void*)) = let
//
val p0 = theCH01[]
//
in
  if
  isneqz(p0)
  then let
    val xs =
    $UN.castvwtp0{stream_vt(string)}(p0)
  in
    case- !xs of
    | ~stream_vt_cons(x0, xs) => x0 where
      {
        val () = theCH01[] := $UN.castvwtp0{ptr}(xs)
      }
  end // end of [then]
  else let
    val xs =
    streamize_channel01()
    val () =
    theCH01[] := $UN.castvwtp0{ptr}(xs) in channel01_pop_msg()
  end // end of [else]
end // end of [channel01_pop_msg]

implement
channel02_pop_msg
  ((*void*)) = let
//
val p0 = theCH02[]
//
in
  if
  isneqz(p0)
  then let
    val xs =
    $UN.castvwtp0{stream_vt(string)}(p0)
  in
    case- !xs of
    | ~stream_vt_cons(x0, xs) => x0 where
      {
        val () = theCH02[] := $UN.castvwtp0{ptr}(xs)
      }
  end // end of [then]
  else let
    val xs =
    streamize_channel02()
    val () =
    theCH02[] := $UN.castvwtp0{ptr}(xs) in channel02_pop_msg()
  end // end of [else]
end // end of [channel02_pop_msg]

end // end of [local]
//
(* ****** ****** *)

local
//
reassume channel_type
//
(* ****** ****** *)
 
fun{}
ismem
(
CH:
channel(), r0: role
) : bool = loop(CH) where
{
fun
loop(rs: list0(int)): bool =
(
case+ rs of
| list0_nil() => false
| list0_cons(r1, rs) =>
  if r0 = r1 then true else loop(rs)
)
}

fun{}
jsonval_int
(x: int) = JSONint(g0i2i(x))

in

implement
{}(*tmp*)
chanrole_bmsg_recv_int
  (CH, r) = let
//
val tf = ismem<>(CH, r)
//
val () =
if (tf)
then let
  val () =
  prerrln!
  ("chanrole_bmsg_recv_int: non-recv")
in
  assertloc(false)
end // end of [if]
//
in
//
ifcase
| (r = 0) =>
  $UN.cast{int}(x) where
  {
    val msg = channel00_pop_msg()
    val-JSONint(x) = jsonval_ofstring(msg)
  }
| (r = 1) =>
  $UN.cast{int}(x) where
  {
    val msg = channel01_pop_msg()
    val-JSONint(x) = jsonval_ofstring(msg)
  }
| (r = 2) =>
  $UN.cast{int}(x) where
  {
    val msg = channel02_pop_msg()
    val-JSONint(x) = jsonval_ofstring(msg)
  }
| _(* else *) =>
  let
    val () =
    prerrln!("chanrole_bmsg_recv_int: r = ", r)
  in
    let val () = assertloc(false) in $UN.cast{int}(0) end
    // end of [if]
  end (* end of [let] *)
//
end // chanrole_bmsg_recv_int

end // end of [local]

(* ****** ****** *)

(* end of [mybasis.dats] *)
