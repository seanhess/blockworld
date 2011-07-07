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
		
		[self setIsTouchEnabled:YES];
	
		CCMenuItemSprite* bombItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"bomb button.png"] selectedSprite:[CCSprite spriteWithFile:@"bomb button.png"] block:^(id sender) {
			if(bomb) bomb(YES);
		}];
		CCMenuItemSprite* wallItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"Stone Block button.png"] selectedSprite:[CCSprite spriteWithFile:@"Stone Block button.png"] block:^(id sender) {
			NSLog(@"holding down wall");
			if(wall) wall(YES);
		}];
		
		bombItem.position = ccp(0, 30);
		wallItem.position = ccp(0, -30);
		
		CCMenu* menu = [CCMenu menuWithItems:bombItem, wallItem, nil];
		
		menu.position = ccp(0,0);
		
		[self addChild:menu];
	} 
	return self;
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"ended holding down");
	
	if(wall) wall(NO);
	if(bomb) bomb(NO);
}

@end
