//
//  DirectionPad.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DirectionPad.h"
#import "CCNode+Additions.h"

@interface DirectionPad()
@property(nonatomic, assign) NSTimer* timer;
@property(nonatomic, assign) CGPoint currentTouch;
- (void) move:(NSTimer*)timer;
@end

@implementation DirectionPad

@synthesize move, timer, currentTouch;

- (id) init {
	if((self = [super init])) {
		
        self.isTouchEnabled = YES;
		
		CCSprite* sprite = [CCSprite spriteWithFile:@"dpad.png"];
		
		sprite.position = ccp(0, 0);
		
		[self addChild:sprite];
		
		
	} return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(move:) userInfo:nil repeats:YES];
    }
    
    currentTouch = [self touchRelativeToCamera:[[touches allObjects] objectAtIndex:0]];
    
    [self move:self.timer];
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    currentTouch = [self touchRelativeToCamera:[[touches allObjects] objectAtIndex:0]];
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
    
    CGRect up = CGRectMake(-30, 10, 60, 60);
    CGRect right = CGRectMake(10, -30, 60, 60);
    CGRect down = CGRectMake(-30, -60, 60, 60);
    CGRect left = CGRectMake(-70, -30, 60, 60);
    
    CGPoint translatedPoint = ccpSub(currentTouch, self.position);
    
    
    if(CGRectContainsPoint(up, translatedPoint)) {
        move(0,1);
    }
    if(CGRectContainsPoint(right, translatedPoint)) {
        move(1,0);
    }
    if(CGRectContainsPoint(down, translatedPoint)) {
        move(0,-1);
    }
    if(CGRectContainsPoint(left, translatedPoint)) {
        move(-1,0);
    }
}


- (void) dealloc {
	[move release];
	
	[super dealloc];
}

@end
