/*
 * Copyright (c) 2010, Mark Eschbach 
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the Mark Eschbach nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL Mark Eschbach BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Example utilizing the StompClient core with Boost as the connecting layer.
 *
 * $HeadURL: file:///home/gremlin/backups/rcs/svn/software/msg-util/trunk/stomp-util/exampleCore.cpp $
 * $Id: exampleCore.cpp 2503 2010-11-08 06:20:42Z meschbach $
 */
#include "StompClient.h"
#include <iostream>
#include <boost/asio.hpp>

#ifndef BROKER_HOST
#define BROKER_HOST "localhost"
#endif

#ifndef BROKER_PORT
#define BROKER_PORT "61613"
#endif

#ifndef USING_QUEUE
#define USING_QUEUE "/queue/mee.stomp.client"
#endif

int main( int argc, char** argv ){
	/*
	 * Establish our TCP/IP connection to the remote broker
	 */
		boost::asio::ip::tcp::iostream tcpipStream;
		tcpipStream.connect( BROKER_HOST, BROKER_PORT ); 
	/*
	 * Establish our STOMP protocol session
	 */
		mee::stomp::StompClient stompClient( tcpipStream );
//		stompClient.connect( tcpipStream );
		stompClient.connect( false );
	/*
	 * Send a message
	 */
		stompClient.sendMessage( USING_QUEUE, "Hello World!" );
	/*
	 * Recieve the message
	 */
		stompClient.subscribe( USING_QUEUE );
		mee::stomp::StompFrame msg;
		stompClient.receiveFrame( msg );
		stompClient.unsubscribe( USING_QUEUE );
		std::cout << "Received message: '" << msg.message.str() << "' from destination " << USING_QUEUE << std::endl;
	/*
	 * Clean up protocol layers
	 */
		stompClient.disconnect();
		tcpipStream.close();
	/*
	 * Clean exit
	 */
		return 0;
}

