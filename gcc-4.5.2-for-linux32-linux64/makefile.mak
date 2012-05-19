#----------------------------------------------------------------------------*
#                                                                            *
#             M A K E F I L E    F O R    G E N E R A T I N G                *
#                                                                            *
#                     C R O S S    C O M P I L E R                           *
#                                                                            *
#               F O R    L I N U X    O N    M A C O S X                     *
#                                                                            *
#                                                                            *
#----------------------------------------------------------------------------*
#                                                                            *
#  Copyright (C) 2005, ..., 2011 Pierre Molinaro.                            *
#                                                                            *
#  IRCCyN, Institut de Recherche en Communications et Cybernetique de Nantes *
#  ECN, Ecole Centrale de Nantes (France)                                    *
#                                                                            *
#  e-mail : molinaro@irccyn.ec-nantes.fr                                     *
#                                                                            *
#  This program is free software; you can redistribute it and/or modify it   *
#  under the terms of the GNU General Public License as published by the     *
#  Free Software Foundation.                                                 *
#                                                                            *
#  This program is distributed in the hope it will be useful, but WITHOUT    *
#  ANY WARRANTY; without even the implied warranty of MERCHANDIBILITY or     *
#  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for  *
#  more details.                                                             *
#                                                                            *
#  See http://crossgcc.rts-software.org/ for using this makefile.            *
#                                                                            *
#  Started november 29th, 2005.                                              *
#                                                                            *
#  Release 1 (with XCode 2.2): december 21th, 2005.                          *
#     Generates ppc binaries                                                 * 
#                                                                            *
#  Release 2 (with XCode 2.4.1): december 27th, 2006.                        *
#     Generates ppc binaries on a ppc Mac, Intel binaries on an Intel Mac    * 
#                                                                            *
#  Release 3 (with XCode 3.2.6): april 2nd, 2011.                            *
#     This makefile has not been tested on a ppc Mac.                        *
#                                                                            *
#     Four build commands are provided:                                      *
#                                                                            *
#       -build-sandbox-linux32.command that builds the distribution          *
#           (SANDBOX-linux32) for a 32-bit Linux in the current directory;   *
#           sudo is not invoked, no administrator password is required.      *
#                                                                            *
#       -build-sandbox-linux64.command that builds the distribution          *
#           (SANDBOX-linux64) for a 64-bit Linux in the current directory;   *
#           sudo is not invoked, no administrator password is required.      *
#                                                                            *
#       -build-usr-local-linux32.command that builds the distribution        *
#           for a 32-bit Linux in /usr/local/gcc-4.5.2-for-linux32;          *
#           sudo is invoked, so administrator password is required.          *
#                                                                            *
#       -build-usr-local-linux64.command that builds the distribution        *
#           for a 64-bit Linux in /usr/local/gcc-4.5.2-for-linux64;          *
#           sudo is invoked, so administrator password is required.          *
#                                                                            *
#  Needed archives are download when they are required, and store in the     *
#  local 'archive' directory.                                                *
#                                                                            *
#  You can run the 4 build commands in parallel, once the archives have been *
#  downloaded.                                                               *
#                                                                            *
#  By default, gcc compiles and links against 10.5 SDK. You can change CC    *
#  variable definition for using an other SDK (see CC definition, below).    *
#                                                                            *
#----------------------------------------------------------------------------*
#                                                                            *
#    C R O S S    C O M P I L E R    T A R G E T                             *
#                                                                            *
#----------------------------------------------------------------------------*
#
#ifeq ($(THE_TARGET), linux32)
#  TARGET  := i586-pc-linux
#	TARGET_SUFFIX := linux32
#  BIT_SIZE := 32
#else
#  ifeq ($(THE_TARGET), linux64)
#    TARGET  := x86_64-pc-linux
#  	TARGET_SUFFIX := linux64
#	  BIT_SIZE := 64
#  else
#	  $(error Unknown target: $(THE_TARGET)
#	endif
#endif
THE_TARGET := linux32
TARGET := i686-pc-linux-gnu
TARGET_SUFFIX := linux32

#----------------------------------------------------------------------------*
#                                                                            *
#    C R O S S    C O M P I L E R    H O S T                                 *
#                                                                            *
#----------------------------------------------------------------------------*

HOST    := i686-apple-darwin11

