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
        
		texture = [[CCTextureCache sharedTextureCache] addImage:@"dir_dpad.png"];
		
		CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, 80, 80)];
		CCSprite* sprite = [CCSprite spriteWithSpriteFrame:frame];
		
		sprite.position = ccp(0, 0);
		
		[self addChild:sprite];
		
		/*CCMenuItem* up = [CCMenuItem itemWithBlock:^(id sender) {
			if(move) move(0,1);
		}];
		CCMenuItem* down = [CCMenuItem itemWithBlock:^(id sender) {
			if(move) move(0,-1);
		}];
		CCMenuItem* left = [CCMenuItem itemWithBlock:^(id sender) {
			if(move) move(-1,0);
		}];
		CCMenuItem* right = [CCMenuItem itemWithBlock:^(id sender) {
			if(move) move(1,0);
		}];
		
		up.contentSize = CGSizeMake(40, 40);
		down.contentSize = CGSizeMake(40, 40);
		left.contentSize = CGSizeMake(40, 40);
		right.contentSize = CGSizeMake(40, 40);
		
		up.position = ccp(0, 30);
		down.position = ccp(0, -30);
		left.position = ccp(-35, 0);
		right.position = ccp(35, 0);
		
		CCMenu* menu = [CCMenu menuWithItems:up, down, left, right, nil];
		
		menu.position = ccp(0,0);
		
		[self addChild:menu];*/
		
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
    
    CGRect up = CGRectMake(-20, 10, 40, 30);
    CGRect right = CGRectMake(10, -20, 30, 40);
    CGRect down = CGRectMake(-20, -40, 40, 30);
    CGRect left = CGRectMake(-40, -20, 30, 40);
    
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
