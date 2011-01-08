/*
 *  WorldLayer.c
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "WorldLayer.h"

#import "Board.h"

@implementation WorldLayer

- (id) init {
	if((self = [super init])) {
		board = [Board node];
		
		[self addChild:board];
	} return self;
}

@end