#----------------------------------------------------------------------------*
#                                                                            *
#    M A C O S X    N A T I V E    C O M P I L E R                           *
#                                                                            *
#----------------------------------------------------------------------------*

#--- Compiling for Mac OS X 10.4 does not work : binutils hangs.
#--- Compiling for Mac OS X 10.5 does work.
# If Mac OS X 10.5 SDK is not installed, you can use current (Mac OS X 10.6) SDK.
APPLE_SDK := 10.7
# '-arch i386' ir required by gmp.
# http://lists.apple.com/archives/Xcode-users/2007/Oct/msg00696.html
export CC := gcc -arch i386 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$(APPLE_SDK).sdk -mmacosx-version-min=$(APPLE_SDK)

#----------------------------------------------------------------------------*
#                                                                            *
#    M A K E    - j    O P T I O N                                           *
#                                                                            *
#----------------------------------------------------------------------------*

MAKE_J_OPTION := -j $(shell sysctl -n hw.ncpu)

#----------------------------------------------------------------------------*
#                                                                            *
#    A R C H I V E     V E R S I O N S                                       *
#                                                                            *
#----------------------------------------------------------------------------*

BINUTILS_VERSION  := 2.21.1
GCC_VERSION       := 4.5.2
GMP_VERSION       := 5.0.1
MPFR_VERSION      := 3.0.0
MPC_VERSION       := 0.8.2

#----------------------------------------------------------------------------*
#                                                                            *
#    T A R    F I L E S    N A M E S                                         *
#                                                                            *
#----------------------------------------------------------------------------*

BINUTILS_SOURCES := binutils-$(BINUTILS_VERSION)
GCC_SOURCES      := gcc-$(GCC_VERSION)
GMP_SOURCES      := gmp-$(GMP_VERSION)
MPFR_SOURCES     := mpfr-$(MPFR_VERSION)
MPC_SOURCES      := mpc-$(MPC_VERSION)

HEADERS_GLIBC_ARCHIVE_DIR := headers-glibc-for-linux
HEADERS_GLIBC_DISTRIBUTION := headers-glibc-$(TARGET_SUFFIX)

#----------------------------------------------------------------------------*
#                                                                            *
#    T O P L E V E L    I N S T A L L A T I O N    D I R E C T O R Y         *
#                                                                            *
#----------------------------------------------------------------------------*

TOOLCHAIN_DIRECTORY := /Users/yida/Projects/nao-cross-toolchain
#ifndef SANDBOX
#  $(error the SANDBOX variable should be define to yes or no)
#endif
SANDBOX := no

ifeq ($(SANDBOX), yes)
  PRODUCT_DIRECTORY := $(shell pwd)/SANDBOX-$(TARGET_SUFFIX)
  SUDO :=
else
  ifeq ($(SANDBOX), no)
    PRODUCT_DIRECTORY := $(TOOLCHAIN_DIRECTORY)/cross/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)
    SUDO := sudo
  endif
endif

#----------------------------------------------------------------------------*
#                                                                            *
#    A R C H I V E    D I R E C T O R Y                                      *
#                                                                            *
#----------------------------------------------------------------------------*

ARCHIVE_DIR  := archives

#----------------------------------------------------------------------------*
#                                                                            *
#    B U I L D    D I R E C T O R I E S                                      *
#                                                                            *
# Theses directories are used during building process.                       *
#                                                                            *
#----------------------------------------------------------------------------*

MAIN_BUILD_DIR := main-build-dir-sandox-$(SANDBOX)-$(TARGET_SUFFIX)
BUILD_BINUTILS := build-binutils
BUILD_GCC      := build-gcc
BUILD_GMP      := build-gmp
BUILD_MPC      := build-mpc
BUILD_MPFR     := build-mpfr

#----------------------------------------------------------------------------*
#                                                                            *
#    C O N T E N T S    F I L E                                              *
#                                                                            *
#   This file contains the list of all packages.                             *
#                                                                            *
#----------------------------------------------------------------------------*

CONTENTS_FILE_PATH := $(PRODUCT_DIRECTORY)/contents.txt

#----------------------------------------------------------------------------*
#                                                                            *
#    C U R R E N T    D I R                                                  *
#                                                                            *
#----------------------------------------------------------------------------*

CURRENT_DIRECTORY := $(shell pwd)

#----------------------------------------------------------------------------*
#                                                                            *
#    P R O D U C T S                                                         *
#                                                                            *
#----------------------------------------------------------------------------*

