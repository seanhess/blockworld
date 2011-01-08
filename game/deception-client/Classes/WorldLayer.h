/*
 *  WorldLayer.h
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "cocos2d.h"

@interface WorldLayer : CCLayer {
	NSMutableDictionary* board;
	
	BOOL isLayingWalls;
}

@property(nonatomic, assign) BOOL isLayingWalls;

- (void) moveAction:(CGPoint)point;
- (void) setBomb;

@end