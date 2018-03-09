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

all:: NDX100_dats

######

testall:: npm-install
testall:: all cleanall

######
#
NDX100_dats: \
NDX100.dats; \
$(PATSCC) -I./node_modules \
  -D_GNU_SOURCE -DATS_MEMALLOC_LIBC -o $@ $< -latslib -ljson-c
#
######

clean:: ; rm -f *~
clean:: ; rm -f *_?ats.o
clean:: ; rm -f *_?ats.c

cleanall:: clean
cleanall:: ; rm -f NDX100_dats
cleanall:: ; rm -f node_modules -r
cleanall:: ; rm -f package-lock.json

######

npm-update:: ; $(NPM) update
npm-install:: ; $(NPM) install

######

export \
PATSHOMELOCS = \
./node_modules:./../node_modules:./../../node_modules:./../../../node_modules

###### end of [Makefile] ######
