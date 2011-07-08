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
#import "MainMenu.h"

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
		
		// HUD actions
		[hud setMoveCallback:^(int x, int y) {
			[world movePress:ccp(x,y)];
		}];
		
		[hud setBombCallback:^(BOOL isPressed) {
			world.holdingDownBombButton = isPressed;
		}];
		
		[hud setWallCallback:^(BOOL isPressed) {
			world.holdingDownWallButton = isPressed;
		}];
		
		
        
        //world to hud actions
        world.hud = hud;
        
        
		// server call backs
		[ServerCommunicator instance].messageReceivedCallback = ^(NSDictionary* definition) {
			[[Command commandWithDefinition:definition world:world] execute];
		};
        
        
        // watch for disconnects, and go back to the menu
		[ServerCommunicator instance].statusChangedCallback = ^(server_status status) {
        
            if(status == disconnected) { 
                [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
                [[ServerCommunicator instance] connect];
            }
            
            else {}        
        };
	}
	return self;
}


@end

