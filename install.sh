#!/bin/sh -e
# Example installation file
# Copyright (c) 2010, Mark Eschbach 
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the Mark Eschbach nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL Mark Eschbach BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Installation file
#
# $HeadURL$
# $Id$

BASE=/usr/org

BBASE=$BASE/bin
IBASE=$BASE/include/stomp_util
LBASE=$BASE/lib/stomp_util
USER=root
GROUP=`uname |sed -e 's/Linux/root/' -e 's/FreeBSD/wheel/' `
MAKE=`uname |sed -e 's/Linux/freebsd-make/' -e 's/FreeBSD/make/'`
echo "Installing to group '$GROUP'"

install_path() {
	sudo install -d -g $GROUP -o $USER $1
}

install_binary() {
	sudo install -g $GROUP -o $USER $1 $BBASE/$1
}

install_library() {
	sudo install -g $GROUP -o $USER $1 $LBASE/$1
}

install_header() {
	sudo install -g $GROUP -o $USER $1 $IBASE/$1
}

echo ""
echo "========================== Building Utilities ============================================"
echo ""
$MAKE utils
echo ""
echo "========================== Building Libraries ============================================"
echo ""
$MAKE libraries
echo ""
echo "========================== Installing ============================================"
echo ""

install_path $IBASE
install_header StompClient.h
install_header stomp-util.h

install_path $LBASE
install_library libstomp_util.a
install_library libstomp_util_main.a

install_path $BBASE
install_binary stomp-recv
install_binary stomp-send

