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
@property(nonatomic, retain) NSTimer* timer;
- (void) reconnect;
@end


@implementation ServerCommunicator

@synthesize messageReceivedCallback, statusChangedCallback, client, timer;

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

- (void) reconnect {
	[self.client disconnect];
	[self.client connect];
}

- (BOOL) sendMessageToServer:(NSString*)message {
    NSLog(@" > %@", message);
    
    [self.client send:message isJSON:YES];
    
    return YES;
}

- (void)socketIoClient:(SocketIoClient *)client didReceiveMessage:(NSString *)message isJSON:(BOOL)isJSON {
    NSLog(@" < %@", message);
    
    if(messageReceivedCallback)
        messageReceivedCallback([message objectFromJSONString]);
}

- (void)socketIoClientDidConnect:(SocketIoClient *)client {
    status = connected;
    
    
    if(statusChangedCallback)
        statusChangedCallback(status);
		
	[self.timer invalidate];
}

- (void)socketIoClientDidDisconnect:(SocketIoClient *)client {
    status = disconnected;
    
    
    if(statusChangedCallback)
        statusChangedCallback(status);
	
	[self.timer invalidate];	
	self.timer = [NSTimer scheduledTimerWithTimeInterval:SOCKET_RETRY_TIMER target:self selector:@selector(reconnect) userInfo:nil repeats:YES];
}

-(void) dealloc {
    [statusChangedCallback release];
	[messageReceivedCallback release]; 
	[timer release];
	
	[super dealloc];
}

@end
