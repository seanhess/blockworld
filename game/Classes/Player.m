/*
 *  Player.m
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#include "Player.h"

#import "Cell.h"

@implementation Player

@synthesize playerID, nickname;

+ (Player*) playerWithPlayerID:(NSString*)playerID {
	return [[[self alloc] initWithPlayerID:playerID] autorelease];
}

- (id) initWithPlayerID:(NSString*)p {
	if((self = [super init])) {
		self.playerID = p;
		
        NSArray* possibleSprites = [NSArray arrayWithObjects:@"Character Boy.png", @"Character Cat Girl.png", @"Character Horn Girl.png", @"Character Princess Girl.png", nil];
        self.cachedSpriteName = [possibleSprites objectAtIndex:(arc4random() % [possibleSprites count])];
        
        self.isOnScreen = YES;
	}
	return self;
}

- (void) drawAllSprites {
    [super drawAllSprites];
    
    sprite.anchorPoint = ccp(0,0);
    sprite.position = ccp(0,20);
    
    self.nickname = self.nickname;
}

- (void)removeAllSprites {
    [super removeAllSprites];
    
    self.nickname = nil;
}

- (void) setNickname:(NSString *)nick {
	[nickname autorelease];
	nickname = [nick retain];
	
	if(nicknameLabel) 
		[self removeChild:nicknameLabel cleanup:YES];
	
	if(nickname) {
		nicknameLabel = [CCLabelTTF labelWithString:nickname fontName:@"Helvetica" fontSize:20];
		nicknameLabel.anchorPoint = ccp(0,0);
        nicknameLabel.position = ccp(0,80);
		[self addChild:nicknameLabel];
	}
}

- (void) moveInDirection:(CGPoint)direction {}

- (void) dealloc {
	[playerID release];
    [nickname release];
	
	[super dealloc];
}

@end