#----------------------------------------------------------------------------*
#                                                                            *
#             M A K E F I L E    F O R    G E N E R A T I N G                *
#                                                                            *
#    L I N U X    H E A D E R S    A N D    G L I B C    O N    L I N U X    *
#                                                                            *
#----------------------------------------------------------------------------*
#                                                                            *
#  THIS MAKEFILE SHOULD BE RAN ON LINUX                                      *
#                                                                            *
#----------------------------------------------------------------------------*
#                                                                            *
#  Build a 32-bits archive in a 32-bit Linux, and a 64-bit archive on        *
#  a 64-bit Linux.                                                           *
#                                                                            *
#----------------------------------------------------------------------------*
#                                                                            *
#  Copyright (C) 2011, ..., 2011 Pierre Molinaro.                            *
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
#----------------------------------------------------------------------------*
#                                                                            *
#    3 2    B I T S    O R    6 4    B I T S    ?                            *
#                                                                            *
#----------------------------------------------------------------------------*

#PROCESSOR := $(shell uname -m)
#
#ifeq ($(PROCESSOR), x86_64)
#  MACHINE := 64
#else
#  ifeq ($(PROCESSOR), i686)
#    MACHINE := 32
#  else
#    $(error Unknown machine:$(PROCESSOR))
#  endif
#endif
MACHINE := 32

#----------------------------------------------------------------------------*
#                                                                            *
#    T O P L E V E L    I N S T A L L A T I O N    D I R E C T O R Y         *
#                                                                            *
#----------------------------------------------------------------------------*

PRODUCT_DIRECTORY := $(shell pwd)/headers-glibc-linux$(MACHINE)

#----------------------------------------------------------------------------*
#                                                                            *
#    A R C H I V E    D I R E C T O R Y                                      *
#                                                                            *
#----------------------------------------------------------------------------*

ARCHIVE_DIR  := archives

#----------------------------------------------------------------------------*
#                                                                            *
#    C O N T E N T S    F I L E                                              *
#                                                                            *
#----------------------------------------------------------------------------*

CONTENTS_FILE  := $(PRODUCT_DIRECTORY)/contents.txt

#----------------------------------------------------------------------------*
#                                                                            *
#    C U R R E N T    D I R                                                  *
#                                                                            *
#----------------------------------------------------------------------------*

CURRENT_DIRECTORY := $(shell pwd)

#----------------------------------------------------------------------------*
#                                                                            *
#    M A K E    J    O P T I O N                                             *
#                                                                            *
#----------------------------------------------------------------------------*

MAKE_J_OPTION := -j $(shell cat /proc/cpuinfo | grep -i 'processor' | wc -l)

#----------------------------------------------------------------------------*
#                                                                            *
#    G L I B C    C O N F I G U R E     P A R A M E T E R S                  *
#                                                                            *
#----------------------------------------------------------------------------*

GLIBC_CONFIGURE_PARAMETERS :=
GLIBC_CONFIGURE_PARAMETERS += --prefix=$(PRODUCT_DIRECTORY)
GLIBC_CONFIGURE_PARAMETERS += --host=i686-pc-linux-gnu
GLIBC_CONFIGURE_PARAMETERS += --disable-profile
GLIBC_CONFIGURE_PARAMETERS += --enable-add-ons

#----------------------------------------------------------------------------*

#export PKG_CONFIG_PATH := $(PRODUCT_DIRECTORY)/lib/pkgconfig:$(PRODUCT_DIRECTORY)/share/pkgconfig

#----------------------------------------------------------------------------*

#export PATH :=$(PATH):$(PRODUCT_DIRECTORY)/bin

#----------------------------------------------------------------------------*
#                                                                            *
#    G O A L    :    A L L                                                   *
#                                                                            *
#----------------------------------------------------------------------------*

KERNEL_VERSION := 2.6.33.9
PATCH_VERSION :=-rt31
GLIBC_VERSION := 2.11.3
BUILD_LIST := linux-$(KERNEL_VERSION)$(PATCH_VERSION)
BUILD_LIST += glibc-$(GLIBC_VERSION)

#----------------------------------------------------------------------------*

all : $(BUILD_LIST)
#--- Remove unneeded directories
	rm -rf $(PRODUCT_DIRECTORY)/bin
	rm -rf $(PRODUCT_DIRECTORY)/sbin
	rm -rf $(PRODUCT_DIRECTORY)/libexec
