//
//  DirectionPad.h
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DirectionPad : CCLayer {
	void(^move)(int, int);
}

@property(nonatomic, copy) void(^move)(int, int);

@end
