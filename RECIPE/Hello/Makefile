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

all:: Hello_dats

######

testall:: all
testall:: regress
testall:: cleanall

######

regress:: Hello_dats; ./$<

######

%_dats: %.dats; $(PATSCC) -o $@ $<

######

clean:: ; rm -f *~
clean:: ; rm -f *_?ats.o
clean:: ; rm -f *_?ats.c

cleanall:: clean
cleanall:: ; rm -f Hello_dats

###### end of [Makefile] ######
