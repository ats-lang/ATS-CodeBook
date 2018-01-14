# Hangman

If you have not yet read [Hangman](./Hangman), please
do so first.

The following code builds a stream of input chars based
a simple web service provided at
[http://cs320.herokuapp.com](http://cs320.herokuapp.com).


```ats
local

#include
"$PATSHOMELOCS\
/atscntrb-libjson-c/mylibies.hats"
#include
"$PATSHOMELOCS\
/atscntrb-libjson-c/mylibies_link.hats"

#include
"$PATSHOMELOCS\
/atscntrb-hx-teaching-bucs/mylibies.hats"

#staload $JSON_ML

#staload
UN = "prelude/SATS/unsafe.sats"
#staload
STDLIB = "libats/libc/SATS/stdlib.sats"
#staload
UNISTD = "libats/libc/SATS/unistd.sats"

#staload
BUCS520 =
$BUCS520_2016_FALL

#define
Channel00Readall
"http://cs320.herokuapp.com/api/channel00/readall"
#define
Channel00Clearall
"http://cs320.herokuapp.com/api/channel00/clearall"

in (* in-of-local *)

implement
stream_by_url_(url) =
$BUCS520.stream_by_command<>
( "wget"
, $list{string}("-q", "-O", "-", url))

implement
streamize_channel00
  ((*void*)) =
  auxjoin(0) where
{
//
fun
auxone
(n0: int):
List0_vt(string) = let
//
val input =
stream_by_url_
(Channel00Readall)
val input =
string_make_stream_vt
($UN.castvwtp0(input))
val input =
  strptr2string(input)
//
val-
JSONarray(jsvs) =
jsonval_ofstring(input)
//
in
//
auxone2(n0, jsvs, list_vt_nil)
//
end // end [auxone]
//
and
auxone2
(
n0: int
,
xs: jsonvalist
,
r0: List0_vt(string)
) : List0_vt(string) =
(
case+ xs of
| list_nil() =>
  (list_vt_reverse(r0))
| list_cons(x0, xs) => let
    val-JSONstring(x0) = x0
    val i0 = $STDLIB.atoi(x0)
  in
    if
    i0 <= n0
    then
    list_vt_reverse(r0)
    else
    auxone2(n0, xs, list_vt_cons(x0, r0))
  end // end of [list_cons]
)
//
fun
auxjoin
(
n0: int
) :
stream_vt(string) =
let
  val xs = auxone(n0)
in
//
case+ xs of
| ~list_vt_nil
    () =>
    auxjoin(n0) where
  {
    val _ = $UNISTD.sleep(1)
  }
| ~list_vt_cons
    (x0, xs) =>
    stream_vt_make_cons(x0, auxjoin2(x0, xs))
//
end // end of [auxjoin]
//
and
auxjoin2
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
    stream_vt_cons(x1, auxjoin2(x1, xs))
), (list_vt_free(xs))
)
//
val
output =
stream_by_url_(Channel00Clearall)
val
((*freed*)) =
list_vt_free(stream2list_vt(output))
//
} // end of [streamize_channel00]

end // end of [local]
```

Happy programming in ATS!!!
