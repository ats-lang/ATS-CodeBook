# Read from STDIN

One can certainly use ```scanf``` to read from
the standard input (STDIN). What I would like to
present in this example is the idea of treating
STDIN as a linear stream of lines (where each line
is represented as a string). For instance, the
following function ```echo``` prints onto the standard
output each line read from the standard input:

```ats
fun
echo() = let
  fun
  loop(xs: stream_vt(string)): void =
  (
    case+ !xs of
    | ~stream_vt_nil() => ()
    | ~stream_vt_cons(x, xs) => (println!(x); loop(xs))
  )
in
  loop(streamize_fileref_line(stdin_ref))
end //  end of [echo]
```
  
Happy programming in ATS!!!
