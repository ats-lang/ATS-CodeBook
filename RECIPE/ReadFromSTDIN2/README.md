# Read from STDIN (2)

If you have not yet read [ReadFromSTDIN](./ReadFromSTDIN), please
do so first.

The code in this example does essentially the same as the
code in [ReadFromSTDIN](./ReadFromSTDIN), but it is written in a
different style, which greatly stresses the use of combinators in
functional programming.

The following function ```prompts``` returns a linear stream of
integers:
  
```ats
fun
prompts
(
// argless
) : stream_vt(int) =
stream_vt_map_cloptr<int><int>
( xs
, lam(i) =>
  (println!("Please input an integer or type Ctrl-D:"); i)
) where
{
  val xs = intGte_stream_vt(0)
}
```

For each integer in the stream to be computed, a message (for the
purpose of prompting the user) is printed onto the standard output.

The function ```tally``` can be given the following combinator-based
implementation:


```ats
fun
tally() = let
  val ps = prompts()
  val xs =
  streamize_fileref_line(stdin_ref)
  val xs =
  (xs).filter()(lam(x) => isneqz(x))
  val xs =
  stream_vt_map2_cloptr<int,string><int>(ps, xs, lam(p, x) => g0string2int(x))
in
  stream_vt_foldleft_cloptr<int><int>(xs, 0, lam(r, x) => r + x)
end // end of [tally]
```

Happy programming in ATS!!!
