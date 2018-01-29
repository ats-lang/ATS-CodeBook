(* ****** ****** *)
(*
** A Tokenizer
** based on linear streams
*)
(* ****** ****** *)

#include
"share/atspre_staload.hats"
#include
"share/atspre_staload_libats_ML.hats"

(* ****** ****** *)

#staload UN = $UNSAFE

(* ****** ****** *)

datatype token =
  | TOKide of string // ide=alpha[alnum]*
  | TOKint of string // int=digit[digit]*
  | TOKchr of (char) // special character

(* ****** ****** *)

extern
fun
print_token: print_type(token)
extern
fun
fprint_token: fprint_type(token)

overload print with print_token
overload fprint with fprint_token

(* ****** ****** *)

implement
print_token(tok) =
fprint_token(stdout_ref, tok)

implement
fprint_token(out, tok) =
(
case+ tok of
| TOKint(int) =>
  fprint!(out, "TOKint(", int, ")")
| TOKide(ide) =>
  fprint!(out, "TOKide(", ide, ")")  
| TOKchr(chr) =>
  fprint!(out, "TOKchr(", chr, ")")  
)

(* ****** ****** *)
//
extern
fun
tokenize
(cs: stream_vt(char)): stream_vt(token)
//
(* ****** ****** *)

local

fun
aux1
(
c0: char
,
cs: stream_vt(char)
) :
stream_vt_con(token) =
(
ifcase
| isalpha(c0) =>
  aux1_ide(cs, list_vt_sing(c0))
| isdigit(c0) =>
  aux1_int(cs, list_vt_sing(c0))
| _(* else *) =>
  stream_vt_cons(TOKchr(c0), tokenize(cs))
)

and
aux1_ide
(
cs:
stream_vt(char)
,
ds: List0_vt(char)
) : stream_vt_con(token) =
(
case+ !cs of
| ~stream_vt_nil
    () => let
    val ide =
    string_make_rlist_vt(ds)
  in
    stream_vt_sing(TOKide(ide))
  end // end of [stream_vt_nil]
| ~stream_vt_cons
    (c0, cs) =>
  (
    ifcase
    | isalnum(c0) =>
      aux1_ide(cs, list_vt_cons(c0, ds))
    | _(* else *) => let
        val ide =
        string_make_rlist_vt(ds)
      in
        stream_vt_cons(TOKide(ide), $ldelay(aux1(c0, cs), ~cs))
      end
  )
)

and
aux1_int
(
cs:
stream_vt(char)
,
ds: List0_vt(char)
) : stream_vt_con(token) =
(
case+ !cs of
| ~stream_vt_nil
    () => let
    val int =
    string_make_rlist_vt(ds)
  in
    stream_vt_sing(TOKint(int))
  end // end of [stream_vt_nil]
| ~stream_vt_cons
    (c0, cs) =>
  (
    ifcase
    | isalpha(c0) => let
        val int =
        string_make_rlist_vt(ds)
      in
        stream_vt_cons
        ( TOKint(int)
        , $ldelay(aux1_ide(cs, list_vt_sing(c0)), ~cs)
        )
      end // end of [isalpha]
    | isdigit(c0) =>
      aux1_int(cs, list_vt_cons(c0, ds))
    | _(* else *) => let
        val int =
        string_make_rlist_vt(ds)
      in
        stream_vt_cons(TOKint(int), $ldelay(aux1(c0, cs), ~cs))
      end
  )
)

in

implement
tokenize(cs) = $ldelay
(
case+ !cs of
| ~stream_vt_nil() =>
   stream_vt_nil()
| ~stream_vt_cons(c0, cs) => aux1(c0, cs)
, lazy_vt_free(cs)
)

end // end of [local]

(* ****** ****** *)

implement
main0() = let
//
val
toks =
tokenize
(streamize_fileref_char(stdin_ref))
//
in
  stream_vt_foreach_cloptr
  (toks, lam(tok) => println! ("tok = ", tok))
end // end of [main0]

(* ****** ****** *)

(* end of [Tokenizer.dats] *)
