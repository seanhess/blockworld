/*
 *  GameScene.m
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "GameScene.h"

#import "World.h"
#import "HUD.h"

@implementation GameScene

+(id) scene {
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

-(id) init {
	if((self = [super init])) {
		// add World
		world = [World node];
		[self addChild:world];
		
		// add HUD
		hud = [HUD node];
		[self addChild:hud];
		
		[hud setMoveCallback:^(int x, int y) {
			[world movePress:ccp(x,y)];
		}];
		
		[hud setOnBombCallback:^{
			[world bombPress];
		}];
		
		[hud setOnWallCallback:^{
			world.layingWallsPress = !world.layingWallsPress;
		}];
		
	}
	return self;
}


@end

