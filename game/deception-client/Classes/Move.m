//
//  Move.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Move.h"
#import "World.h"

@implementation Move

-(id) init {
	if((self = [super init])) {
		[self setType:@"player"];
		[self setAction:@"move"];
	} return self;
}

-(void) execute {
	if([[definition objectForKey:@"type"] isEqualToString:@"player"]) {
		[world movePlayer:[self.data objectForKey:@"uid"] toPoint:ccp(self.positionX, self.positionY)];
	}
}

- (void) setPlayerID:(NSString*)playerID {
	[self.data setObject:playerID forKey:@"uid"];
}

@end
