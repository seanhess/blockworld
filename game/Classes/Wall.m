/*
 *  Wall.m
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "Wall.h"

@implementation Wall

- (id) init {
	if((self = [super init])) {
		CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:@"Stone Block.png"];
		
		sprite = [CCSprite spriteWithTexture:texture];
		sprite.anchorPoint = ccp(0,0);
		
		[self addChild:sprite];
	}
	return self;
}

@end