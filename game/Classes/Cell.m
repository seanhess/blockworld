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
@property(nonatomic, retain) CCSprite* grass;
@property(nonatomic, retain) CCSprite* bush;
@property(nonatomic, retain) NSString* bushName;
@end

@implementation Cell

@synthesize point, item, bomb, bush, isOnScreen, bushName, grass;


+ (Cell*) cellAtPoint:(CGPoint)p {
	return [[[Cell alloc] initWithPoint:p] autorelease];
}

- (id) initWithPoint:(CGPoint)p {
	if((self = [super init])) {
		point = p;
		
        
        if(arc4random()%10 < 1) {
            NSArray* possibleSprites = [NSArray arrayWithObjects:@"Tree Tall.png", @"Tree Short.png", @"Tree Ugly.png", nil];
            self.bushName = [possibleSprites objectAtIndex:(arc4random() % [possibleSprites count])];
            
        }

		self.position = ccp(POINT_TO_PIXEL_X(p.x), POINT_TO_PIXEL_Y(p.y));
		
        [self setIsOnScreen:YES];
		
	} return self;
}

- (void) drawAllSprites {
    [self.item drawAllSprites];
    
    
    
    // draw the grass
    
    self.grass = [CCSprite spriteWithFile:@"Grass Block.png"];
    grass.anchorPoint = ccp(0,0);
    [self addChild:self.grass z:1];
    
    
    
    // draw the bush (if it's there)
    
    if(self.bushName) {
        self.bush = [CCSprite spriteWithFile:bushName];
        self.bush.anchorPoint = ccp(0,0);
        self.bush.position = ccp(0,20);
        [self addChild:self.bush z:2];
    }

}

- (void) removeAllSprites {
    [self.item removeAllSprites];
    
    [self removeChild:grass cleanup:YES];
    if(self.item) { [self removeChild:self.item cleanup:YES]; }
    if(self.bushName) { [self removeChild:self.bush cleanup:YES]; }
    
    self.grass = nil;
    self.bush = nil;

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
            self.bushName = nil;
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
		[self addChild:bomb z:3];
    } 
    
}

- (void) setIsOnScreen:(BOOL)boolean {
    
    if(isOnScreen == boolean) { return; }
    
    isOnScreen = boolean;
    
    
    
    if(isOnScreen) {
        [self drawAllSprites];
    } else {
        [self removeAllSprites];
    }
    

}

- (void) dealloc {
	self.item = nil;
    self.bomb = nil;
    self.bush = nil;
	
	[super dealloc];
}

@end
