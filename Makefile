
ifndef SMITHLAB_CPP
SMITHLAB_CPP=./smithlab_cpp/
endif

BIN_DIR = ./
SRC_DIR = ./src/wand

CXXFLAGS += -g -Wall -Wextra -pthread -O3

ifeq "$(shell uname)" "Darwin"
CXXFLAGS += -arch x86_64
ifeq "$(shell if [ `sysctl -n kern.osrelease | cut -d . -f 1` -ge 13 ];\
              then echo 'true'; fi)" "true"
CXXFLAGS += -stdlib=libc++ -std=c++11
endif
endif

LIBS += -lgsl -lgslcblas

INCLUDE_DIRS = $(SMITHLAB_CPP)
INCLUDE_ARGS = $(addprefix -I,$(INCLUDE_DIRS))

SMITH_OBJ = $(addprefix $(SMITHLAB_CPP)/, GenomicRegion.o smithlab_os.o  smithlab_utils.o OptionParser.o)
							
OBJ = $(addprefix $(SRC_DIR)/, design.o regression.o loglikratio_test.o table_row.o pipeline.o gsl_fitter.o) $(SMITH_OBJ)

$(BIN_DIR)/wand : $(SRC_DIR)/wand.cpp $(OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(INCLUDE_ARGS) $(LIBS)

$(SRC_DIR)/%.o : $(SRC_DIR)/%.cpp $(SRC_DIR)/%.hpp
	$(CXX) $(CXXFLAGS) -c -o $@ $< $(INCLUDE_ARGS)
	
clean:
	rm -f $(BIN_DIR)/wand $(SRC_DIR)/*.o
