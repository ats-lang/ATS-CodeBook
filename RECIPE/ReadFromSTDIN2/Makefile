######
#
# A simple Makefile
#
######
#
# HX-2018-01-05:
# PATSHOME is environmental
#
######

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt
PATSLIB=$(PATSHOME)/ccomp/atslib

######

all:: ReadFromSTDIN2_dats

######

testall:: all
testall:: regress
testall:: cleanall

######

%_dats: %.dats; $(PATSCC) -DATS_MEMALLOC_LIBC -o $@ $< -latslib

######

regress:: ReadFromSTDIN2_dats; ./$<

######

clean:: ; rm -f *~
clean:: ; rm -f *_?ats.o
clean:: ; rm -f *_?ats.c

cleanall:: clean
cleanall:: ; rm -f ReadFromSTDIN2_dats

###### end of [Makefile] ######
