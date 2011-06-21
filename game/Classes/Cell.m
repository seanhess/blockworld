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
#import "Wall.h"
#import "Player.h"

@interface Cell()
@property(nonatomic, retain) CCSprite* grass;
@property(nonatomic, retain) CCSprite* bush;
@property(nonatomic, retain) NSString* bushName;
@end

@implementation Cell

@synthesize point, wall, bomb, bush, isOnScreen, bushName, grass, player;


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
    [self.wall drawAllSprites];
    [self.bomb drawAllSprites];
    
    
    
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
    [self.wall removeAllSprites];
    [self.bomb removeAllSprites];
    
    [self removeChild:grass cleanup:YES];
    if(self.bushName) { [self removeChild:self.bush cleanup:YES]; }
    
    self.grass = nil;
    self.bush = nil;

}

- (void) setPlayer:(Player *)newPlayer {
    if(player == newPlayer) { return; }
    
    [player autorelease];
	[player.parent removeChild:player cleanup:YES];
	
    player = [newPlayer retain];
    
    if(!player) { return; }
    
    
    NSLog(@"setting player to %f %f", self.point.x, self.point.y);
    
    player.cell = self;
    
    [player.parent removeChild:player cleanup:YES];
    [self addChild:player z:4];
}

- (void) blowUp {
    if(self.wall) { 
        [self removeChild:self.wall cleanup:YES]; 
        self.wall = nil; 
    }
    
    if(self.bomb) {
        [self removeChild:self.bomb cleanup:YES];
        self.bomb = nil;
    }
}

- (void) buildWall {
    if(self.wall) { [self removeChild:self.wall cleanup:YES]; } 
    if(self.bushName) { self.bushName = nil; }
    if(self.bush) { [self removeChild:self.bush cleanup:YES]; }
    
    self.wall = [Wall node];
    
    [self addChild:self.wall z:2];
}

- (void) dropBomb {
    if(self.bomb) { [self removeChild:self.bomb cleanup:YES]; }
    
    self.bomb = [Bomb node];
    
    [self addChild:self.bomb z:3];
}

- (BOOL) isOccupied {
    return self.bomb || self.wall;
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
    [player release];
	[wall release];
    [bomb release];
    [bush release];
	
	[super dealloc];
}

@end
