//
//  HUD.h
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Blocks.h"

@class DirectionPad, ActionPad;

@interface HUD : CCLayer {
	DirectionPad* directionPad;
	ActionPad* actionPad;
}

- (void) setMoveCallback:(void(^)(int, int))callback;
- (void) setBombCallback:(void(^)(BOOL))callback;
- (void) setWallCallback:(void(^)(BOOL))callback;

- (void) cleanup;

@end
