/*
 *  GameScene.h
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "cocos2d.h"

@class World, HUD, Command;

@interface GameScene : CCScene {
	World* world;
	HUD* hud;
}

+(id) sceneWithCommand:(Command*)command;
-(id) initWithCommand:(Command*)command;

@end