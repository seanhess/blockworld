/*
 *  WorldLayer.c
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "World.h"

#import "Cell.h"
#import "Bomb.h"
#import "Wall.h"
#import "Player.h"
#import "Create.h"
#import "Move.h"
#import "Settings.h"

@interface World()
- (id) keyForPoint:(CGPoint)point;
- (Cell*) cellAtPoint:(CGPoint)point;
- (BOOL) canMoveToCell:(Cell*)cell;
- (void) adjustCameraOnPlayer:(Player*)player;
- (Player*) playerWithID:(NSString*) playerID;
@end

@implementation World

@synthesize layingWallsPress;

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
		
	} return self;
}

- (void) createPlayerWithID:(NSString*)playerID atPoint:(CGPoint)point {
	if([self playerWithID:playerID]) 
		[self movePlayer:playerID toPoint:point];
	else 
		[self cellAtPoint:point].item = [Player playerWithPlayerID:playerID];
}

- (void) createWallAtPoint:(CGPoint)point {
	[self cellAtPoint:point].item = [Wall node];
}

- (void) createBombAtPoint:(CGPoint)point {
	[self cellAtPoint:point].bomb = [Bomb node];
}

- (void) movePlayer:(NSString*)playerID toPoint:(CGPoint)point {
	Player* player = [self playerWithID:playerID];
	Cell* newCell = [self cellAtPoint:point];
	Cell* oldCell = player.cell;
	
	// dont move if you've hit a wall
	if(![self canMoveToCell:newCell]) { return; }
	
	// send the player to the new cell
	newCell.item = player; 
	
	// lay wall if needed
	if(oldCell != newCell && layingWallsPress) {
		oldCell.item = [Wall node];
		
		Create* command = [Create command];
		[command setType:@"wall"];
		[command setPoint:oldCell.point];
		[command send];
	}
}

- (void) destroyAtPoint:(CGPoint)point {
	Cell* cell = [self cellAtPoint:point];
	cell.bomb = nil;
	cell.item = nil;
}

- (void) movePress:(CGPoint)point {
	Player* myplayer = [self playerWithID:[Settings instance].playerID];
	[self movePlayer:[Settings instance].playerID toPoint:ccpAdd(myplayer.cell.point, point)];
	[self adjustCameraOnPlayer:myplayer];
	
	Move* command = [Move command];
	[command setPlayerID:[Settings instance].playerID];
	[command send];
}

- (void) bombPress {
	layingWallsPress = NO;
	
	Player* myplayer = [self playerWithID:[Settings instance].playerID];
	Cell* cell = myplayer.cell;
	
	Create* command = [Create command];
	[command setType:@"bomb"];
	[command setPoint:cell.point];
	[command send];
}

- (BOOL) canMoveToCell:(Cell*)cell {
	return !cell.item && !cell.bomb;
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

- (void) adjustCameraOnPlayer:(Player*)player {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	
	float x, y, z;
	[self.camera centerX:&x centerY:&y centerZ:&z];
	[self.camera eyeX:&x eyeY:&y eyeZ:&z];
	
	if(player.cell.point.x*PIXEL_PER_UNIT < x+SCREEN_FOLLOW_THRESHOLD)
		x = player.cell.point.x*PIXEL_PER_UNIT-SCREEN_FOLLOW_THRESHOLD;
	if(player.cell.point.x*PIXEL_PER_UNIT > x+screenRect.size.height-SCREEN_FOLLOW_THRESHOLD)
		x = player.cell.point.x*PIXEL_PER_UNIT-screenRect.size.height+SCREEN_FOLLOW_THRESHOLD;
	if(player.cell.point.y*PIXEL_PER_UNIT < y+SCREEN_FOLLOW_THRESHOLD)
		y = player.cell.point.y*PIXEL_PER_UNIT-SCREEN_FOLLOW_THRESHOLD;
	if(player.cell.point.y*PIXEL_PER_UNIT > y+screenRect.size.width-SCREEN_FOLLOW_THRESHOLD)
		y = player.cell.point.y*PIXEL_PER_UNIT-screenRect.size.width+SCREEN_FOLLOW_THRESHOLD;
	
	[self.camera setCenterX:x centerY:y centerZ:0.0];
	[self.camera setEyeX:x eyeY:y eyeZ:[CCCamera getZEye]];
}

- (id) keyForPoint:(CGPoint)point {
	return [NSString stringWithFormat:@"%.0f %.0f", point.x, point.y];
}

- (void) dealloc {
	[board release];

	[super dealloc];
}

@end