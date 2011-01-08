//
//  ServerCommunicator.h
//  Rev5
//
//  Created by Bryce Redd on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h> 
#import <sys/socket.h> 
#import <arpa/inet.h>
#import "Blocks.h"

#define SOCKET_PORT 3000

// IP ADDRESS //
#define SOCKET_ADDR "192.168.2.102"

typedef enum server_status {
	connected,
	disconnected,
	sending,
	receiving
} server_status;

@class ServerRespondible;

@interface ServerCommunicator : NSObject {
	CFSocketRef sock;
	
	server_status status;
	
	NSString* partialMessage;
	
	void(^statusChangedCallback)(server_status);
	void(^messageReceivedCallback)(NSDictionary *);
}

@property(nonatomic, copy) void(^statusChangedCallback)(server_status);
@property(nonatomic, copy) void(^messageReceivedCallback)(NSDictionary *);

+(ServerCommunicator *) instance;

-(void) connect;
-(void) disconnect;
-(BOOL) sendMessageToServer:(NSString *)message;

@end
