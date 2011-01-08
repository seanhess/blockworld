/*
 *  Player.m
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "Player.h"

#import "Cell.h"

@implementation Player

@synthesize playerID;

+ (Player*) playerWithPlayerID:(NSString*)playerID {
	return [[[self alloc] initWithPlayerID:playerID] autorelease];
}

- (id) initWithPlayerID:(NSString*)p {
	if((self = [super init])) {
		self.playerID = p;
		
		CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:@"bluetile.png"];
		
		sprite = [CCSprite spriteWithTexture:texture];
		sprite.anchorPoint = ccp(0,0);
		
		[self addChild:sprite];
	}
	return self;
}

- (void) dealloc {
	[playerID release];
	
	[super dealloc];
}

@end