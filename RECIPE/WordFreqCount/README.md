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

        
Happy programming in ATS!!!
