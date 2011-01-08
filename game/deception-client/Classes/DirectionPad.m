//
//  DirectionPad.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DirectionPad.h"


@implementation DirectionPad

@synthesize move;

- (id) init {
	if((self = [super init])) {
		
		texture = [[CCTextureCache sharedTextureCache] addImage:@"dir_dpad.png"];
		
		CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, 80, 80)];
		CCSprite* sprite = [CCSprite spriteWithSpriteFrame:frame];
		
		sprite.position = ccp(0, 0);
		
		[self addChild:sprite];
		
		CCMenuItem* up = [CCMenuItem itemWithBlock:^(id sender) {
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
		
		[self addChild:menu];
		
	} return self;
}

- (void) dealloc {
	[move release];
	
	[super dealloc];
}

@end
