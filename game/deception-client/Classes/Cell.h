//
//  Cell.h
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Cell : CCLayer {
	CGPoint point;
}

@property(nonatomic, readonly) CGPoint point;

+ (Cell*) cellAtPoint:(CGPoint)point;
- (id) initWithPoint:(CGPoint)p;

@end
