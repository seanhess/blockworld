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
        
		sprite = [CCSprite spriteWithFile:randomSprite];
		
		sprite.anchorPoint = ccp(0,0);
		
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
		nicknameLabel = [CCLabelTTF labelWithString:nickname fontName:@"Helvetica" fontSize:11];
		nicknameLabel.anchorPoint = ccp(0,0);
		[self addChild:nicknameLabel];
		
		[self positionSprite];
	}
}

- (void) positionSprite {
	[super positionSprite];
	
	nicknameLabel.position = ccp(POINT_TO_PIXEL_X(cell.point.x),POINT_TO_PIXEL_Y(cell.point.y)+30);
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