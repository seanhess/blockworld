//
//  Cell.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"


@interface Cell()
+ (CCSpriteBatchNode*) spriteSheet;
@end

@implementation Cell

@synthesize point;

static CCSpriteBatchNode* cellSpriteSheet;

+ (CCSpriteBatchNode*) spriteSheet {
	if(!cellSpriteSheet) {
		cellSpriteSheet = [[CCSpriteBatchNode batchNodeWithFile:@"bluetile.png" capacity:100] retain];
	}
	return cellSpriteSheet;
}

+ (Cell*) cellAtPoint:(CGPoint)p {
	return [[[Cell alloc] initWithPoint:p] autorelease];
}

- (id) initWithPoint:(CGPoint)p {
	if((self = [super init])) {
		CCSprite* sprite = [CCSprite spriteWithBatchNode:[Cell spriteSheet] rect:CGRectMake(0, 0, 40, 40)];
		point = p;
		self.position = ccp(p.x*PIXEL_PER_UNIT, p.y*PIXEL_PER_UNIT);
		[self addChild:sprite];
	} return self;
}

@end
