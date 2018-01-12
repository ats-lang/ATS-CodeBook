# Hangman

Hangman is a simple word-guessing game.  The program chooses a word in
some random fashion and then gives the player a fixed number of
chances to guess the word. The player can guess one letter each time;
if the letter does not appear in the word, then the player loses a
chance; otherwise, each occurrence of the letter is displayed and the
player do not lose a chance. The player loses if all of the given
chances are used up, or the player wins after all of the letters in
the word are correctly guessed.

The function `GameLoop` implements a standard loop for playing the game:

```ats
(* ****** ****** *)
//
extern
fun
GameLoop
(&state >> _, stream_vt(input)): int
and
GameLoop_solved
(&state >> _, stream_vt(input)): int
and
GameLoop_timeup
(&state >> _, stream_vt(input)): int
and
GameLoop_asking
(&state >> _, stream_vt(input)): int
//
(* ****** ****** *)

implement
GameLoop
(state, xs) = let
//
val
status = state_check(state)
//
in
  case+ status of
  | STATUSsolved() => GameLoop_solved(state, xs)
  | STATUStimeup() => GameLoop_timeup(state, xs)
  | STATUSasking() => GameLoop_asking(state, xs)
end // end of [GameLoop]
```

Note that `GameLoop` takes two arguments: The first argument refers
to the current state of the game being played and the second one is
a linear stream representing inputs from the player. The state is updated
according to the current input from the player:

```
implement
GameLoop_asking
  (state, xs) = let
//
val () =
println!
("Chances: ", state.ntime)
val () =
word_display
(state.word0, state.guess)
//
val () = println!((*void*))
//
in
//
case+ !xs of
| ~stream_vt_nil() => (~1) where
  {
    val () =
    println! ("ERROR: there is no input from the player!!!")
  }
| ~stream_vt_cons(x0, xs) =>
  let
    val err =
    state_update(state, x0) in GameLoop(state, xs)
  end
//
end // end of [GameLoop_asking]
```


Happy programming in ATS!!!
