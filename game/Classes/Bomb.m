/*
 *  Bomb.m
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "Bomb.h"

@implementation Bomb

- (id) init {
	if((self = [super init])) {
		CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:@"bomb.png"];
		
		self.sprite = [CCSprite spriteWithTexture:texture];
		sprite.anchorPoint = ccp(0,0);
        sprite.position = ccp(0,20);
		
		[self addChild:sprite];
	}
	return self;
}

@end