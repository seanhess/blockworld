/*
 *  GameScene.m
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "GameScene.h"

#import "WorldLayer.h"
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
		world = [WorldLayer node];
		[self addChild:world];
		
		// add HUD
		hud = [HUD node];
		[self addChild:hud];
		
	}
	return self;
}


@end

