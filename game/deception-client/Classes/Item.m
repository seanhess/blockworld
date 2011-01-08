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
	sprite.position = ccp(cell.point.x*PIXEL_PER_UNIT, cell.point.y*PIXEL_PER_UNIT);
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