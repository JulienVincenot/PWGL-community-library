# $Id: Makefile.am,v 1.3 2004/01/29 13:36:27 schwarz Exp $
#
# SDIF/macosxbuild/Makefile.am	
#
# just to include Mac ProjectBuilder compilation project to source
# distribution
#
# $Log: Makefile.am,v $
# Revision 1.3  2004/01/29 13:36:27  schwarz
# add xcode to dist
# redefinition of distdir seems no longer necessary
#
# Revision 1.2  2003/07/08 14:54:14  schwarz
# seemed to need an all: target
#
# Revision 1.1  2003/06/13 10:05:41  schwarz
# Added latest projectbuilder mac os X project to cvs and dist.
# Library version is 3.8.0-beta until we decide to announce the official release,
# to avoid confusion.


SUBDIRS		= SDIF.pbproj SDIF.xcode

# distdir		= $(PACKAGE)-$(VERSION)-src

# more files to include in dist
EXTRA_DIST 	= README.MacOSX

all:
		echo "Use Apple build tools to build for Mac OS X"