#--- Compress result
	tar -cz $(notdir $(PRODUCT_DIRECTORY)) > $(notdir $(PRODUCT_DIRECTORY)).tar.gz
	rm -fr $(PRODUCT_DIRECTORY)

#----------------------------------------------------------------------------*
#                                                                            *
#    L I N U X    H E A D E R S                                              *
#                                                                            *
#----------------------------------------------------------------------------*

BUILD_LINUX_HEADERS_DIR := build-linux-headers

#----------------------------------------------------------------------------*

linux-% : | $(ARCHIVE_DIR)/linux-%.tar.bz2
#--- Suppress product directory
	rm -rf $(PRODUCT_DIRECTORY)
	mkdir $(PRODUCT_DIRECTORY)
#--- Suppress build directory
	rm -rf $(BUILD_LINUX_HEADERS_DIR)
	mkdir $(BUILD_LINUX_HEADERS_DIR)
#--- Create directory and add contents file
	echo "The $(notdir $(PRODUCT_DIRECTORY)).tar.gz package has been build on linux" > $(CONTENTS_FILE)
	echo "uname -m: " `uname -m` >> $(CONTENTS_FILE)
	echo "uname -r: " `uname -r` >> $(CONTENTS_FILE)
	echo "uname -s: " `uname -s` >> $(CONTENTS_FILE)
	echo "uname -v: " `uname -v` >> $(CONTENTS_FILE)
	echo "gcc --version: " `gcc --version` >> $(CONTENTS_FILE)
	echo "It contains the following packages:" >> $(CONTENTS_FILE)
#--- From Linux From Scratch book, section 6.7: Linux API Headers
	@echo "-------------------------------------- COPY HEADERS"
	mkdir -p $(PRODUCT_DIRECTORY)/include
#	cp -r /usr/include/* $(PRODUCT_DIRECTORY)/include
#--- Decompress archive
	bunzip2 -kc $(ARCHIVE_DIR)/$@.tar.bz2 > $(BUILD_LINUX_HEADERS_DIR)/$@.tar
#--- Untar
	cd $(BUILD_LINUX_HEADERS_DIR) && tar xf $@.tar
#--- Remove tar file
	rm -f $(BUILD_LINUX_HEADERS_DIR)/$@.tar
