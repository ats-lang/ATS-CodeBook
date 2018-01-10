# Using GMP in ATS

This example presents a simple method for using GMP in ATS.
It also makes use of some timing functions for measuring performance.

The npm-based package *atscntrb-hx-intinf* contains some basic support
for doing arithmetic operations on integers of multiple precision. For
instance, one can use these operations to compute the 1000th power of
2 as well as the 1000th factorial. This package depends on another
package of the name *atscntrb-libgmp*, which is just a thin API layer
for various functions in the GMP library.

Happy programming in ATS!!!
