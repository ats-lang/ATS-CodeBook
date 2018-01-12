# Read from STDIN

One can certainly use `scanf` to read from
the standard input (STDIN). What I would like to
present in this example is the idea of treating
STDIN as a linear stream of lines (where each line
is represented as a string). For instance, the
following function `echo` prints onto the standard
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

The function `streamize_fileref_line` is often referred to as a
streamization function, which in this case turns a given file handle
(of the type `FILEref`) into a linear stream of strings such that
each string in the stream represents one line of input received from the
file handle.

The following function `tally` prompts the user to input integers
and then returns at the end the sum of all of the integers read from STDIN:

```ats
fun
tally(): int = let
  fun
  loop
  (xs: stream_vt(string), res: int): int =
  (
    case+ !xs of
    | ~stream_vt_nil() => res
    | ~stream_vt_cons(x, xs) =>
      let
        val () =
        if isneqz(x) then prompt()
      in
        loop(xs, res+g0string2int(x))
      end
  ) (* end of [loop] *)

  and
  prompt(): void =
  println!
  ("Please input more or type Ctrl-D:")
in
  println!("Please input one integer:");
  loop(streamize_fileref_line(stdin_ref), 0)
end // end of [tally]
```
Note that the function `isneqz` checks whether a
given string is empty and the function `g0string2int`
converts a given string into the int-value it represents.

As far as I can tell, linear streams are so far a programming feature
that is only available in ATS. I will gradually present more examples
involving linear streams.
  
Happy programming in ATS!!!
