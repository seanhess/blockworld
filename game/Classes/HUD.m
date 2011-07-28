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
		directionPad.position = ccp(80, 130);
		
		actionPad = [ActionPad node];
		actionPad.position = ccp(size.width-60, 140);
		
		[self addChild:directionPad];
		[self addChild:actionPad];
        
        
        CCSprite* sprite = [CCSprite spriteWithFile:@"bluetile.png"];        
		sprite.position = ccp(size.width - 40, size.height - 40);
		[self addChild:sprite];
		
	} return self;
}

- (void) setMoveCallback:(void(^)(int, int))move {
	void(^callback)(int, int) = [[move copy] autorelease];
	
	directionPad.move = callback;
}

- (void) setBombCallback:(void(^)(BOOL))callback {	
	actionPad.bomb = callback;
}

- (void) setWallCallback:(void(^)(BOOL))callback {
	actionPad.wall = callback;
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"TOUCHES ENDED ON HUD");
}

- (void) cleanup {
    [super cleanup];
    
    actionPad.wall = nil;
    actionPad.bomb = nil;
    directionPad.move = nil;
}

@end
