//
//  DirectionPad.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DirectionPad.h"
#import "CCNode+Additions.h"
#import "CCLayer.h"

#define DiagonalThresholdRatio 0.75 // 1 is perfect strictness

@interface DirectionPad()
@property(nonatomic, assign) NSTimer* timer;
@property(nonatomic, assign) CGPoint currentTouch;
- (void) move:(NSTimer*)timer;
@end

// How should this work, really? If their touch is still down... am I intercepting EVERYTHING? 

@implementation DirectionPad

@synthesize move, timer, currentTouch;

- (id) init {
	if((self = [super init])) {
		
        self.isTouchEnabled = YES;
		
		CCSprite* sprite = [CCSprite spriteWithFile:@"dpad.png"];        
		sprite.position = ccp(0, 0);
        sprite.opacity = 150;
		[self addChild:sprite];
		
	} return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(move:) userInfo:nil repeats:YES];
    }
    
    self.currentTouch = [self touchRelativeToCamera:[[touches allObjects] objectAtIndex:0]];
    
    [self move:self.timer];
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.currentTouch = [self touchRelativeToCamera:[[touches allObjects] objectAtIndex:0]];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self.timer invalidate];
    self.timer = nil;
}

- (void) move:(NSTimer*)timer {

    // Get the point
    CGPoint translatedPoint = ccpSub(self.currentTouch, self.position);
    
    // A few things we'll need
    CGFloat x = translatedPoint.x;
    CGFloat y = translatedPoint.y;
    CGFloat absX = fabs(x);
    CGFloat absY = fabs(y);
    CGFloat normX = (absX) ? x / absX : 0; // -1 or 1
    CGFloat normY = (absY) ? y / absY : 0;    

    // if they are equal, it is 1. If Y is zero, then go full-x
    // If Y > X, will be < 1
    // If Y < X, will be > 1
    CGFloat xtoy = (absY) ? absX / absY : 100; 
    
    // more right than left
    if (xtoy > 1) {
        y = (1/xtoy < DiagonalThresholdRatio) ? 0 : normY; // -1 or 1;
        x = normX;
    }
    
    else {
        y = normY;
        x = (xtoy < DiagonalThresholdRatio) ? 0 : normX; // -1 or 1;
    }    
    
    move(x, y);
}


- (void) dealloc {
	[move release];
	
	[super dealloc];
}

@end
