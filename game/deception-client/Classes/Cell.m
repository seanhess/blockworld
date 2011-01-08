//
//  Cell.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"

#import "Item.h"
#import "Bomb.h"

@implementation Cell

@synthesize point, item, bomb;

+ (Cell*) cellAtPoint:(CGPoint)p {
	return [[[Cell alloc] initWithPoint:p] autorelease];
}

- (id) initWithPoint:(CGPoint)p {
	if((self = [super init])) {
		point = p;
		
		CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:@"grasses.png"];
		
		float rand = CCRANDOM_0_1();
		CGRect rect = CGRectMake(13, 6, 40, 40);
		if(rand > .8)
			rect = CGRectMake(59, 6, 40, 40);
		else if (rand > .1)
			rect = CGRectMake(99, 6, 40, 40);
			
		
		CCSpriteFrame* frame = [CCSpriteFrame frameWithTexture:texture rect:rect];
		CCSprite* sprite = [CCSprite spriteWithSpriteFrame:frame];
		
		sprite.anchorPoint = ccp(0,0);
		sprite.position = ccp(p.x*PIXEL_PER_UNIT, p.y*PIXEL_PER_UNIT);
		
		[self addChild:sprite];
		
	} return self;
}

- (void) setItem:(Item *)i {
	if(item)
		[self removeChild:item cleanup:YES];
	
	[item autorelease];	
	item = [i retain];
	
	// make sure the items previous cell doesn't have it added
	item.cell.item = nil;
	item.cell = self;
	
	if(item)
		[self addChild:item];
}

- (void) setBomb:(Bomb*)b {
	if(bomb)
		[self removeChild:bomb cleanup:YES];
	
	[bomb autorelease];
	bomb = [b retain];
	
	bomb.cell = self;
	
	if(bomb)
		[self addChild:bomb];
}

- (void) dealloc {
	self.item = nil;
	
	[super dealloc];
}

@end
