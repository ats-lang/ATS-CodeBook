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

all:: ReadFromSTDIN3_dats

######

testall:: all
testall:: regress
testall:: cleanall

######

%_dats: %.dats; \
$(PATSCC) -DATS_MEMALLOC_LIBC -o $@ $< -latslib

######

regress:: ReadFromSTDIN3_dats; echo 1000000 | ./$<

######

clean:: ; rm -f *~
clean:: ; rm -f *_?ats.o
clean:: ; rm -f *_?ats.c

cleanall:: clean
cleanall:: ; rm -f ReadFromSTDIN3_dats
cleanall:: ; rm -f ./node_modules -r
cleanall:: ; rm -f ./package-lock.json

######

npm-update:: ; $(NPM) update
npm-install:: ; $(NPM) install

###### end of [Makefile] ######
