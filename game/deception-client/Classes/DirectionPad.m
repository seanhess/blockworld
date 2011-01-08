//
//  DirectionPad.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DirectionPad.h"


@implementation DirectionPad

- (id) init {
	if((self = [super init])) {
		
		texture = [[CCTextureCache sharedTextureCache] addImage:@"dir_dpad.png"];
		
		CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:CGRectMake(0, 0, 80, 80)];
		CCSprite* sprite = [CCSprite spriteWithSpriteFrame:frame];
		
		sprite.position = ccp(400, 50);
		
		[self addChild:sprite];
		
	} return self;
}

- (void) up {
	
}

@end
