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
		self.cachedSpriteName = @"Stone Block.png";
        
        self.isOnScreen = YES;
	}
	return self;
}

- (void) drawAllSprites {
    [super drawAllSprites];
    
    sprite.anchorPoint = ccp(0,0);
    sprite.position = ccp(0,20);
    
}

- (void)removeAllSprites {
    [super removeAllSprites];
}

- (void) dealloc {
    NSLog(@"wall dealloc'd");
    [super dealloc];
}

@end