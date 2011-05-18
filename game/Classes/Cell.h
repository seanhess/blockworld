//
//  Cell.h
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Item, Bomb;

@interface Cell : CCLayer {
	CGPoint point;
	Item* item;
	Bomb* bomb;
}

@property(nonatomic, readonly) CGPoint point;
@property(nonatomic, retain) Item* item;
@property(nonatomic, retain) Bomb* bomb;
@property(nonatomic, assign) BOOL isOnScreen;

+ (Cell*) cellAtPoint:(CGPoint)point;
- (id) initWithPoint:(CGPoint)p;


@end
