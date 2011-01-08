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
#import "Bomb.h"
#import "Wall.h"
#import "Player.h"
#import "Settings.h"

@interface WorldLayer()
- (id) keyForPoint:(CGPoint)point;
- (Cell*) cellAtPoint:(CGPoint)point;
- (BOOL) canMoveToCell:(Cell*)cell;
- (void) adjustCameraOnPlayer:(Player*)player;
@end

@implementation WorldLayer

@synthesize isLayingWalls;

- (id) init {
	if((self = [super init])) {
		board = [NSMutableDictionary new];
		
		// init a 9x9 board
		for(int i=0; i<9; i++) {
			for (int j=0; j<9; j++) {
				[self cellAtPoint:ccp(i,j)];
			}
		}
		
		// init a player
		[Settings instance].playerID = @"myself";
		Cell* cell = [self cellAtPoint:ccp(4,4)];
		Player* player = [[Player alloc] initWithPlayerID:@"myself"];
		cell.item = player;
		
	} return self;
}

- (Player*) playerWithID:(NSString*) playerID {
	for(Cell* cell in [board allValues]) {
		if(cell.item && [cell.item isKindOfClass:[Player class]]) {
			if([((Player*)cell.item).playerID isEqualToString:playerID]) {
				return (Player*)cell.item;
			}
		}
	}
	
	return nil;
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

- (BOOL) canMoveToCell:(Cell*)cell {
	return !cell.item && !cell.bomb;
}

- (void) moveAction:(CGPoint)point {
	Player* myplayer = [self playerWithID:[Settings instance].playerID];
	
	Cell* oldCell = myplayer.cell;
	Cell* newCell = [self cellAtPoint:ccpAdd(myplayer.cell.point, point)];
	
	// dont move if you've hit a wall
	if(![self canMoveToCell:newCell]) { return; }
	
	// send the player to the new cell
	newCell.item = myplayer; 
	
	// lay wall if needed
	if(oldCell != newCell && isLayingWalls) {
		oldCell.item = [Wall node];
	}
	
	[self adjustCameraOnPlayer:myplayer];
}

- (void) setBomb {
	isLayingWalls = NO;
	
	Player* myplayer = [self playerWithID:[Settings instance].playerID];
	
	Cell* cell = myplayer.cell;
	
	cell.bomb = [Bomb node];
}

- (void) adjustCameraOnPlayer:(Player*)player {
	float x, y, z;
	[self.camera centerX:&x centerY:&y centerZ:&z];
	NSLog(@"%f %f %f", x, y, z);
	
	NSLog(@"%f %f", player.cell.point.x*PIXEL_PER_UNIT, player.cell.point.y*PIXEL_PER_UNIT);
}

- (id) keyForPoint:(CGPoint)point {
	return [NSString stringWithFormat:@"%.0f %.0f", point.x, point.y];
}

- (void) dealloc {
	[board release];

	[super dealloc];
}

@end