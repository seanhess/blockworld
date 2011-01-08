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
#import "ServerCommunicator.h"
#import "Command.h"

@implementation GameScene

+(id) sceneWithCommand:(Command*)command {
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

-(id) initWithCommand:(Command*)command {
	if((self = [super init])) {
		// add World
		world = [World node];
		[self addChild:world];
		
		// add HUD
		hud = [HUD node];
		[self addChild:hud];
		
		// HUD actions
		[hud setMoveCallback:^(int x, int y) {
			[world movePress:ccp(x,y)];
		}];
		
		[hud setOnBombCallback:^{
			[world bombPress];
		}];
		
		[hud setOnWallCallback:^{
			world.layingWallsPress = !world.layingWallsPress;
		}];
		
		// server call backs
		[ServerCommunicator instance].messageReceivedCallback = ^(NSDictionary* definition) {
			[[Command commandWithDefinition:definition world:world] execute];
		};
		
		// run the initial command
		[[Command commandWithDefinition:command.definition world:world] execute];
		
	}
	return self;
}


@end

