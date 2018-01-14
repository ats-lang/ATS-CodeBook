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

all:: Hangman2_dats
regress:: Hangman2_dats; ./$<

######

testall:: npm-install
testall:: all regress cleanall

######
#
Hangman2_dats: \
Hangman2.dats; \
$(PATSCC) -I./node_modules \
  -DATS_MEMALLOC_LIBC -o $@ $< -latslib -ljson-c
#
######

clean:: ; rm -f *~
clean:: ; rm -f *_?ats.o
clean:: ; rm -f *_?ats.c

cleanall:: clean
cleanall:: ; rm -f Hangman2_dats
cleanall:: ; rm -f node_modules -r
cleanall:: ; rm -f package-lock.json

######

npm-update:: ; $(NPM) update
npm-install:: ; $(NPM) install

###### end of [Makefile] ######
