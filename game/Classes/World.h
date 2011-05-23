/*
 *  WorldLayer.h
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "cocos2d.h"

@class Player, Cell, HUD;

@interface World : CCLayer {

    float pinchDistance;
	BOOL layingWallsPress;
    
    CCSprite* smoke;
}

@property(nonatomic, assign) BOOL layingWallsPress;
@property(nonatomic, assign) HUD* hud;

- (Player*) createPlayerWithID:(NSString*)playerID atPoint:(CGPoint)point;
- (void) createWallAtPoint:(CGPoint)point;
- (void) createBombAtPoint:(CGPoint)point;
- (void) movePlayer:(NSString*)playerID toPoint:(CGPoint)point;
- (void) destroyAtPoint:(CGPoint)point;

// hud functions
- (void) movePress:(CGPoint)point;
- (void) bombPress;

@end