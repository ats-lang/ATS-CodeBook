# Read from STDIN (2)

If you have not yet read [ReadFromSTDIN2](./ReadFromSTDIN2), please
do so first.

The code in this example does essentially the same as the code in
[ReadFromSTDIN2](./ReadFromSTDIN2) except for using the ALARM signal
to prevent the possible scenario of waiting indefinitely for the
user's input.

The types ```line``` and ```lineto``` are defined as follows:

```ats

typedef
line = string

datavtype
lineto =
| LNTOline of Strptr1
| LNTOtimeout of ((*void*))

```

A lineto-value is linear and it represents either a line
(```LNTOline```) or a timeout (```LNTOtimeout```).  The following
function ```stream_vt_lineto2line``` turns a linear stream of
lineto-values into a linear stream of lines:


```ats
fun
stream_vt_lineto2line
(
xs:
stream_vt(lineto)
) : stream_vt(line) = $ldelay
(
case+ !xs of
| ~stream_vt_nil() =>
   stream_vt_nil()
| ~stream_vt_cons(x0, xs) =>
  (
    case+ x0 of
    | ~LNTOline(line) =>
       stream_vt_cons
       ( strptr2string(line)
       , stream_vt_lineto2line(xs))
    | ~LNTOtimeout((*void*)) =>
       (~(xs); stream_vt_nil((*void*)))
  )
, lazy_vt_free(xs)
)
```

In the package *atscntrb-hx-teaching-bucs*, there is a function of the
name ```streamize_fileref_lineto``` that turns the content of a given
file handle into a linear stream of lineto-values. If reading from the
file handle is blocked for more than ```nwait``` seconds, where
```nwait``` is the second argument of ```streamize_fileref_lineto```,
then ```LNTOtimeout()``` is added into the stream.  Otherwise,
```LNTOtimeout(l0)``` is added into the stream for some linear string
```l0```.

```ats
fun
streamize_fileref_line_
(
  inp: FILEref
) : stream_vt(line) =
(
stream_vt_lineto2line
(streamize_fileref_lineto<>(inp, 5(*nwait=5sec*)))
)
```


Happy programming in ATS!!!
