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
#import "Player.h"

@interface Cell()
@property(nonatomic, retain) CCSprite* bush;
@end

@implementation Cell

@synthesize point, item, bomb, bush, isOnScreen;


+ (Cell*) cellAtPoint:(CGPoint)p {
	return [[[Cell alloc] initWithPoint:p] autorelease];
}

- (id) initWithPoint:(CGPoint)p {
	if((self = [super init])) {
		point = p;
		
        
        CCSprite* sprite = [CCSprite spriteWithFile:@"Grass Block.png"];
        sprite.anchorPoint = ccp(0,0);
        [self addChild:sprite z:1];
        
        
        NSArray* possibleSprites = [NSArray arrayWithObjects:@"Tree Tall.png", @"Tree Short.png", @"Tree Ugly.png", nil];
        
        if(arc4random()%10 < 1) {
            self.bush = [CCSprite spriteWithFile:[possibleSprites objectAtIndex:(arc4random() % [possibleSprites count])]];
            self.bush.anchorPoint = ccp(0,0);
            self.bush.position = ccp(0,20);
            [self addChild:self.bush z:2];
        }

        
		
		self.position = ccp(POINT_TO_PIXEL_X(p.x), POINT_TO_PIXEL_Y(p.y));
		
		
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
	
    
    
	if(item) {
        
        if(self.bush && ![item isKindOfClass:[Player class]]) { 
            [self removeChild:self.bush cleanup:YES];
            self.bush = nil;
        }
        
		[self addChild:item z:3];
        
    }
}

- (void) setBomb:(Bomb*)b {
	if(bomb)
		[self removeChild:bomb cleanup:YES];
	
	[bomb autorelease];
	bomb = [b retain];
	
	bomb.cell = self;
	
    
	if(bomb) {
		[self addChild:bomb z:1];
    } 
    
}

- (void) setIsOnScreen:(BOOL)boolean {
    isOnScreen = boolean;
    
    self.visible = boolean;
}

- (void) dealloc {
	self.item = nil;
    self.bomb = nil;
    self.bush = nil;
	
	[super dealloc];
}

@end
