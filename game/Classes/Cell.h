//
//  Cell.h
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Player, Bomb, Wall;

@interface Cell : CCLayer {
}

@property(nonatomic, readonly) CGPoint point;
@property(nonatomic, assign) BOOL isOnScreen;
@property(nonatomic, readonly) BOOL isOccupied;

// these objects are added and removed by the world, they 
// must remain public

@property(nonatomic, retain) Bomb* bomb;
@property(nonatomic, retain) Wall* wall;
@property(nonatomic, retain) Player* player;

+ (Cell*) cellAtPoint:(CGPoint)point;
- (id) initWithPoint:(CGPoint)p;

- (void) blowUp;
- (void) buildWall:(BOOL)visible;
- (void) dropBomb:(BOOL)visible;


@end
