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
		
		/*left = CGRectMake(0, 0, 25, 35);
		right = CGRectMake(50, 0, 25, 35);
		up = CGRectMake(100, 0, 25, 35);
		down = CGRectMake(150, 0, 25, 35);*/
		
        NSArray* possibleSprites = [NSArray arrayWithObjects:@"Character Boy.png", @"Character Cat Girl.png", @"Character Horn Girl.png", @"Character Princess Girl.png", nil];
        NSString* randomSprite = [possibleSprites objectAtIndex:(arc4random() % [possibleSprites count])];
        
		self.sprite = [CCSprite spriteWithFile:randomSprite];
		
		sprite.anchorPoint = ccp(0,0);
        sprite.position = ccp(0,20);
		
		[self addChild:sprite];
	}
	return self;
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

- (void) moveInDirection:(CGPoint)direction {
	/*if(direction.x > 0) [sprite setTextureRect:right];
	if(direction.x < 0) [sprite setTextureRect:left];
	if(direction.y > 0) [sprite setTextureRect:up];
	if(direction.y < 0) [sprite setTextureRect:down];*/
}

- (void) dealloc {
	[playerID release];
	
	[super dealloc];
}

@end