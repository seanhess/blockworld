//
//  ActionPad.h
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Blocks.h"
#import "SpriteButton.h"

@interface ActionPad : CCLayer <SpriteButtonDelegate> {}

@property(nonatomic, copy) void(^wall)(BOOL);
@property(nonatomic, copy) void(^bomb)(BOOL);

@end
