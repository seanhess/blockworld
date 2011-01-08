/*
 *  WorldLayer.c
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "WorldLayer.h"

#import "Cell.h"

@interface WorldLayer()
- (id) keyForPoint:(CGPoint)point;
- (Cell*) cellAtPoint:(CGPoint)point;
@end

@implementation WorldLayer

- (id) init {
	if((self = [super init])) {
		board = [NSMutableDictionary new];
		
		for(int i=0; i<10; i++) {
			for (int j=0; j<10; j++) {
				[self cellAtPoint:ccp(i,j)];
			}
		}
		
	} return self;
}

- (Cell*) cellAtPoint:(CGPoint)point {
	NSString* key = [self keyForPoint:point];
	
	Cell* cell = [board objectForKey:key];
	
	if(!cell) {
		cell = [Cell cellAtPoint:point];
		[board setObject:cell forKey:key];
		[self addChild:cell];
	}
	
	return cell;
}

- (id) keyForPoint:(CGPoint)point {
	return [NSString stringWithFormat:@"%.0f %.0f", point.x, point.y];
}

- (void) dealloc {
	[board release];

	[super dealloc];
}

@end