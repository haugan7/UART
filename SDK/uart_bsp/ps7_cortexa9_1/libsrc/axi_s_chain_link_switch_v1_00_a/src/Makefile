##############################################################################
## Filename:          P:\KLJ\MIKROPRO\Xilinx\Edk_user_repository\MyProcessorIPLib/drivers/axi_s_chain_link_switch_v1_00_a/src/Makefile
## Description:       Microprocessor Driver Makefile
## Date:              Tue May 03 16:33:01 2016 (by Create and Import Peripheral Wizard)
##############################################################################

COMPILER=
ARCHIVER=
CP=cp
COMPILER_FLAGS=
EXTRA_COMPILER_FLAGS=
LIB=libxil.a

RELEASEDIR=../../../lib
INCLUDEDIR=../../../include
INCLUDES=-I./. -I${INCLUDEDIR}

INCLUDEFILES=*.h
LIBSOURCES=*.c
OUTS = *.o

libs:
	echo "Compiling axi_s_chain_link_switch"
	$(COMPILER) $(COMPILER_FLAGS) $(EXTRA_COMPILER_FLAGS) $(INCLUDES) $(LIBSOURCES)
	$(ARCHIVER) -r ${RELEASEDIR}/${LIB} ${OUTS}
	make clean

include:
	${CP} $(INCLUDEFILES) $(INCLUDEDIR)

clean:
	rm -rf ${OUTS}