STEP1_PRODUCT := $(PRODUCT_DIRECTORY)/bin/$(TARGET)-as
STEP2_PRODUCT := $(PRODUCT_DIRECTORY)/bin/$(TARGET)-g++
STEP3_PRODUCT := gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX).dmg

#----------------------------------------------------------------------------*
#                                                                            *
#    G O A L    :    A L L                                                   *
#                                                                            *
#----------------------------------------------------------------------------*

ifeq ($(SANDBOX), yes)
  all : $(STEP2_PRODUCT)
else
  all : $(STEP3_PRODUCT)
endif
#--- Final message
	@echo "------------------------------------------"
	@echo " Summary"
	@echo "------------------------------------------"
	@echo "gcc-$(GCC_VERSION) for $(TARGET_SUFFIX) has been built in $(PRODUCT_DIRECTORY)"
	@echo "C Compiler invocation:   $(PRODUCT_DIRECTORY)/bin/$(TARGET)-gcc"
	@echo "C++ Compiler invocation: $(PRODUCT_DIRECTORY)/bin/$(TARGET)-g++"
	@echo "See $(CONTENTS_FILE_PATH) for distribution details"
	@echo "------------------------------------------"

#----------------------------------------------------------------------------*
#                                                                            *
#    S T E P    1    :    B U I L D    B I N U T I L S                       *
#                                                                            *
#----------------------------------------------------------------------------*

BINUTILS_BUILD_PARAMETERS :=
BINUTILS_BUILD_PARAMETERS += --target=$(TARGET)
BINUTILS_BUILD_PARAMETERS += --build=$(HOST)
BINUTILS_BUILD_PARAMETERS += --prefix=$(PRODUCT_DIRECTORY)
BINUTILS_BUILD_PARAMETERS += --with-sysroot=$(TOOLCHAIN_DIRECTORY)/sysroot
BINUTILS_BUILD_PARAMETERS += --disable-nls
BINUTILS_BUILD_PARAMETERS += --disable-werror

#----------------------------------------------------------------------------*

$(STEP1_PRODUCT) : | $(HEADERS_GLIBC_ARCHIVE_DIR)/$(HEADERS_GLIBC_DISTRIBUTION).tar.gz $(ARCHIVE_DIR)/$(BINUTILS_SOURCES).tar.bz2
	@echo "-------------------------------------- LINUX HEADERS & GLIBC"
#--- Suppress installation directory
	$(SUDO) rm -fr $(PRODUCT_DIRECTORY)
#--- Suppress previous directories
	rm -rf $(MAIN_BUILD_DIR)
#--- Create build directory
	mkdir $(MAIN_BUILD_DIR)
#--- Create installation directory
	$(SUDO) mkdir -p $(PRODUCT_DIRECTORY)
#---
	gunzip -c $(HEADERS_GLIBC_ARCHIVE_DIR)/$(HEADERS_GLIBC_DISTRIBUTION).tar.gz > $(MAIN_BUILD_DIR)/$(HEADERS_GLIBC_DISTRIBUTION).tar
#--- Untar binutils
	cd $(MAIN_BUILD_DIR) && tar xf $(HEADERS_GLIBC_DISTRIBUTION).tar
#--- Remove tar file
	rm -f $(MAIN_BUILD_DIR)/$(HEADERS_GLIBC_DISTRIBUTION).tar
