#
# Build file
#
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
# Google Test depedency variables
#
GTEST_BASE?=/usr/org
GTEST_CFLAGS=-I$(GTEST_BASE)/include
GTEST_LFLAGS=-L$(GTEST_BASE)/lib -lgtest -lgtest_main -Wl,-rpath,$(GTEST_BASE)/lib

#
# Boost deps
#
BOOST_BASE=/usr/local
BOOST_INCLUDE=-I$(BOOST_BASE)/include
BOOST_LFLAGS=-L/usr/local/lib -lboost_program_options -lboost_system

#
# Tooling && tool flags
#
CXX=g++
CXXFLAGS=-g3 $(GTEST_CFLAGS) $(BOOST_INCLUDE)
# The following are the linkin flags -- g++ is used to link to provide meaningful symbol information
CXX_LFLAGS=-g3 $(GTEST_LFLAGS) $(BOOST_LFLAGS) -lpthread

#
# Help/Targets
#
targets:
	@echo "Targets:"
	@echo "	clean		Deletes object files and built applications"
	@echo "	utils		Builds both stomp-send and stom-recv"	
	@echo "	stomp-send	Build the stomp-send application"
	@echo "	stomp-recv	Build the stomp-recv application"
	@echo "	libstomp_util.a	Builds a static library contianing the core stomp library"
	@echo "	libraries	Builds all libraries"
	@echo "	test		Build google test code"
	@echo "	example		Build example code"
#
# cleaning targets
#
clean:
	rm -f *.o stomp-send stomp-recv *.a test exampleCore
#
# Application targets
#
utils: stomp-send stomp-recv
example: exampleCore

#
# Archive
#
libraries: libstomp_util.a libstomp_util_main.a
libstomp_util_main.a: stomp-main.o
	rm -f $@
	ar cq $@ $^
	ranlib $@

libstomp_util.a: StompClient.o stomp-util.o
	rm -f $@
	ar cq $@ $^
	ranlib $@

#
# Test targets
#
#google-test: google-test.o
#	$(CXX) $(LDFLAGS) $? $(CXX_LFLAGS) -o $@
#google-test.o: StompClient.o testStompClient.o
#	$(LD) -i $^ -o $@
stomp-send: stomp-send-app.o
	$(CXX) $(CXX_LFLAGS) $? -o $@ 
	strip $@
stomp-send-app.o: stomp-main.o stomp-send.o StompClient.o stomp-util.o
	$(LD) -i $? -o $@

stomp-recv: stomp-recv-app.o
	$(CXX) $(CXX_LFLAGS) $? -o $@
	strip $@
stomp-recv-app.o: stomp-main.o stomp-util.o StompClient.o stomp-recv.o
	$(LD) -i $? -o $@

#
# Example code
#
exampleCore: exampleCore.o libstomp_util.a
	$(CXX) $(CXX_LFLAGS) $^ -o $@

#
# Source to object targets
#

StompClient.o: StompClient.cpp
testStompClient.o: testStompClient.cpp
stomp-send.o: stomp-send.cpp
stomp-util.o: stomp-util.cpp
stomp-main.o: stomp-main.cpp

################################################################################
# Tests
################################################################################
test: testStompClient.o libstomp_util.a
	$(CXX) $^ $(GTEST_LFLAGS) -o $@
testStompClient.o: testStompClient.cpp
	$(CXX) $(GTEST_CFLAGS) -c $< -o $@

