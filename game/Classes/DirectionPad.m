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
@property(nonatomic, assign) CGPoint currentTouchPoint;
@property(nonatomic, assign) UITouch* currentTouch;
@property(nonatomic, retain) CCSprite* sprite;
- (void) move:(NSTimer*)timer;
- (CGRect) rect;
- (UITouch*) containsTouch:(NSSet *)touches;
@end

// How should this work, really? If their touch is still down... am I intercepting EVERYTHING? 

@implementation DirectionPad

@synthesize move, timer, currentTouch, currentTouchPoint, sprite;

- (id) init {
	if((self = [super init])) {
		
        self.isTouchEnabled = YES;
		
		CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:@"dpad.png"];
		self.sprite = [CCSprite spriteWithTexture:texture];
		
		self.sprite.position = ccp(0, 0);
        self.sprite.opacity = 150;
		[self addChild:sprite];
		
	} return self;
}


- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = nil;
	if(!(touch = [self containsTouch:touches])) { return; }
	
	self.currentTouch = touch;
	
    if(!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(move:) userInfo:nil repeats:YES];
    }
    
    self.currentTouchPoint = [self touchRelativeToCamera:touch];
    
    [self move:self.timer];
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if(![touches containsObject:self.currentTouch]) { return; }
	
	if(![self containsTouch:[NSSet setWithObject:self.currentTouch]]) { 
		[self.timer invalidate];
		self.timer = nil;
		self.currentTouch = nil;
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if(![touches containsObject:self.currentTouch]) { return; }
	
	[self.timer invalidate];
	self.timer = nil;
	self.currentTouch = nil;
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if(![touches containsObject:self.currentTouch]) { return; }
	
	[self.timer invalidate];
	self.timer = nil;
	self.currentTouch = nil;
}

- (void) move:(NSTimer*)timer {

    // Get the point
    CGPoint translatedPoint = ccpSub(self.currentTouchPoint, self.position);
    
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


- (UITouch*) containsTouch:(NSSet *)touches {
	for(UITouch* touch in touches) {
	
		CGPoint locationGL = [touch locationInView: [touch view]];
		locationGL = [[CCDirector sharedDirector] convertToGL:locationGL];
		CGPoint tapPosition = [self convertToNodeSpace:locationGL];
		
		if(CGRectContainsPoint([self rect], tapPosition)) {
			return touch;
		}
	}
	
	return nil;
}

- (CGRect) rect {
	float h = [self.sprite contentSize].height;
	float w = [self.sprite contentSize].width;
	float x = self.sprite.position.x - w/2;
	float y = self.sprite.position.y - h/2;
	
	return CGRectShrink(CGRectMake(x,y,w,h), -20);
}



- (void) dealloc {
    [self.timer invalidate];
	[timer release];
	
	[move release];
	[sprite release];
	
	[super dealloc];
}

@end
