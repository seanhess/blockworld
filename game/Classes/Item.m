/*
 *  Item.m
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "Item.h"
#import "Cell.h"


@implementation Item

@synthesize cell, sprite, cachedSpriteName, isOnScreen;


- (void) setIsOnScreen:(BOOL)boolean {
    
    if(isOnScreen == boolean) { return; }
    
    isOnScreen = boolean;
    
    
    if(isOnScreen) {
        [self drawAllSprites];
    } else {
        [self removeAllSprites];
    }
    
}

- (void) drawAllSprites {

	CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:self.cachedSpriteName];
	self.sprite = [CCSprite spriteWithTexture:texture];
	
    
    [self addChild:self.sprite];
}

- (void) removeAllSprites {
    if(![self.cachedSpriteName length]) { NSAssert(0, @"attempting to remove sprite without cached name"); }
    
    [self removeChild:self.sprite cleanup:YES];
}

- (void) dealloc {
	[sprite release];
    [cachedSpriteName release];
    
	[super dealloc];
}

@end