#--- Install headers
	cd $(BUILD_LINUX_HEADERS_DIR)/$@ && make headers_check
	cd $(BUILD_LINUX_HEADERS_DIR)/$@ && make INSTALL_HDR_PATH=../header-dest headers_install
	find $(BUILD_LINUX_HEADERS_DIR)/header-dest \( -name .install -o -name ..install.cmd \) -delete
	cp -r $(BUILD_LINUX_HEADERS_DIR)/header-dest/include/* $(PRODUCT_DIRECTORY)/include
	rm -fr $(BUILD_LINUX_HEADERS_DIR)
#--- Add package to contents file
	echo "  Linux headers from $@" >> $(CONTENTS_FILE)


#----------------------------------------------------------------------------*
#                                                                            *
#   B U I L D   R U L E   F O R    G L I B C                                 *
#                                                                            *
#   It is a specific rule:                                                   *
#     - glibc should be built in a separate directory;                       *
#     - make requires specific argument;                                     *
#     - absolute pathes in some libraries should be removed in product.      *
#                                                                            *
#----------------------------------------------------------------------------*

GLIBC_CONFIGURE_PARAMETERS :=
GLIBC_CONFIGURE_PARAMETERS += --prefix=$(PRODUCT_DIRECTORY)
GLIBC_CONFIGURE_PARAMETERS += --host=i686-pc-linux-gnu
GLIBC_CONFIGURE_PARAMETERS += --disable-profile
GLIBC_CONFIGURE_PARAMETERS += --enable-add-ons
GLIBC_CONFIGURE_PARAMETERS += --with-headers=$(PRODUCT_DIRECTORY)/include

#----------------------------------------------------------------------------*

GLIBC_BUILD_DIR := glibc-build-dir

#----------------------------------------------------------------------------*

glibc-% : | $(ARCHIVE_DIR)/glibc-%.tar.gz
	@echo "-------------------------------------- $@"
#--- Remove directories
	rm -fr $(GLIBC_BUILD_DIR)
	rm -fr glibc-$(GLIBC_VERSION)
#--- Decompress archive
	gunzip -c $(ARCHIVE_DIR)/$@.tar.gz > $@.tar
	tar xf $@.tar
	rm -f $@.tar
#--- Apply Patch
	cd glibc-$(GLIBC_VERSION) && patch  < ../glibc-i686-3.diff
#--- Configure
	mkdir $(GLIBC_BUILD_DIR)
	cd $(GLIBC_BUILD_DIR) && ../$@/configure --help
	cd $(GLIBC_BUILD_DIR) && ../$@/configure $(GLIBC_CONFIGURE_PARAMETERS)
#--- Build glibc
# -U_FORTIFY_SOURCE: see http://plash.beasts.org/wiki/GlibcBuildIssues
# -fno-stack-protector: see http://ubuntuforums.org/showthread.php?t=352642
	cd $(GLIBC_BUILD_DIR) && make "CC=cc -U_FORTIFY_SOURCE -fno-stack-protector" $(MAKE_J_OPTION)
#--- Install 
	cd $(GLIBC_BUILD_DIR) && make install
#--- Remove absolute paths in libc.so and libpthread.so
	sed "s:$(PRODUCT_DIRECTORY)/lib/::g" $(PRODUCT_DIRECTORY)/lib/libc.so > $(GLIBC_BUILD_DIR)/temp-libc.so
	cp $(GLIBC_BUILD_DIR)/temp-libc.so $(PRODUCT_DIRECTORY)/lib/libc.so
	sed "s:$(PRODUCT_DIRECTORY)/lib/::g" $(PRODUCT_DIRECTORY)/lib/libpthread.so > $(GLIBC_BUILD_DIR)/temp-libpthread.so
	cp $(GLIBC_BUILD_DIR)/temp-libpthread.so $(PRODUCT_DIRECTORY)/lib/libpthread.so
#--- Remove directory
	rm -fr $(GLIBC_BUILD_DIR)/$@
#--- Add package to contents file
	echo "  $@" >> $(CONTENTS_FILE)

#----------------------------------------------------------------------------*
#                                                                            *
#    C U R L     I N V O C A T I O N                                         *
#                                                                            *
#----------------------------------------------------------------------------*

CURL := curl --fail --location --output

#----------------------------------------------------------------------------*
#                                                                            *
#    D O W N L O A D     L I N U X    A R C H I V E                          *
#                                                                            *
#----------------------------------------------------------------------------*

$(ARCHIVE_DIR)/linux-%.tar.bz2:
	@echo "------------------ DOWNLOAD $(notdir $@)"
	mkdir -p $(ARCHIVE_DIR)
	$(CURL) $(ARCHIVE_DIR)/patch-$(KERNEL_VERSION)$(PATCH_VERSION).bz2 http://www.kernel.org/pub/linux/kernel/projects/rt/2.6.33/patch-$(KERNEL_VERSION)$(PATCH_VERSION).bz2
	git clone https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable $(ARCHIVE_DIR)/linux-$(KERNEL_VERSION)$(PATCH_VERSION)
	cd $(ARCHIVE_DIR)/linux-$(KERNEL_VERSION)$(PATCH_VERSION) && git checkout -f v$(KERNEL_VERSION)
	cd $(ARCHIVE_DIR) && bzip2 -dv patch-$(KERNEL_VERSION)$(PATCH_VERSION).bz2
	cd $(ARCHIVE_DIR)/linux-$(KERNEL_VERSION)$(PATCH_VERSION) && patch -p1 < ../patch-$(KERNEL_VERSION)$(PATCH_VERSION)
	cd $(ARCHIVE_DIR) && rm -rf linux-$(KERNEL_VERSION)$(PATCH_VERSION)/.git && tar -cvjf linux-$(KERNEL_VERSION)$(PATCH_VERSION).tar.bz2 linux-$(KERNEL_VERSION)$(PATCH_VERSION) 
	rm -fr $(ARCHIVE_DIR)/linux-$(KERNEL_VERSION)$(PATCH_VERSION)
	rm -fr $(ARCHIVE_DIR)/patch-$(KERNEL_VERSION)$(PATCH_VERSION)

#----------------------------------------------------------------------------*
#                                                                            *
#    D O W N L O A D     G L I B C                                           *
#                                                                            *
#----------------------------------------------------------------------------*

$(ARCHIVE_DIR)/glibc-%.tar.gz:
	@echo "------------------ DOWNLOAD $(notdir $@)"
	mkdir -p $(ARCHIVE_DIR)
	$(CURL) $@ "http://ftp.gnu.org/gnu/glibc/$(notdir $@)"

#----------------------------------------------------------------------------*
