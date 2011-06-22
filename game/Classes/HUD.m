//
//  HUD.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HUD.h"

#import "DirectionPad.h"
#import "ActionPad.h"

@implementation HUD

- (id) init {
	if((self = [super init])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
		
		directionPad = [DirectionPad node];
		directionPad.position = ccp(80, 80);
		
		actionPad = [ActionPad node];
		actionPad.position = ccp(size.width-60, 90);
		
		[self addChild:directionPad];
		[self addChild:actionPad];
		
	} return self;
}

- (void) setMoveCallback:(void(^)(int, int))move {
	void(^callback)(int, int) = [[move copy] autorelease];
	
	directionPad.move = callback;
}

- (void) setOnBombCallback:(void(^)())callback {
	Block cb = [[callback copy] autorelease];
	
	actionPad.bomb = cb;
}

- (void) setOnWallCallback:(void(^)())callback {
	Block cb = [[callback copy] autorelease];
	
	actionPad.wall = cb;
}

- (void) cleanup {
    [super cleanup];
    
    actionPad.wall = nil;
    actionPad.bomb = nil;
    directionPad.move = nil;
}

@end
