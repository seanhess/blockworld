//
//  HUD.h
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class DirectionPad;

@interface HUD : CCLayer {
	DirectionPad* directionPad;
}

@end