#--- Copy compiled glibc
	$(SUDO) cp -R $(MAIN_BUILD_DIR)/$(HEADERS_GLIBC_DISTRIBUTION)/* $(PRODUCT_DIRECTORY)/
#--- Copy system headers (needed by previous versions of GCC ?)
#	$(SUDO) mkdir -p $(PRODUCT_DIRECTORY)/$(TARGET)/sys-include
#	$(SUDO) cp -r $(MAIN_BUILD_DIR)/$(HEADERS_GLIBC_DISTRIBUTION)/include/include/* $(PRODUCT_DIRECTORY)/$(TARGET)/sys-include/
#--- Add a link for headers (error "fenv.h not found")
	$(SUDO) mkdir -p $(PRODUCT_DIRECTORY)/$(TARGET)
	cd $(PRODUCT_DIRECTORY)/$(TARGET) && $(SUDO) ln -s ../include include
#--- copy libs (error "cannot find crti.o, -lc, crtn.o"); a soft link cannot be done here, it will be deleted by binutils installation
	$(SUDO) mkdir -p $(PRODUCT_DIRECTORY)/$(TARGET)/lib
	$(SUDO) cp -R $(PRODUCT_DIRECTORY)/lib/* $(PRODUCT_DIRECTORY)/$(TARGET)/lib/
#--- Remove tar file
	rm -fr $(MAIN_BUILD_DIR)/$(HEADERS_GLIBC_DISTRIBUTION)
#-------------------------------
	@echo "-------------------------------------- CONTENTS FILE"
#--- Move contents file at installation top
	$(SUDO) echo "" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "Cross-compilation on Mac OS X" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "uname -m: " `uname -m` | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "uname -r: " `uname -r` | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "uname -s: " `uname -s` | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "uname -v: " `uname -v` | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "sysctl -n hw.ncpu: " `sysctl -n hw.ncpu` | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "sysctl -n machdep.cpu.brand_string: " `sysctl -n machdep.cpu.brand_string` | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "gcc --version: " `gcc --version` | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "The following packages have been cross-compiled:" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
#-------------------------------
	@echo "-------------------------------------- BINUTILS"
#--- Create build directory
	mkdir -p $(MAIN_BUILD_DIR)/$(BUILD_BINUTILS)
#--- Untar binutils tarfile
	bunzip2 -kc $(ARCHIVE_DIR)/$(BINUTILS_SOURCES).tar.bz2 > $(MAIN_BUILD_DIR)/$(BINUTILS_SOURCES).tar
#--- Untar binutils
	cd $(MAIN_BUILD_DIR) && tar xf $(BINUTILS_SOURCES).tar
#--- Remove tar file
	rm -f $(MAIN_BUILD_DIR)/$(BINUTILS_SOURCES).tar
#--- Build binutils
	cd $(MAIN_BUILD_DIR)/$(BUILD_BINUTILS) && ../$(BINUTILS_SOURCES)/configure --help
	cd $(MAIN_BUILD_DIR)/$(BUILD_BINUTILS) && ../$(BINUTILS_SOURCES)/configure $(BINUTILS_BUILD_PARAMETERS)
	cd $(MAIN_BUILD_DIR)/$(BUILD_BINUTILS) && make all $(MAKE_J_OPTION)
	cd $(MAIN_BUILD_DIR)/$(BUILD_BINUTILS) && $(SUDO) make install
#--- Update contents file
	$(SUDO) echo "  $(BINUTILS_SOURCES)" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
#--- Suppress build directory
	rm -rf $(MAIN_BUILD_DIR)

#----------------------------------------------------------------------------*
#                                                                            *
#  S T E P    2    :                                                         *
#     -   G M P                                                              *
#     -   M P F R                                                            *
#     -   M P C                                                              *
#     -   G C C   (C, C++ compilers, C++ library)                            *
#                                                                            *
#----------------------------------------------------------------------------*

GMP_BUILD_PARAMETERS :=
GMP_BUILD_PARAMETERS += --build=$(HOST)
GMP_BUILD_PARAMETERS += --disable-shared

#----------------------------------------------------------------------------*

MPFR_BUILD_PARAMETERS :=
MPFR_BUILD_PARAMETERS += --build=$(HOST)
MPFR_BUILD_PARAMETERS += --disable-shared
MPFR_BUILD_PARAMETERS += --with-gmp-include=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(BUILD_GMP)
MPFR_BUILD_PARAMETERS += --with-gmp-lib=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(BUILD_GMP)/.libs

#----------------------------------------------------------------------------*

MPC_BUILD_PARAMETERS :=
MPC_BUILD_PARAMETERS += --build=$(HOST)
MPC_BUILD_PARAMETERS += --disable-shared
MPC_BUILD_PARAMETERS += --with-gmp-include=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(BUILD_GMP)
MPC_BUILD_PARAMETERS += --with-gmp-lib=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(BUILD_GMP)/.libs
MPC_BUILD_PARAMETERS += --with-mpfr-include=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(MPFR_SOURCES)
MPC_BUILD_PARAMETERS += --with-mpfr-lib=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(BUILD_MPFR)/.libs

#----------------------------------------------------------------------------*

GCC_BUILD_PARAMETERS :=
GCC_BUILD_PARAMETERS += --target=$(TARGET)
GCC_BUILD_PARAMETERS += --build=$(HOST)
GCC_BUILD_PARAMETERS += --prefix=$(PRODUCT_DIRECTORY)
GCC_BUILD_PARAMETERS += --with-sysroot=$(TOOLCHAIN_DIRECTORY)/sysroot
GCC_BUILD_PARAMETERS += --with-gmp-include=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(BUILD_GMP)
GCC_BUILD_PARAMETERS += --with-gmp-lib=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(BUILD_GMP)/.libs
GCC_BUILD_PARAMETERS += --with-mpfr-include=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(MPFR_SOURCES)
GCC_BUILD_PARAMETERS += --with-mpfr-lib=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(BUILD_MPFR)/.libs
GCC_BUILD_PARAMETERS += --with-mpc-include=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(MPC_SOURCES)/src
GCC_BUILD_PARAMETERS += --with-mpc-lib=$(CURRENT_DIRECTORY)/$(MAIN_BUILD_DIR)/$(BUILD_MPC)/src/.libs
GCC_BUILD_PARAMETERS += --disable-multilib
GCC_BUILD_PARAMETERS += --enable-languages=c,c++
GCC_BUILD_PARAMETERS += --enable-threads=posix
GCC_BUILD_PARAMETERS += --enable-__cxa_atexit
GCC_BUILD_PARAMETERS += --enable-clocale=gnu
GCC_BUILD_PARAMETERS += --disable-bootstrap

#----------------------------------------------------------------------------*

STEP2_DEPENDANCIES :=
STEP2_DEPENDANCIES += $(ARCHIVE_DIR)/$(GCC_SOURCES).tar.bz2
STEP2_DEPENDANCIES += $(ARCHIVE_DIR)/$(GMP_SOURCES).tar.bz2
STEP2_DEPENDANCIES += $(ARCHIVE_DIR)/$(MPFR_SOURCES).tar.bz2
STEP2_DEPENDANCIES += $(ARCHIVE_DIR)/$(MPC_SOURCES).tar.gz

#----------------------------------------------------------------------------*

$(STEP2_PRODUCT) : | $(STEP1_PRODUCT) $(STEP2_DEPENDANCIES) 
	@echo "-------------------------------------- GMP"
#--- Suppress previous directories
	rm -rf $(MAIN_BUILD_DIR)
#--- Create build directory
	mkdir -p $(MAIN_BUILD_DIR)/$(BUILD_GMP)
#--- Untar gmp tarfile
	bunzip2 -kc $(ARCHIVE_DIR)/$(GMP_SOURCES).tar.bz2 > $(MAIN_BUILD_DIR)/$(GMP_SOURCES).tar
#--- Untar gmp
	cd $(MAIN_BUILD_DIR) && tar xf $(GMP_SOURCES).tar
#--- Remove tar file
	rm -f $(MAIN_BUILD_DIR)/$(GMP_SOURCES).tar
#--- Build binutils
	cd $(MAIN_BUILD_DIR)/$(BUILD_GMP) && ../$(GMP_SOURCES)/configure --help
	cd $(MAIN_BUILD_DIR)/$(BUILD_GMP) && ../$(GMP_SOURCES)/configure $(GMP_BUILD_PARAMETERS)
	cd $(MAIN_BUILD_DIR)/$(BUILD_GMP) && make all $(MAKE_J_OPTION)
#--- Update contents file
	$(SUDO) echo "  $(GMP_SOURCES) for Mac OS X is temporarily used (not installed) for compiling GCC" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
#--- Suppress source directory
	rm -rf $(MAIN_BUILD_DIR)/$(GMP_SOURCES)
#---
	@echo "-------------------------------------- MPFR"
#--- Suppress previous directories
	rm -rf $(MAIN_BUILD_DIR)/$(MPFR_SOURCES)
	rm -rf $(MAIN_BUILD_DIR)/$(BUILD_MPFR)
#--- Create build directory
	mkdir -p $(MAIN_BUILD_DIR)/$(BUILD_MPFR)
#--- Untar gmp tarfile
	bunzip2 -kc $(ARCHIVE_DIR)/$(MPFR_SOURCES).tar.bz2 > $(MAIN_BUILD_DIR)/$(MPFR_SOURCES).tar
#--- Untar gmp
	cd $(MAIN_BUILD_DIR) && tar xf $(MPFR_SOURCES).tar
#--- Remove tar file
	rm -f $(MAIN_BUILD_DIR)/$(MPFR_SOURCES).tar
#--- Build 
	cd $(MAIN_BUILD_DIR)/$(BUILD_MPFR) && ../$(MPFR_SOURCES)/configure --help
	cd $(MAIN_BUILD_DIR)/$(BUILD_MPFR) && ../$(MPFR_SOURCES)/configure $(MPFR_BUILD_PARAMETERS)
	cd $(MAIN_BUILD_DIR)/$(BUILD_MPFR) && make all $(MAKE_J_OPTION)
#--- Update contents file
	$(SUDO) echo "  $(MPFR_SOURCES) for Mac OS X is temporarily used (not installed) for compiling GCC" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
#--- Do not suppress source directory
	@echo "-------------------------------------- MPC"
#--- Suppress previous directories
	rm -rf $(MAIN_BUILD_DIR)/$(BUILD_MPC)
	rm -rf $(MAIN_BUILD_DIR)/$(MPC_SOURCES)
#--- Create build directory
	mkdir -p $(MAIN_BUILD_DIR)/$(BUILD_MPC)
#--- Untar MPC tarfile
	gunzip -c $(ARCHIVE_DIR)/$(MPC_SOURCES).tar.gz > $(MAIN_BUILD_DIR)/$(MPC_SOURCES).tar
#--- Untar MPC
	cd $(MAIN_BUILD_DIR) && tar xf $(MPC_SOURCES).tar
#--- Remove tar file
	rm -f $(MAIN_BUILD_DIR)/$(MPC_SOURCES).tar
#--- Build MPC
	cd $(MAIN_BUILD_DIR)/$(BUILD_MPC) && ../$(MPC_SOURCES)/configure --help
	cd $(MAIN_BUILD_DIR)/$(BUILD_MPC) && ../$(MPC_SOURCES)/configure $(MPC_BUILD_PARAMETERS)
	cd $(MAIN_BUILD_DIR)/$(BUILD_MPC) && make all $(MAKE_J_OPTION)
#--- Update contents file
	$(SUDO) echo "  $(MPC_SOURCES) for Mac OS X is temporarily used (not installed) for compiling GCC" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
#--- Do not suppress source directory
#---------------------------------------------------------------
	@echo "-------------------------------------- GCC"
#--- Suppress build directory
	rm -rf $(MAIN_BUILD_DIR)/$(BUILD_GCC)
#--- Suppress source directory
	rm -rf $(MAIN_BUILD_DIR)/$(GCC_SOURCES)
#--- Create build directory
	mkdir -p $(MAIN_BUILD_DIR)/$(BUILD_GCC)
#--- Get tarfiles
	bunzip2 -kc $(ARCHIVE_DIR)/$(GCC_SOURCES).tar.bz2 > $(MAIN_BUILD_DIR)/$(GCC_SOURCES).tar
#--- Untar files
	cd $(MAIN_BUILD_DIR) && tar xf $(GCC_SOURCES).tar
#--- Remove tar files
	rm -f $(MAIN_BUILD_DIR)/$(GCC_SOURCES).tar
#--- Build GCC
# "CPP=/usr/bin/cpp" prevents /lib/cpp sanity check error: see http://forums.macnn.com/90/mac-os-x/151674/configure-lib-cpp-fails-sanity-check/
	cd $(MAIN_BUILD_DIR)/$(BUILD_GCC) && ../$(GCC_SOURCES)/configure --help
	cd $(MAIN_BUILD_DIR)/$(BUILD_GCC) && PATH=$(PATH):$(PRODUCT_DIRECTORY)/bin && CPP=/usr/bin/cpp && ../$(GCC_SOURCES)/configure $(GCC_BUILD_PARAMETERS)
	cd $(MAIN_BUILD_DIR)/$(BUILD_GCC) && make $(MAKE_J_OPTION)
	cd $(MAIN_BUILD_DIR)/$(BUILD_GCC) && $(SUDO) make install
#--- Update contents file
	$(SUDO) echo "  $(GCC_SOURCES) (C and C++ compilers)" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
#--- Suppress source directory
	rm -rf $(MAIN_BUILD_DIR)
#--- Final message
	$(SUDO) echo "" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "Tool invocation" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "C Compiler invocation:   $(PRODUCT_DIRECTORY)/bin/$(TARGET)-gcc" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)
	$(SUDO) echo "C++ Compiler invocation: $(PRODUCT_DIRECTORY)/bin/$(TARGET)-g++" | $(SUDO) tee -a $(CONTENTS_FILE_PATH)

#----------------------------------------------------------------------------*
#                                                                            *
#   S T E P 3     :    B U I L D    D M G    F I L E                         *
#                                                                            *
#----------------------------------------------------------------------------*

PACKAGE_BUILD_DIR := build-distribution-for-$(TARGET_SUFFIX)
PACKAGE_MAKER_FILES_DIR := files-for-package-maker
PACKAGE_MAKER_PATCH_DIR := patch-dir

#----------------------------------------------------------------------------*

# See http://www.codeography.com/2009/09/04/automating-apple-s-packagemaker.html

PACKAGE_MAKER_OPTIONS :=
PACKAGE_MAKER_OPTIONS += --root $(PRODUCT_DIRECTORY)
PACKAGE_MAKER_OPTIONS += -l $(PRODUCT_DIRECTORY)
PACKAGE_MAKER_OPTIONS += --no-relocate
PACKAGE_MAKER_OPTIONS += --root-volume-only
PACKAGE_MAKER_OPTIONS += --discard-forks
PACKAGE_MAKER_OPTIONS += --filter "\.DS_Store"
PACKAGE_MAKER_OPTIONS += --domain system
PACKAGE_MAKER_OPTIONS += --target $(APPLE_SDK)
PACKAGE_MAKER_OPTIONS += --title "gcc $(GCC_VERSION) for $(BIT_SIZE)-bit Linux on Mac OS X"
PACKAGE_MAKER_OPTIONS += --id "fr.ec-nantes.irccyn.molinaro.gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)"
PACKAGE_MAKER_OPTIONS += --resources $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)/resources
PACKAGE_MAKER_OPTIONS += --out $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX).pkg
PACKAGE_MAKER_OPTIONS += --verbose

#----------------------------------------------------------------------------*

PACKAGE_MAKER_REPLACEMENT_STRING := <domains enable_localSystem=\"true\"/>
#PACKAGE_MAKER_REPLACEMENT_STRING += <background file='background' alignment='bottomleft' scaling='none'/>
#PACKAGE_MAKER_REPLACEMENT_STRING += <readme file='readme.txt'/>
#PACKAGE_MAKER_REPLACEMENT_STRING += <license file='License'/>

#----------------------------------------------------------------------------*

$(STEP3_PRODUCT) : | $(STEP2_PRODUCT)
	@echo "---------------------------------- Build Package"
	rm -fr $(PACKAGE_BUILD_DIR)
	mkdir -p $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)/resources/fr.lproj
	cp $(PACKAGE_MAKER_FILES_DIR)/License.txt $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)/resources/fr.lproj/License
	cp $(PACKAGE_MAKER_FILES_DIR)/gerwinski-gnu-head.png $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)/resources/fr.lproj/background
	sed "s:BITSIZE:$(BIT_SIZE):g" $(PACKAGE_MAKER_FILES_DIR)/readme.txt | \
sed "s:VERSIONGCC:$(GCC_VERSION):g" | \
sed "s:PRODUCTDIR:$(PRODUCT_DIRECTORY):g" | \
sed "s:TOOLPREFIX:$(TARGET):" > $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)/resources/fr.lproj/readme.txt
	/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker $(PACKAGE_MAKER_OPTIONS)
#--- As PackageMaker is very very buggy, we resign to patch the package for taking into account the resources...
#	@echo "---------------------------------- Patch Package"
#	mkdir $(PACKAGE_BUILD_DIR)/$(PACKAGE_MAKER_PATCH_DIR)
#	xar -xf $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX).pkg -C $(PACKAGE_BUILD_DIR)/$(PACKAGE_MAKER_PATCH_DIR)
#	rm -fr $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX).pkg
#	sed "s:<domains enable_localSystem=\"true\"/>:$(PACKAGE_MAKER_REPLACEMENT_STRING):g" $(PACKAGE_BUILD_DIR)/$(PACKAGE_MAKER_PATCH_DIR)/Distribution > $(PACKAGE_BUILD_DIR)/distribution-temp
#	cp $(PACKAGE_BUILD_DIR)/distribution-temp $(PACKAGE_BUILD_DIR)/$(PACKAGE_MAKER_PATCH_DIR)/Distribution
#	cd $(PACKAGE_BUILD_DIR)/$(PACKAGE_MAKER_PATCH_DIR) && xar -cf gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX).pkg .
#	mv $(PACKAGE_BUILD_DIR)/$(PACKAGE_MAKER_PATCH_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX).pkg $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)
#--- Now, we can build the dmg file
	@echo "---------------------------------- Build dmg file"
	cp $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)/resources/fr.lproj/readme.txt $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)
	cp $(PACKAGE_MAKER_FILES_DIR)/License.txt $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)
	rm -fr $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX)/resources
	hdiutil create -srcfolder $(PACKAGE_BUILD_DIR)/gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX) gcc-$(GCC_VERSION)-for-$(TARGET_SUFFIX).dmg
	rm -fr $(PACKAGE_BUILD_DIR)

#----------------------------------------------------------------------------*
#                                                                            *
#    C U R L     I N V O C A T I O N                                         *
#                                                                            *
#----------------------------------------------------------------------------*

CURL := curl --fail --location --output

#----------------------------------------------------------------------------*
#                                                                            *
#    A R C H I V E    D I R E C T O R Y                                      *
#                                                                            *
#----------------------------------------------------------------------------*

$(ARCHIVE_DIR):
	mkdir $(ARCHIVE_DIR)

#----------------------------------------------------------------------------*
#                                                                            *
#    D O W N L O A D     B I N U T I L S                                     *
#                                                                            *
#----------------------------------------------------------------------------*

$(ARCHIVE_DIR)/$(BINUTILS_SOURCES).tar.bz2: | $(ARCHIVE_DIR)
	@echo "------------------ DOWNLOAD $(notdir $@)"
	$(CURL) $(ARCHIVE_DIR)/$(BINUTILS_SOURCES).tar.bz2 "http://ftp.gnu.org/gnu/binutils/$(BINUTILS_SOURCES).tar.bz2"

#----------------------------------------------------------------------------*
#                                                                            *
#    D O W N L O A D     G C C                                               *
#                                                                            *
#----------------------------------------------------------------------------*

$(ARCHIVE_DIR)/$(GCC_SOURCES).tar.bz2: | $(ARCHIVE_DIR)
	@echo "------------------ DOWNLOAD $(notdir $@)"
	$(CURL) $(ARCHIVE_DIR)/$(GCC_SOURCES).tar.bz2 "http://ftp.gnu.org/gnu/gcc/$(GCC_SOURCES)/$(GCC_SOURCES).tar.bz2"

#----------------------------------------------------------------------------*
#                                                                            *
#    D O W N L O A D     G M P                                               *
#                                                                            *
#----------------------------------------------------------------------------*

$(ARCHIVE_DIR)/$(GMP_SOURCES).tar.bz2: | $(ARCHIVE_DIR)
	@echo "------------------ DOWNLOAD $(notdir $@)"
	$(CURL) $(ARCHIVE_DIR)/$(GMP_SOURCES).tar.bz2 "http://ftp.gnu.org/gnu/gmp/$(GMP_SOURCES).tar.bz2"

#----------------------------------------------------------------------------*
#                                                                            *
#    D O W N L O A D     M P F R                                             *
#                                                                            *
#----------------------------------------------------------------------------*

$(ARCHIVE_DIR)/$(MPFR_SOURCES).tar.bz2: | $(ARCHIVE_DIR)
	@echo "------------------ DOWNLOAD $(notdir $@)"
	$(CURL) $(ARCHIVE_DIR)/$(MPFR_SOURCES).tar.bz2 "http://ftp.gnu.org/gnu/mpfr/$(MPFR_SOURCES).tar.bz2"

#----------------------------------------------------------------------------*
#                                                                            *
#    D O W N L O A D     M P C                                               *
#                                                                            *
#----------------------------------------------------------------------------*

$(ARCHIVE_DIR)/$(MPC_SOURCES).tar.gz: | $(ARCHIVE_DIR)
	@echo "------------------ DOWNLOAD $(notdir $@)"
	$(CURL) $(ARCHIVE_DIR)/$(MPC_SOURCES).tar.gz "http://www.multiprecision.org/mpc/download/$(MPC_SOURCES).tar.gz"

#----------------------------------------------------------------------------*
