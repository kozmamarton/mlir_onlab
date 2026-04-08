#
# The following environment variables should be predefined:
#
# OPS_INSTALL_PATH
# OPS_COMPILER (gnu,intel,etc)
#
include $(OPS_INSTALL_PATH)/../makefiles/Makefile.common
include $(OPS_INSTALL_PATH)/../makefiles/Makefile.mpi
include $(OPS_INSTALL_PATH)/../makefiles/Makefile.cuda
include $(OPS_INSTALL_PATH)/../makefiles/Makefile.hip
include $(OPS_INSTALL_PATH)/../makefiles/Makefile.hdf5


HEADERS=pom2k_ops.h pom2k_fun_mod_kernels.h grid

OPS_FILES=pom2k_fun_mod.cpp

OPS_GENERATED=pom2k_fun_mod_ops.cpp

OTHER_FILES=pom2k.o

OPS_LINK += -lgfortran

#Rule for compiling .F files:
%.o: %.F
	$(FC) -O3 -g -c $< -o $@

APP=pom2k
MAIN_SRC=pom2k_fun_mod

include $(OPS_INSTALL_PATH)/../makefiles/Makefile.c_app
