/*
 *  Item.m
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "Item.h"

#import "Cell.h"

@implementation Item

@synthesize cell;

- (void) positionSprite {
	sprite.position = ccp(POINT_TO_PIXEL_X(cell.point.x), POINT_TO_PIXEL_Y(cell.point.y));
}

- (void) setCell:(Cell *)c {
	cell = c;
	
	[self positionSprite];
}

- (void) dealloc {
	[cell release];
	
	[super dealloc];
}

@end