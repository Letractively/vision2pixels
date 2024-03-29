###########################################################################
#                              Vision2Pixels
#
#                          Copyright (C) 2006-2007
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

# Targets

LOGFILE := ${shell pwd}/test/image_harness.log.${shell date +%Y%m%d-%H%M%S}

build:
	$(GNAT) make -XPRJ_BUILD=$(MODE) -Pimage_test

check:
	$(GNAT) check -dd -Pimage -rules -from=../v2p.check
	$(GNAT) check -dd -Pimage_test -rules -from=../v2p.check

setup:
	$(MKDIR) obj lib ../kernel/obj ../kernel/lib

install:

run_tests:
	(cd test; ./image_harness > $(LOGFILE))
	-grep "Failed Assertions" $(LOGFILE) >> $(LOG)
	-grep "Unexpected Errors" $(LOGFILE) >> $(LOG)

runtests: run_tests

clean:
	-$(GNAT) clean -XPRJ_BUILD=$(MODE) -Pimage_test
	-$(RM) test/*.res test/image_harness.log.*
	-$(RM) -r images
