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
@end

@implementation SpriteButton

@synthesize sprite, delegate;

- (id)initWithSprite:(CCSprite*)img {

    self = [super init];
    if (self) {
		self.sprite = img;
		[self addChild:img];
		[self setIsTouchEnabled:YES];
    }
    
    return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if([delegate respondsToSelector:@selector(spriteButton:touchesDidBegin:)]) {
		[delegate spriteButton:self touchesDidBegin:touches];
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if([delegate respondsToSelector:@selector(spriteButton:touchesDidEnd:)]) {
		[delegate spriteButton:self touchesDidEnd:touches];
	}
}

- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	if([delegate respondsToSelector:@selector(spriteButton:touchesDidCancel:)]) {
		[delegate spriteButton:self touchesDidCancel:touches];
	}
}

- (void) dealloc {
	[sprite release];
	
	[super dealloc];
}

@end
