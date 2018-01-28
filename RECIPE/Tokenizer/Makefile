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

CAT=cat

######

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt
PATSLIB=$(PATSHOME)/ccomp/atslib

######

all:: Tokenizer_dats

######

testall:: all regress cleanall

######

%_dats: %.dats; \
$(PATSCC) -DATS_MEMALLOC_LIBC -o $@ $< -latslib

######

regress:: Tokenizer_dats; $(CAT) ./Tokenizer.dats | ./$<

######

clean:: ; rm -f *~
clean:: ; rm -f *_?ats.o
clean:: ; rm -f *_?ats.c

cleanall:: clean
cleanall:: ; rm -f Tokenizer_dats

###### end of [Makefile] ######
