# Hangman (3)

If you have not yet read [Hangman](./Hangman), please
do so first.

This example gives an implementation of the Hangman game for two
communicating players, where the communication is done through two
web-based uni-directional channels that are untyped. The difficulty in
programming with such untyped channels strongly motivates the need
for typed channels where the types classifying channels are often
referred to as session types.

Player0 should start first, choosing a word and then sending out its
length. Player1 is given 6 chances to guess the word chosen by
Player0.  As the communication between Player0 and Player1 is based on
a simple web service, they can play on any two machines that have
access to the Internet.

Happy programming in ATS!!!
