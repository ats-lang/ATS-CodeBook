# Guessing a chosen number

The code should be self-explanatory.

The state of the game is modeled as
a pair of integers (representing a range
containing the number chosen by the player).

The input from the player is first modeled
as a linear stream (of linear strings) and
then converted of a linear stream of responses
(where each response is essentially an integer).

The following function updates the state of the
game based the current response from the player:
  
```ats
fun
stateUpdate
( s0: !state >> _
, r0: resp): void =
let
  val+
  @State(L, H) = s0
in
//
fold@(s0) where
{
val () =
  case+ r0 of
  | Okay() => ()
  | Lower() => H := (L+H)/2-1
  | Higher() => L := (L+H)/2+1
  | Error() => ()
}
//
end // end of [stateUpdate]
```

Note that The code in this example for handling input does essentially
the same as the code in [ReadFromSTDIN](./../ReadFromSTDIN).
  
Happy programming in ATS!!!
