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

all:: WordFreqCount_dats

######

testall:: npm-install
testall:: all regress cleanall

######

%_dats: %.dats; $(PATSCC) -DATS_MEMALLOC_LIBC -o $@ $< -latslib

######

regress:: WordFreqCount_dats; ./$<

######

clean:: ; rm -f *~
clean:: ; rm -f *_?ats.o
clean:: ; rm -f *_?ats.c

cleanall:: clean
cleanall:: ; rm -f node_modules -r
cleanall:: ; rm -f package-lock.json
cleanall:: ; rm -f WordFreqCount_dats

######

npm-update:: ; $(NPM) update
npm-install:: ; $(NPM) install

###### end of [Makefile] ######
