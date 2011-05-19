/*
 *  Item.h
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@class Cell;

@interface Item : CCLayer {
	Cell* cell;
	CCSprite* sprite;
}

@property(nonatomic, assign) Cell* cell;
@property(nonatomic, retain) CCSprite* sprite;
@property(nonatomic, retain) NSString* cachedSpriteName;
@property(nonatomic, assign) BOOL isOnScreen;

- (void) drawAllSprites;
- (void) removeAllSprites;

@end