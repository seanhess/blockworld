//
//  Command.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Command.h"

#import "World.h"
#import "ServerCommunicator.h"
#import "CJSONSerializer.h"

@implementation Command

@dynamic data, positionX, positionY;

// used by incoming request
+(id) commandWithDefinition:(NSDictionary*)definition world:(World*)world {
	Command* command = [(Command*)[NSClassFromString([definition objectForKey:@"action"]) alloc] initWithDefinition:definition world:world];	
	return [command autorelease];
}

-(id) initWithDefinition:(NSDictionary*)def world:w {
	if((self = [super init])) {
		definition = [[def mutableCopy] retain];
		world = [w retain];
	} return self;
}

// used by outgoing request
+ (id) command {
	return [[[self alloc] init] autorelease];
}

-(id) init {
	if((self = [super init])) {
		definition = [NSMutableDictionary new];
	} return self;
}

-(void) send {
	[[ServerCommunicator instance] sendMessageToServer:[[CJSONSerializer serializer] serializeDictionary:definition]];
}

-(void) execute {
	[self doesNotRecognizeSelector:_cmd];
}

-(void) setAction:(NSString *)action {
	[definition setObject:action forKey:@"action"];
}

-(void) setType:(NSString *)type {
	[definition setObject:type forKey:@"type"];
}

-(void) setPoint:(CGPoint)point {
	
	NSArray* keys = [NSArray arrayWithObjects:@"x", @"y", nil];
	NSArray* values = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",point.x], [NSString stringWithFormat:@"%d",point.y], nil];
	
	NSDictionary* points = [NSDictionary dictionaryWithObjects:values forKeys:keys];
	
	[self.data setObject:points forKey:@"position"];
}

-(NSMutableDictionary*) data {
	if(![definition objectForKey:@"data"])
		[definition setObject:[NSMutableDictionary dictionary] forKey:@"data"];
		
	return [definition objectForKey:@"data"];
}

-(int) positionX {
	return [[[self.data objectForKey:@"position"] objectForKey:@"x"] intValue];
}

-(int) positionY {
	return [[[self.data objectForKey:@"position"] objectForKey:@"y"] intValue];
}

- (void) dealloc {
	[definition release];
	[world release];
	
	[super dealloc];
}

@end
