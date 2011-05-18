//
//  ServerCommunicator.mm
//  Rev5
//
//  Created by Bryce Redd on 3/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ServerCommunicator.h"
#import "CJSONDeserializer.h"
#import "CJSONSerializer.h"
#import "JSONKit.h"

@interface ServerCommunicator() 
@property(nonatomic, retain) SocketIoClient* client;
@end


@implementation ServerCommunicator

@synthesize messageReceivedCallback, statusChangedCallback, client;

static ServerCommunicator* instance = nil;

+(ServerCommunicator *) instance {
	if(instance == nil) {
		instance = [[ServerCommunicator alloc] init];
	}
	
	return instance;
}

-(id) init {
	if ((self = [super init])) {
        self.client = [[SocketIoClient alloc] initWithHost:SOCKET_ADDR port:SOCKET_PORT];
        self.client.delegate = self;
	}
	return self;
}

- (void) connect {
    [self.client connect];
}

- (void) disconnect {
    [self.client disconnect];
}

- (BOOL) sendMessageToServer:(NSString*)message {
    [self.client send:message isJSON:YES];
    
    return YES;
}


- (void)socketIoClient:(SocketIoClient *)client didReceiveMessage:(NSString *)message isJSON:(BOOL)isJSON {
    messageReceivedCallback([message objectFromJSONString]);
}

- (void)socketIoClientDidConnect:(SocketIoClient *)client {
    statusChangedCallback(connected);
}

- (void)socketIoClientDidDisconnect:(SocketIoClient *)client {
    statusChangedCallback(disconnected);
}

-(void) dealloc {
	[messageReceivedCallback release]; 
	
	[super dealloc];
}

@end