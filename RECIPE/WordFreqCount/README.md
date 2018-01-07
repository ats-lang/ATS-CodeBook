# Counting Words

This example gives a stream-based implementation that counts words
in a given on-line source and then sort these words according to they
frequencies.

We need a small package of the name *atscntrb-hx-teaching-bucs* to
turn the source referred to by a URL into a linear stream of
characters.  This package can be downloaded by executing
```make npm-install``` or by issuing the following command-line:

```shell
npm install atscntrb-hx-teaching-bucs
```

We can implement a function ```stream_by_url_``` based on one of the
name ```stream_by_command``` in the downloaded package:
  
```ats
local

#include
"$PATSHOMELOCS\
/atscntrb-hx-teaching-bucs/mylibies.hats"

#staload
BUCS520 =
$BUCS520_2016_FALL

in

extern
fun
stream_by_url_
(url: string): stream_vt(char)

implement
stream_by_url_(url) =
$BUCS520.stream_by_command<>
  ("wget", $list{string}("-q", "-O", "-", url))

end // end of [local]
```

The function ```stream_by_url_``` calls the command ```wget```
(with some options) to fetch the source referred to by a given URL.
One can of course try to implement ```stream_by_url_``` based
on the command ```curl``` as well.

Given a list of words ordered ascendingly
(according to the standard lexicographic ordering),
the following function returns a list of pairs where
each pair consists of a number and a distinct word
such that the number indicates the number of times
the word occurring in the original given list of words:

```ats
extern
fun
list_vt_word2nword
(ws: List_vt(word)): List0_vt(nword)
```

Probably the most interesting function in this example is the following
one that turns a linear stream of chars into a linear stream of words:

```ats
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
```

Note that each word is just a non-empty sequence of letters in the
English alphabet. Also, each word in the returned stream consists of
only lowercase letters.
        
Happy programming in ATS!!!
