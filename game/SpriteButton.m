//
//  SpirteButton.m
//  deception-client
//
//  Created by Bryce Redd on 6/26/11.
//  Copyright 2011 i.TV. All rights reserved.
//

#import "SpriteButton.h"

@interface SpriteButton()
@property(nonatomic, retain) CCSprite* sprite;
- (CGRect) rect;
- (BOOL) containsTouch:(NSSet *)touches;
@end

@implementation SpriteButton

@synthesize sprite, delegate;

- (id)initWithSprite:(CCSprite*)img {

    self = [super init];
    if (self) {
		self.sprite = img;
		[self addChild:img];
		[self setIsTouchEnabled:YES];
		
		[self setContentSize:img.textureRect.size];
    }
    
    return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return [self containsTouch:[NSSet setWithObject:touch]];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if([self containsTouch:touches] && [delegate respondsToSelector:@selector(spriteButton:touchesDidBegin:)]) {
		[delegate spriteButton:self touchesDidBegin:touches];
	}
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if(![self containsTouch:touches]) {
		
		if([delegate respondsToSelector:@selector(spriteButton:touchesDidEnd:)]) {
			[delegate spriteButton:self touchesDidEnd:touches];
		}
		
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if([self containsTouch:touches] && [delegate respondsToSelector:@selector(spriteButton:touchesDidEnd:)]) {
		[delegate spriteButton:self touchesDidEnd:touches];
	}
}


- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if([self containsTouch:touches] && [delegate respondsToSelector:@selector(spriteButton:touchesDidCancel:)]) {
		[delegate spriteButton:self touchesDidCancel:touches];
	}
}

- (BOOL) containsTouch:(NSSet *)touches {
	for(UITouch* touch in touches) {
	
		CGPoint locationGL = [touch locationInView: [touch view]];
		locationGL = [[CCDirector sharedDirector] convertToGL:locationGL];
		CGPoint tapPosition = [self convertToNodeSpace:locationGL];
	
		
		if(CGRectContainsPoint([self rect], tapPosition)) {
			return YES;
		}
	}
	
	return NO;
}

-(CGRect) rect {
	float h = [self.sprite contentSize].height;
	float w = [self.sprite contentSize].width;
	float x = self.sprite.position.x - w/2;
	float y = self.sprite.position.y - h/2;
	return CGRectMake(x,y,w,h);
}

- (void) dealloc {
	[sprite release];
	
	[super dealloc];
}

@end
