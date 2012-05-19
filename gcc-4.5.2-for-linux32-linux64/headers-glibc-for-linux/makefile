ARCHIVE_DIR  := archives

CURL := curl --fail --location --output

KERNEL_VERSION := 2.6.33.9
PATCH_VERSION := -rt31

all : $(ARCHIVE_DIR)/linux-2.6.33.9-rt31.tar.bz2

$(ARCHIVE_DIR)/linux-2.6.33.9-rt31.tar.bz2:
	mkdir -p $(ARCHIVE_DIR)
#	$(CURL) $(ARCHIVE_DIR)/patch-$(KERNEL_VERSION)$(PATCH_VERSION).bz2 http://www.kernel.org/pub/linux/kernel/projects/rt/2.6.33/patch-$(KERNEL_VERSION)$(PATCH_VERSION).bz2
#	git clone https://kernel.googlesource.com/pub/scm/linux/kernel/git/stable/linux-stable $(ARCHIVE_DIR)/linux-$(KERNEL_VERSION)$(PATCH_VERSION)
#	cd $(ARCHIVE_DIR)/linux-$(KERNEL_VERSION)$(PATCH_VERSION) && git checkout v$(KERNEL_VERSION) && 
#	cd $(ARCHIVE_DIR) && bzip2 -dv patch-$(KERNEL_VERSION)$(PATCH_VERSION).bz2
#	cd $(ARCHIVE_DIR)/linux-$(KERNEL_VERSION)$(PATCH_VERSION) && patch -p1 < ../patch-$(KERNEL_VERSION)$(PATCH_VERSION)
#	cd $(ARCHIVE_DIR) && rm -rf linux-$(KERNEL_VERSION)$(PATCH_VERSION)/.git && tar -cvjf linux-$(KERNEL_VERSION)$(PATCH_VERSION).tar.bz2 linux-$(KERNEL_VERSION)$(PATCH_VERSION) 
	rm -fr $(ARCHIVE_DIR)/linux-$(KERNEL_VERSION)$(PATCH_VERSION)
	rm -fr patch-$(KERNEL_VERSION)$(PATCH_VERSION)


