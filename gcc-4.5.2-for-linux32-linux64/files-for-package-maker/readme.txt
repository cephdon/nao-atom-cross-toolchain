
Compiling C, C++ for BITSIZE-bit Linux on Mac OS X
==========================================================

     This package contains C, C++ compilers and linkers. It is based on gcc VERSIONGCC distribution.


REQUIREMENTS

     This package has been built on Mac OS X 10.6.7, but it should
     work on Mac OS X 10.5.


INSTALLATION

     1. Simply double click the package file.
        You will be prompted for an Administrator access as it needs to install
        files into the PRODUCTDIR directory.
        The PRODUCTDIR/contents.txt contains the list of used archives.

	Sorry, but PackageMaker is very very buggy and undocumented for
	using it from command line, so we have resigned to display the
	readme and the license information from the installer.

     2. You can add PRODUCTDIR/bin
        to either your account's PATH or the system level PATH.
        To modify to the path for all users, modify /etc/profile
        (for sh, ksh, bash, etc.) or /etc/csh.login (for csh, tcsh, etc).
        Otherwise, you can invoke the tools with their full path names
        (for example: PRODUCTDIR/bin/TOOLPREFIX-gcc).


RESOURCES

     For additional information, visit http://crossgcc.rts-software.org/