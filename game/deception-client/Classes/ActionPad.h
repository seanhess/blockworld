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

@interface ActionPad : CCLayer {
	Block wall;
	Block bomb;
}

@property(nonatomic, copy) Block wall;
@property(nonatomic, copy) Block bomb;

@end
