//
//  CCNode+Additions.m
//  DuckRalf
//
//  Created by Bryce Redd on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCNode+Additions.h"


@implementation CCNode(Additions)

- (CGPoint) touchRelativeToCamera:(UITouch*)touch {
	float x, y, z;
	[self.camera centerX:&x centerY:&y centerZ:&z];
	
	CGPoint location = [touch locationInView:[touch view]];
	location = [[CCDirector sharedDirector] convertToGL:location];
	
	return ccp(location.x+x, location.y+y);
}

@end
