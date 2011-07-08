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
    
    CCSprite* smoke;
}

@property(nonatomic, assign) BOOL layingWallsPress;
@property(nonatomic, assign) HUD* hud;

@property(nonatomic, assign) BOOL holdingDownBombButton;
@property(nonatomic, assign) BOOL holdingDownWallButton;


- (Player*) createPlayerWithID:(NSString*)playerID atPoint:(CGPoint)point;
- (void) createWallAtPoint:(CGPoint)point;
- (void) createBombAtPoint:(CGPoint)point;
- (BOOL) movePlayer:(NSString*)playerID toPoint:(CGPoint)point;
- (void) destroyAtPoint:(CGPoint)point;
- (void) playerDidDie:(Player*)player;
- (Player*) playerWithPlayerID:(NSString*)playerID;

// hud functions
- (void) movePress:(CGPoint)point;

@end