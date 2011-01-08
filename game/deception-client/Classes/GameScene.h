/*
 *  GameScene.h
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "cocos2d.h"

@class WorldLayer, HUD;

@interface GameScene : CCScene {
	WorldLayer* world;
	HUD* hud;
}

+(id) scene;

@end