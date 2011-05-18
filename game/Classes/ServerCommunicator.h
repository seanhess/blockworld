//
//  ServerCommunicator.h
//  Rev5
//
//  Created by Bryce Redd on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIoClient.h"

#define SOCKET_PORT 3000
#define SOCKET_ADDR @"localhost"

typedef enum server_status {
	connected,
	disconnected,
	sending,
	receiving
} server_status;



@class ServerRespondible;

@interface ServerCommunicator : NSObject <SocketIoClientDelegate> {
    
	NSString* partialMessage;
	server_status status;
    
}

@property(nonatomic, copy) void(^messageReceivedCallback)(NSDictionary *);
@property(nonatomic, copy) void(^statusChangedCallback)(server_status);

+(ServerCommunicator *) instance;

-(void) connect;
-(void) disconnect;
-(BOOL) sendMessageToServer:(NSString *)message;

@end