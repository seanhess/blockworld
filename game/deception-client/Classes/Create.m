//
//  Build.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Create.h"
#import "World.h"

@implementation Create

-(id) init {
	if((self = [super init])) {
		[self setAction:@"Create"];
	} return self;
}

-(void) execute {
	if([[definition objectForKey:@"type"] isEqualToString:@"player"]) {
		[world createPlayerWithID:[self.data objectForKey:@"id"] atPoint:ccp(self.positionX, self.positionY)];
	}
	if([[definition objectForKey:@"type"] isEqualToString:@"bomb"]) {
		[world createBombAtPoint:ccp(self.positionX, self.positionY)];
	}
	if([[definition objectForKey:@"type"] isEqualToString:@"wall"]) {
		[world createWallAtPoint:ccp(self.positionX, self.positionY)];
	}
}

@end
