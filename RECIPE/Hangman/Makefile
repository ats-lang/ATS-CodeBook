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

NPM=npm

######

PATSCC=$(PATSHOME)/bin/patscc
PATSOPT=$(PATSHOME)/bin/patsopt
PATSLIB=$(PATSHOME)/ccomp/atslib

######

all:: Hangman_dats

######

testall:: all cleanall

######

%_dats: %.dats; \
$(PATSCC) -DATS_MEMALLOC_LIBC -o $@ $< -latslib

######

clean:: ; rm -f *~
clean:: ; rm -f *_?ats.o
clean:: ; rm -f *_?ats.c

cleanall:: clean
cleanall:: ; rm -f Hangman_dats

###### end of [Makefile] ######
