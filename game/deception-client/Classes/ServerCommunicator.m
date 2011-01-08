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


@interface ServerCommunicator() 
@property(nonatomic, assign) server_status status;
-(void) messageParser:(unsigned char*)msg;
@end


@implementation ServerCommunicator

@synthesize messageReceivedCallback, statusChangedCallback, status;

static ServerCommunicator* instance = nil;

+(ServerCommunicator *) instance {
	if(instance == nil) {
		instance = [[ServerCommunicator alloc] init];
	}
	
	return instance;
}

-(id) init {
	if ((self = [super init])) {
		
		self.status = disconnected;
		
	}
	return self;
}

static void socketCallBack(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *dataIn, void *info)  {
	[ServerCommunicator instance].status = receiving;
	
	ServerCommunicator *socketController = (ServerCommunicator *) info;
	
	if(type==kCFSocketConnectCallBack) {
		
		if(dataIn) {	
			
			SInt32 error = *((SInt32*)dataIn);
			printf("error code %d\n", (int)error);
			
		}
		
		return;
	}
	
	if(type == kCFSocketDataCallBack) {
		
		unsigned char *dataBytes;
		dataBytes = (unsigned char*)[(NSMutableData *)dataIn mutableBytes];
		[socketController messageParser:dataBytes]; // deal with data in dataBytes
	}
	
	[ServerCommunicator instance].status = connected;
}

-(void) messageParser:(unsigned char*)msg {

	@synchronized(self) {
		
		NSString* str = [NSString stringWithFormat:@"%s",msg];
		
		//"<<< {message:'json message'} >>>"
		
		/*if(!partialMessage) { 
			partialMessage = [str retain];
		}*/
		
		NSData* data = [str dataUsingEncoding:NSStringEncodingConversionExternalRepresentation];
		NSError * error = nil;
	
		if(messageReceivedCallback) { messageReceivedCallback([[CJSONDeserializer deserializer] deserialize:data error:&error]); }
		
	}
}

-(void) connect {
	
	CFSocketContext context = { 
		0,
		self,
		NULL,
		NULL,
		NULL
	};
	
	CFSocketRef socket = CFSocketCreate
	(kCFAllocatorDefault, 
	 PF_INET, 
	 SOCK_STREAM, 
	 IPPROTO_TCP, 
	 kCFSocketDataCallBack^kCFSocketConnectCallBack, // callBackTypes 
	 socketCallBack, // callBack function
	 &context 
	 );
	
	NSLog(@"Connecting to %s:%d", SOCKET_ADDR, SOCKET_PORT);
	uint16_t port = SOCKET_PORT;
	
	struct sockaddr_in addr4;
	memset(&addr4, 0, sizeof(addr4));
	addr4.sin_family = AF_INET; 
	addr4.sin_len = sizeof(addr4); 
	addr4.sin_port = htons(port);
	const char *ipaddress = SOCKET_ADDR;
	inet_aton(ipaddress, &addr4.sin_addr); 
	NSData *address = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];

	CFSocketError error = CFSocketConnectToAddress(socket, (CFDataRef)address, -1);
	
	if(error != kCFSocketSuccess) {
		NSLog(@"COULD NOT CONNECT! ABORTING!");
		return; 
	}
	
	CFRunLoopSourceRef source; 
	source = CFSocketCreateRunLoopSource(NULL, socket, 1); 
	CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode); 
	CFRelease(source);
	
	sock = socket;
	
	self.status = connected;

}

-(void) disconnect {
	self.status = disconnected;
}

-(BOOL) sendMessageToServer:(NSString *)message {
	
	self.status = sending;
	
	@synchronized(self) {
		
		char c[5000];
		
		sprintf(c, "%s\n", [message UTF8String]);
		
		const char* sendStrUTF = c;
		
		NSData *dataOut = [NSData dataWithBytes:sendStrUTF length:strlen(sendStrUTF)];
		
		CFSocketError error = CFSocketSendData(sock, NULL, (CFDataRef)dataOut, 0);
		
		// validate error's value
		if(error == kCFSocketError) {
			NSLog(@"Error in sending message.");
		}
		
		
	}
	
	self.status = connected;
	
	return YES;
}

-(void) setStatus:(server_status)s {
	status = s;
	if (statusChangedCallback) statusChangedCallback(status);
}

-(void) dealloc {
	
	[messageReceivedCallback release]; 
	[statusChangedCallback release];
	
	[super dealloc];
}

@end
