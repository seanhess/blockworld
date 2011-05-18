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

@synthesize cell, sprite;

- (void) dealloc {
	[cell release];
	[sprite release];
    
	[super dealloc];
}

@end