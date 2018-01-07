(* ****** ****** *)

#include "share/atspre_staload.hats"
#include "share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

typedef word = string
typedef nword = (int, string)

(* ****** ****** *)

extern
fun
print_free_nwordlst
( N: int
, nws: List_vt(nword)): void

implement
print_free_nwordlst(N, nws) =
  if
  N <= 0
  then
  (
    list_vt_free<nword>(nws)
  )
  else
  (
    case+ nws of
    | ~list_vt_nil() => ()
    | ~list_vt_cons(nw, nws) =>
      (
        println!(nw.1, " -> ", nw.0);
        print_free_nwordlst(N-1, nws)
      )
  )

(* ****** ****** *)

local

#include
"$PATSHOMELOCS\
/atscntrb-hx-teaching-bucs/mylibies.hats"
#include
"$PATSHOMELOCS\
/atscntrb-hx-teaching-bucs/mylibies_link.hats"

#staload
$BUCS520_2016_FALL // opening it

in

extern
fun
stream_by_url_
(url: string): stream_vt(char)

implement
stream_by_url_(url) =
stream_by_command<>
("wget", $list{string}("-q", "-O", "-", url))

end // end of [local]

(* ****** ****** *)

extern
fun
list_vt_word2nword
(ws: List_vt(word)): List0_vt(nword)

implement
list_vt_word2nword
  (ws) = let
  fun
  auxmain
  (
  w0: word
  ,
  ws: List_vt(word)
  ) : stream_vt(nword) =
  $ldelay(auxmain_con(1, w0, ws), free(ws))
  
  and
  auxmain_con
  (
  n0: int
  ,
  w0: word
  ,
  ws: List_vt(word)
  ) : stream_vt_con(nword) =
  (
    case+ ws of
    | ~list_vt_nil() =>
       stream_vt_sing<nword>((n0, w0))
    | ~list_vt_cons(w1, ws) =>
       if w1 <= w0
         then auxmain_con(n0+1, w1, ws)
         else stream_vt_cons((n0, w0), auxmain(w1, ws))
       // end of [if]
  )
in
  case+ ws of
  | ~list_vt_nil() =>
     list_vt_nil()
  | ~list_vt_cons(w0, ws) =>
     stream2list_vt(auxmain(w0, ws))
end // end of [list_vt_word2nword]

(* ****** ****** *)

#define L(c) tolower(c)

(* ****** ****** *)

extern
fun
stream_vt_char2word
(cs: stream_vt(char)): stream_vt(word)

implement
stream_vt_char2word
  (cs) =
  auxmain(cs) where
{
  fun
  auxmain
  (
  cs: stream_vt(char)
  ) : stream_vt(word) =
  (
    case+ !cs of
    | ~stream_vt_nil() =>
       stream_vt_make_nil()
    | ~stream_vt_cons(c0, cs) =>
      (
       if isalpha(c0)
         then $ldelay
              (auxmain_con(cs, list_vt_sing(L(c0))), ~(cs))
         else auxmain(cs)
      )
  )
  
  and
  auxmain_con
  (
  cs: stream_vt(char), w0: List0_vt(char)
  ) : stream_vt_con(word) =
  (
    case+ !cs of
    | ~stream_vt_nil() =>
       stream_vt_sing(string_make_rlist_vt(w0))
    | ~stream_vt_cons(c1, cs) =>
      (
       if isalpha(c1)
         then auxmain_con(cs, list_vt_cons(L(c1), w0))
         else stream_vt_cons(string_make_rlist_vt(w0), auxmain(cs))
      )
  )
} (* end of [stream_vt_char2word] *)

(* ****** ****** *)

extern
fun
stream_vt_char2nword
  (cs: stream_vt(char)): List0_vt(nword)

(* ****** ****** *)

implement
stream_vt_char2nword(cs) = nws where
{
  val ws = stream_vt_char2word(cs)
  val ws = stream2list_vt<word>(ws)
  val ws = list_vt_mergesort_fun<word>(ws, lam(w1, w2) => compare(w1, w2))
  val nws = list_vt_word2nword(ws)
  val nws = list_vt_mergesort_fun<nword>(nws, lam(nw1, nw2) => ~compare(nw1.0, nw2.0))
}

(* ****** ****** *)
//
#define
MOBY_DICK
"http://www.gutenberg.org/files/2701/2701-0.txt"
//
(* ****** ****** *)

#define N 250

implement
main0(argc, argv) = let
  val url =
  (if argc >= 2
   then argv[1] else MOBY_DICK): string
  val output = stream_by_url_(url)
in
  print_free_nwordlst(N, stream_vt_char2nword(output)); exit(0)
end (* end of [main0] *)

(* ****** ****** *)

(* end of [WordFreqCount.dats] *)
