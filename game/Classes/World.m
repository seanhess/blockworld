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
- (Player*) playerWithPlayerID:(NSString*) playerID;
@end

@implementation World

@synthesize layingWallsPress;

- (id) init {
	if((self = [super init])) {
		board = [NSMutableDictionary new];
		
		// init a 9x9 board
		for(int i=-10; i<10; i++) {
			for (int j=-10; j<10; j++) {
				[self cellAtPoint:ccp(i,j)];
			}
		}
		
	} return self;
}

- (Player*) createPlayerWithID:(NSString*)playerID atPoint:(CGPoint)point {
	Player* player = nil;
	if((player = [self playerWithPlayerID:playerID]))
		[self movePlayer:playerID toPoint:point];
	else 
		[self cellAtPoint:point].item = player = [Player playerWithPlayerID:playerID];
	
	if([playerID isEqualToString:[Settings instance].playerID]) 
		[self adjustCameraOnPlayer:[self playerWithPlayerID:playerID]];
	
	return player;
}

- (void) createWallAtPoint:(CGPoint)point {
	[self cellAtPoint:point].item = [Wall node];
}

- (void) createBombAtPoint:(CGPoint)point {
	[self cellAtPoint:point].bomb = [Bomb node];
}

- (void) movePlayer:(NSString*)playerID toPoint:(CGPoint)point {
	Player* player = [self playerWithPlayerID:playerID];
	Cell* newCell = [self cellAtPoint:point];
	Cell* oldCell = player.cell;
	
	// dont move if you've hit a wall
	if(![self canMoveToCell:newCell]) { return; }
	
	// send the player to the new cell
	newCell.item = player; 
	
	// set the sprite for the player
	[player moveInDirection:ccpSub(newCell.point, oldCell.point)];
	
	
	// lay wall if needed
	if(oldCell != newCell && layingWallsPress) {
		oldCell.item = [Wall node];
		
		Create* command = [Create command];
		[command setType:@"wall"];
		[command setPoint:oldCell.point];
        [command setPlayerID:[Settings instance].playerID];
		[command send];
	}
}

- (void) destroyAtPoint:(CGPoint)point {
	Cell* cell = [self cellAtPoint:point];
	cell.bomb = nil;
	cell.item = nil;
}

- (void) movePress:(CGPoint)point {
	Player* myplayer = [self playerWithPlayerID:[Settings instance].playerID];
	[self movePlayer:[Settings instance].playerID toPoint:ccpAdd(myplayer.cell.point, point)];
	[self adjustCameraOnPlayer:myplayer];
	
	Move* command = [Move command];
	[command setPlayerID:[Settings instance].playerID];
	[command setPoint:myplayer.cell.point];
	[command send];
}

- (void) bombPress {
	layingWallsPress = NO;
	
	Player* myplayer = [self playerWithPlayerID:[Settings instance].playerID];
	Cell* cell = myplayer.cell;
	
	Create* command = [Create command];
    [command setPlayerID:[Settings instance].playerID];
	[command setType:@"bomb"];
	[command setPoint:cell.point];
	[command send];
}

- (BOOL) canMoveToCell:(Cell*)cell {
	return !cell.item && !cell.bomb;
}

- (Player*) playerWithPlayerID:(NSString*) playerID {
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
        
        
        // the cell z index will be the reverse y, the higher up the y,
        // the lower drawing priority it will have, or the further in the
        // background it will be
        
		[self addChild:cell z:-point.y];
	}
	
	return cell;
}

- (void) adjustCameraOnPlayer:(Player*)player {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	
	float x, y, z;
	[self.camera centerX:&x centerY:&y centerZ:&z];
	[self.camera eyeX:&x eyeY:&y eyeZ:&z];
	
	if(POINT_TO_PIXEL_X(player.cell.point.x) < x+SCREEN_FOLLOW_THRESHOLD)
		x = POINT_TO_PIXEL_X(player.cell.point.x)-SCREEN_FOLLOW_THRESHOLD;
	if(POINT_TO_PIXEL_X(player.cell.point.x) > x+screenRect.size.height-SCREEN_FOLLOW_THRESHOLD)
		x = POINT_TO_PIXEL_X(player.cell.point.x)-screenRect.size.height+SCREEN_FOLLOW_THRESHOLD;
	if(POINT_TO_PIXEL_Y(player.cell.point.y) < y+SCREEN_FOLLOW_THRESHOLD)
		y = POINT_TO_PIXEL_Y(player.cell.point.y)-SCREEN_FOLLOW_THRESHOLD;
	if(POINT_TO_PIXEL_Y(player.cell.point.y) > y+screenRect.size.width-SCREEN_FOLLOW_THRESHOLD)
		y = POINT_TO_PIXEL_Y(player.cell.point.y)-screenRect.size.width+SCREEN_FOLLOW_THRESHOLD;
	
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