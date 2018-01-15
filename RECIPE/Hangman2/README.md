# Hangman (2)

If you have not yet read [Hangman](./Hangman), please
do so first.

The following code builds a stream of input chars based
a simple web service provided at
[http://cs320.herokuapp.com](http://cs320.herokuapp.com):


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
  ((*void*)) = let
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
cs: List0_vt(string)
) : List0_vt(string) =
(
case+ xs of
| list_nil() =>
  (list_vt_reverse(cs))
| list_cons(x0, xs) => let
    val-JSONstring(x0) = x0
    val i0 = $STDLIB.atoi(x0)
  in
    if
    i0 <= n0
    then
    list_vt_reverse(cs)
    else
    auxone2(n0, xs, list_vt_cons(x0, cs))
  end // end of [list_cons]
)
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
    val _ = $UNISTD.sleep(1)
  }
| ~list_vt_cons
    (x0, xs) =>
    stream_vt_cons(x0, auxjoin2(x0, xs))
//
end // end of [auxjoin_con]
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
in
//
let
  val
  output =
  stream_by_url_(Channel00Clearall)
  val
  ((*freed*)) =
  list_vt_free(stream2list_vt(output)) in auxjoin(0)
end (* end of [let] *)
//
end // end of [streamize_channel00]

end // end of [local]
```

The player can use the following function
to input letters:


```ats
local
//
#staload
STDLIB = "libats/libc/SATS/stdlib.sats"
//
#define
Channel00Insert
"http://cs320.herokuapp.com/api/channel00/insert"
//
in (* in-of-local *)

extern
fun
GameKeyboard(): void

implement
GameKeyboard() =
{
//
fun
auxmain
(
lines:
stream_vt(string)
) : void =
(
//
case+ !lines of
| ~stream_vt_nil
   () => ()
| ~stream_vt_cons
   (line, lines) =>
  (
   if
   isneqz(line)
   then let
//
     val url =
     string_append3
     (Channel00Insert, "/", line)
     val err =
     $STDLIB.system
     ("wget -q -O - " + url + " > /dev/null")
   in
      auxmain(lines)
   end // end of [then]
   else
   (
      auxmain(lines)
   ) (* end of [else] *)
  )
//
) (* end of [auxmain] *)
//
val () =
auxmain(streamize_fileref_line(stdin_ref))
//
} (* end of [GameKeyboard] *)

end // end of [local]
```

Happy programming in ATS!!!
