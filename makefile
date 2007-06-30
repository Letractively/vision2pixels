###########################################################################
#                              Vision2Pixels
#
#                         Copyright (C) 2006-2007
#                       Pascal Obry - Olivier Ramonat
#
#   This library is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or (at
#   your option) any later version.
#
#   This library is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#   General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this library; if not, write to the Free Software Foundation,
#   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#
#  Simple makefile to build Vision2Pixels
###########################################################################

# Options

INSTALL=$(HOME)/opt/v2p

GWIAD_ROOT=$(HOME)/opt/gwiad
GWIAD_UNREGISTER_SCRIPT=$(GWIAD_ROOT)/scripts/unregister
GWIAD_HOST=127.0.0.1:8080
MODE=Debug

GNAT_ROOT=$(dir $(shell which gnatls))
GWIAD_INSTALL=$(GNAT_ROOT)../lib/gwiad

ifeq ($(OS),Windows_NT)
EXEXT=.exe
SOEXT=.dll
else
EXEXT=
SOEXT=.so
endif

CP=cp -p
MKDIR=mkdir -p
RM=rm -f

LOG := ${shell pwd}/log.${shell date +%Y%m%d-%H%M%S}

OPTIONS = INSTALL="$(INSTALL)" EXEXT="$(EXEXT)" MODE="$(MODE)" \
	CP="$(CP)" MKDIR="$(MKDIR)" RM="$(RM)" MAKE="$(MAKE)" \
	LOG="$(LOG)" SOEXT="$(SOEXT)"

# Modules support

MODULES = image db web

MODULES_SETUP = ${MODULES:%=%_setup}

MODULES_BUILD = ${MODULES:%=%_build}

MODULES_RUNTESTS = ${MODULES:%=%_runtests}

MODULES_INSTALL = ${MODULES:%=%_install}

MODULES_CLEAN = ${MODULES:%=%_clean}

# Set LD_LIBRARY_PATH or PATH on Windows

export LD_LIBRARY_PATH=$(GWIAD_INSTALL)

# Targets

all: $(MODULES_SETUP) $(MODULES_BUILD)

setup: $(MODULES_SETUP)

init_tests:
	-rm -f $(LOG)

check_tests:
	echo $(LOG)
	if [ `grep 0 $(LOG) | wc -l` != 6 ]; then \
		echo "NOk, some tests have failed"; \
		false; \
	else \
		echo "Ok, all tests have passed"; \
		true; \
	fi;

runtests: init_tests $(MODULES_RUNTESTS) check_tests

install: $(MODULES_INSTALL)

install_gwiad_plugin:
	-$(GWIAD_UNREGISTER_SCRIPT) $(GWIAD_HOST) website \
		$(GWIAD_ROOT)/lib/websites/libvision2pixels$(SOEXT)
	mkdir -p $(GWIAD_ROOT)/plugins/vision2pixels/templates/
	mkdir -p $(GWIAD_ROOT)/plugins/vision2pixels/xml
	mkdir -p $(GWIAD_ROOT)/plugins/vision2pixels/web_data
	mkdir -p $(GWIAD_ROOT)/plugins/vision2pixels/we_js
	mkdir -p $(GWIAD_ROOT)/plugins/vision2pixels/css
	mkdir -p $(GWIAD_ROOT)/plugins/vision2pixels/css/img
	$(CP) -r web/templates/*.thtml \
		$(GWIAD_ROOT)/plugins/vision2pixels/templates/
	$(CP) -r web/templates/*.txml \
		$(GWIAD_ROOT)/plugins/vision2pixels/templates/
	$(CP) -r web/xml/*xml \
		$(GWIAD_ROOT)/plugins/vision2pixels/xml/
	$(CP) -r web/we_js/*js \
		$(GWIAD_ROOT)/plugins/vision2pixels/we_js/
	$(CP) -r web/css/*css \
		$(GWIAD_ROOT)/plugins/vision2pixels/css/
	$(CP) -r web/css/img/* \
		$(GWIAD_ROOT)/plugins/vision2pixels/css/img/
	$(CP) web/lib/*$(SOEXT) $(GWIAD_ROOT)/lib/websites
	$(CP) db/lib/*$(SOEXT) $(GWIAD_ROOT)/bin
	$(CP) image/lib/*$(SOEXT) $(GWIAD_ROOT)/bin
	$(CP) kernel/lib/*$(SOEXT) $(GWIAD_ROOT)/bin
	$(CP) lib/gnade/lib/*$(SOEXT) $(GWIAD_ROOT)/bin

clean: $(MODULES_CLEAN)

${MODULES_SETUP}:
	${MAKE} -C ${@:%_setup=%} setup $(OPTIONS)

${MODULES_BUILD}:
	${MAKE} -C ${@:%_build=%} $(OPTIONS)

${MODULES_RUNTESTS}:
	${MAKE} -C ${@:%_runtests=%} runtests $(OPTIONS)

${MODULES_INSTALL}:
	${MAKE} -C ${@:%_install=%} install $(OPTIONS)

${MODULES_CLEAN}:
	${MAKE} -C ${@:%_clean=%} clean $(OPTIONS)
