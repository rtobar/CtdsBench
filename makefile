ifeq ($(VENDOR),cray)
	MPICXX=cc
else
	MPICXX=mpic++
endif
ifeq ($(HAS_HDF5STMAN),)
	HAS_HDF5STMAN=yes
endif
ifeq ($(HAS_ADIOSSTMAN),)
	HAS_ADIOSSTMAN=yes
endif

CXX=$(MPICXX)
CXXFLAGS+=-std=c++11 -DHAVE_MPI
LDLIBS=-lcasa_tables -lcasa_casa

ifeq ($(HAS_HDF5STMAN),yes)
	CXXFLAGS+=-DHAS_HDF5STMAN
	LDLIBS+=-lhdf5stman
endif
ifeq ($(HAS_ADIOSSTMAN),yes)
	CXXFLAGS+=-DHAS_ADIOSSTMAN
	LDLIBS+=-ladiosstman
endif

mpi:write.cc read.cc
	$(CXX) -g write.cc $(CXXFLAGS) $(LDLIBS) $(LDFLAGS) -o write
	$(CXX) -g write_concat.cc $(CXXFLAGS) $(LDLIBS) $(LDFLAGS) -o write_concat
	$(CXX) -g write_example.cc $(CXXFLAGS) $(LDLIBS) $(LDFLAGS) -o write_example
	$(CXX) -g read.cc $(CXXFLAGS) $(LDLIBS) $(LDFLAGS) -o read

cl:
	rm -rf *.casa *.out *.table *.o* *.e*

clean:cl
	rm -rf write write_concat read *.dSYM *.so *.table

re: clean mpi
