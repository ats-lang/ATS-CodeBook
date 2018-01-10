# Using GMP in ATS

This example presents a simple method for using GMP in ATS.
It also makes use of some timing functions for measuring performance.

The npm-based package *atscntrb-hx-intinf* contains some basic support
for doing arithmetic operations on integers of multiple precision. For
instance, one can use these operations to compute the 1000th power of
2 as well as the 1000th factorial. This package depends on another
npm-based package of the name *atscntrb-libgmp*, which is just a thin
API layer for various functions in the GMP library.

The following code gives a generic implementation of the famous
factorial function:

```ats
fun
{a:t0p}
gfact3(n: int): a =
product<a>
(stream_vt_map_cloptr
 (streamize_intrange_lr<>(0, n), lam(i) => gnumber_int<a>(i+1))
) (* end of [gfact3] *)
```

where the function ```product``` (for computing the product of the numbers
in a given linear stream) is defined as follows:

```ats
fun
{a:t0p}
product
(xs: stream_vt(a)): a = let
//
overload * with gmul_val_val
//
fun
loop
(xs: stream_vt(a), r0: a): a =
(
case+ !xs of
| ~stream_vt_nil() => r0
| ~stream_vt_cons(x0, xs) => loop(xs, r0*x0)
)
//
in
  loop(xs, gnumber_int<a>(1))
end // end of [product]
```

We can simply load the package *atscntrb-hx-intinf*
to test ```gfact3``` for the type ```intinf```:

```ats
#include
"$PATSHOMELOCS\
/atscntrb-hx-intinf/mylibies.hats"
typedef intinf = $GINTINF_t.intinf
overload print with $GINTINF_t.print_intinf
//
  val N = 1000
  val r3 =
  my_time_spent<intinf>(lam()=>gfact3<a>(N))
  val () = println! ("gfact3(", N, ") = ", r3)
//
```

The function ```my_time_spent``` is defined as follows
for measuring the time spent on calling its argument
(which is a nullary closure-function):

```ats
#include
"$PATSHOMELOCS\
/atscntrb-hx-mytesting/mylibies.hats"

fun
{a:t0p}
my_time_spent
(
f0: cfun(a)
) : a = $TIMING.time_spent_cloref<a>(f0)
```

The npm-based package *atscntrb-hx-mytesting* contains a few
simple timing functions based on the ```clock``` system call.
  
Happy programming in ATS!!!
