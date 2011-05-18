//
//  ActionPad.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionPad.h"


@implementation ActionPad

@synthesize bomb, wall;

-(id) init {
	if((self = [super init])) {
		CCMenuItemSprite* bombItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"bomb button.png"] selectedSprite:[CCSprite spriteWithFile:@"bomb button.png"] block:^(id sender) {
			if(bomb) bomb();
		}];
		CCMenuItemSprite* wallItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"Stone Block button.png"] selectedSprite:[CCSprite spriteWithFile:@"Stone Block button.png"] block:^(id sender) {
			if(wall) wall();
		}];
		
		bombItem.position = ccp(0, 30);
		wallItem.position = ccp(0, -30);
		
		CCMenu* menu = [CCMenu menuWithItems:bombItem, wallItem, nil];
		
		menu.position = ccp(0,0);
		
		[self addChild:menu];
	} 
	return self;
}

@end
