//
//  CCNode+Additions.h
//  DuckRalf
//
//  Created by Bryce Redd on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCNode(Additions)

- (CGPoint) touchRelativeToCamera:(UITouch*)touch;

@end
