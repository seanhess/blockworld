//
//  Command.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Command.h"

#import "World.h"
#import "Create.h"
#import "Destroy.h"
#import "Move.h"
#import "ServerCommunicator.h"
#import "JSONKit.h"

@implementation Command

@synthesize definition;

@dynamic data, positionX, positionY;

// used by incoming request
+(id) commandWithDefinition:(NSDictionary*)definition world:(World*)world {
	Command* command = nil;
	
	if([[definition objectForKey:@"action"] isEqualToString:@"create"])
		command = [[[Create alloc] initWithDefinition:definition world:world] autorelease];	
	if([[definition objectForKey:@"action"] isEqualToString:@"destroy"])
		command = [[[Destroy alloc] initWithDefinition:definition world:world] autorelease];	
	if([[definition objectForKey:@"action"] isEqualToString:@"move"])
		command = [[[Move alloc] initWithDefinition:definition world:world] autorelease];	
	
	return command;
}

-(id) initWithDefinition:(NSDictionary*)def world:w {
	if((self = [super init])) {
		definition = [def mutableCopy];
		world = [w retain];
	} return self;
}

// used by outgoing request
+ (id) command {
	return [[[self alloc] init] autorelease];
}

-(id) init {
	if((self = [super init])) {
		self.definition = [NSMutableDictionary dictionary];
	} return self;
}

-(void) send {
	[[ServerCommunicator instance] sendMessageToServer:[definition JSONString]];
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
	[self.data setObject:[NSNumber numberWithInt:point.x] forKey:@"x"];
	[self.data setObject:[NSNumber numberWithInt:point.y] forKey:@"y"];
}

- (void) setPlayerID:(NSString*)playerID {
	[self.data setObject:playerID forKey:@"playerId"];
}

-(NSMutableDictionary*) data {
	if(![definition objectForKey:@"data"])
		[definition setObject:[NSMutableDictionary dictionary] forKey:@"data"];
		
	return [definition objectForKey:@"data"];
}

-(int) positionX {
	return [[self.data objectForKey:@"x"] intValue];
}

-(int) positionY {
	return [[self.data objectForKey:@"y"] intValue];
}

- (void) dealloc {
    //[definition release];
	[world release];
	
	[super dealloc];
}

@end
