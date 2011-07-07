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
#import "MainMenu.h"
#import "Settings.h"
#import "HUD.h"

#import "CCNode+Additions.h"


@interface World()
@property(nonatomic, retain) NSMutableDictionary* players;
@property(nonatomic, retain) NSMutableDictionary* board;
- (id) keyForPoint:(CGPoint)point;
- (Cell*) cellAtPoint:(CGPoint)point;
- (void) adjustCameraOnPlayer:(Player*)player;
- (void) drawSeenCells;
- (void) undrawUnseenCells;
- (CGRect) visibleGridRect;
- (void) kickToMenu;
@end

@implementation World

@synthesize layingWallsPress, hud, players, board, holdingDownWallButton, holdingDownBombButton;

- (id) init {
	if((self = [super init])) {
		self.board = [NSMutableDictionary dictionary];
        self.players = [NSMutableDictionary dictionary];
        self.isTouchEnabled = YES;
        
        [self drawSeenCells];
        [self undrawUnseenCells];
		
	} return self;
}

- (Player*) createPlayerWithID:(NSString*)playerID atPoint:(CGPoint)point {
    
    
	Player* player = [self playerWithPlayerID:playerID];
	
    if(player)
		[self movePlayer:playerID toPoint:point];
	else {
        player = [Player playerWithPlayerID:playerID];
        [self.players setObject:player forKey:playerID];
		[self cellAtPoint:point].player = player;
    }
	
    
    
	if([playerID isEqualToString:[Settings instance].playerID]) 
		[self adjustCameraOnPlayer:[self playerWithPlayerID:playerID]];
	
    
	return player;
}

- (void) createWallAtPoint:(CGPoint)point {
	[[self cellAtPoint:point] buildWall];
}

- (void) createBombAtPoint:(CGPoint)point {
	[[self cellAtPoint:point] dropBomb];
}

- (void) sendMoveCommandToPoint:(CGPoint)point {

}

- (BOOL) movePlayer:(NSString*)playerID toPoint:(CGPoint)point {
	Player* player = [self playerWithPlayerID:playerID];
	Cell* newCell = [self cellAtPoint:point];
	Cell* oldCell = player.cell;
	
	if([playerID isEqualToString:[Settings instance].playerID]) { [self adjustCameraOnPlayer:player]; }
	
	
	// send the player to the new cell
    oldCell.player = nil;
	newCell.player = player;
	
	
	// set the sprite for the player
	[player moveInDirection:ccpSub(newCell.point, oldCell.point)];
	
	
	// lay wall or bomb if needed
	if(oldCell != newCell && [[Settings instance].playerID isEqualToString:playerID]) {
		
		if(self.holdingDownWallButton) {
					
			Create* command = [Create command];
			[command setType:@"wall"];
			[command setPoint:oldCell.point];
			[command setPlayerID:[Settings instance].playerID];
			[command send];
			
		} else if(self.holdingDownBombButton) {
		
			Create* command = [Create command];
			[command setType:@"bomb"];
			[command setPoint:oldCell.point];
			[command setPlayerID:[Settings instance].playerID];
			[command send];
		
		}
	}
    
    return YES;
}

- (void) destroyAtPoint:(CGPoint)point {
	Cell* cell = [self cellAtPoint:point];
	
    
    if(cell.player) { [self playerDidDie:cell.player]; }
    
    if(cell.bomb) { 
        
        CCNode* explotion = [cell.bomb explotion];
        CCNode* expletive = [cell.bomb expletive];
        
        explotion.position = ccpAdd(explotion.position, cell.position);
        expletive.position = ccpAdd(expletive.position, cell.position); 
        
        [self addChild:explotion z:cell.zOrder+100];
        [self addChild:expletive z:cell.zOrder+101];
        
    }
    
    [cell blowUp];
}

- (void) playerDidDie:(Player*)player {
    if(!player) { return; }
	
	player.cell.player = nil;
	
    
    if([player.playerID isEqualToString:[Settings instance].playerID]) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        CCSprite* sprite = [CCSprite spriteWithFile:@"gameover.png"];
        sprite.scale = .2;
        sprite.position = ccp(CGRectGetMidY(screenRect), CGRectGetMidX(screenRect));
        [sprite runAction:[CCScaleTo actionWithDuration:.7 scale:1.f]];
        [sprite runAction:[CCFadeIn actionWithDuration:.7]];
        
        [self.parent addChild:sprite];
        
        self.hud.visible = NO;
        
        [[CCScheduler sharedScheduler] scheduleSelector:@selector(kickToMenu) forTarget:self interval:2.f paused:NO];
    }
	
	
	// this must happen at the very last so the player doesn't get dealloc'd
	// too soon.  it will crash if anything tries to access player after this
	
	[self.players removeObjectForKey:player.playerID];
}

- (void) movePress:(CGPoint)point {
	Player* myplayer = [self playerWithPlayerID:[Settings instance].playerID];
	
	Move* command = [Move command];
	[command setPlayerID:[Settings instance].playerID];
	[command setPoint:ccpAdd(myplayer.cell.point, point)];
	[command send];
}

- (void) setHoldingDownBombButton:(BOOL)flag {

	if (!self.holdingDownBombButton && flag) {
		Player* player = [self playerWithPlayerID:[Settings instance].playerID];
		Cell* cell = player.cell;

		if(!cell.bomb) {
			Create* command = [Create command];
			[command setType:@"bomb"];
			[command setPoint:cell.point];
			[command setPlayerID:[Settings instance].playerID];
			[command send];
		}
	}
	
	holdingDownBombButton = flag;
}

- (void) kickToMenu {
    [self cleanup];
    [[CCDirector sharedDirector] replaceScene:[MainMenu scene]];
}

- (Player*) playerWithPlayerID:(NSString*) playerID {
    return [players objectForKey:playerID];
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
    
    cell.isOnScreen = YES;
	
	return cell;
}

- (void) adjustCameraOnPlayer:(Player*)player {
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	
	float x, y, z;
    
	[self.camera centerX:&x centerY:&y centerZ:&z];
	
    float oldx = x, oldy = y, oldz = z;
    
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
    
    if(oldx != x || oldy != y || oldz != z) {
        [self drawSeenCells];
        [self undrawUnseenCells];
    }
}

- (void) drawSeenCells {
    CGRect visibleGridRect = [self visibleGridRect];
    
    for(int x=visibleGridRect.origin.x; x<CGRectGetMaxX(visibleGridRect); x++) {
        for(int y=visibleGridRect.origin.y; y<CGRectGetMaxY(visibleGridRect); y++) {
            [self cellAtPoint:ccp(x,y)].isOnScreen = YES;
        }
    }
}

- (void) undrawUnseenCells {
    
    CGRect visibleGridRect = [self visibleGridRect];
    
    for(Cell* cell in [board allValues]) {
        if(!CGRectContainsPoint(visibleGridRect, cell.point)) {
            cell.isOnScreen = NO;
        }
    }
}

- (CGRect) visibleGridRect {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    float padding = 1;
    float x, y, z;
    
    [self.camera centerX:&x centerY:&y centerZ:&z];
    
    return CGRectMake(PIXEL_TO_POINT_X(x)-padding, PIXEL_TO_POINT_Y(y)-padding, (int)screenRect.size.height/PIXEL_PER_UNIT_X+padding*2, (int)screenRect.size.width/PIXEL_PER_UNIT_Y+padding*2);
}

- (id) keyForPoint:(CGPoint)point {
	return [NSString stringWithFormat:@"%.0f %.0f", point.x, point.y];
}

/*- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if([touches count] >= 2) {
        CGPoint touchOne = [self touchRelativeToCamera:[[touches allObjects] objectAtIndex:0]];
        CGPoint touchTwo = [self touchRelativeToCamera:[[touches allObjects] objectAtIndex:1]];
        
        pinchDistance = ccpDistance(touchOne, touchTwo);
        
        float x,y,z;
        [self.camera centerX:&x centerY:&y centerZ:&z];
        
        [self.camera setEyeX:x eyeY:y eyeZ:pinchDistance];
        
        NSLog(@"pinch distance %f", pinchDistance);
    } else {
        NSLog(@"one touch detected");
    }
}*/

- (void) cleanup {
    [super cleanup];
    
    [ServerCommunicator instance].messageReceivedCallback = nil;
    [hud cleanup];
}

- (void) dealloc {
    NSLog(@"world dealloc'd");
	[board release];
    [players release];

	[super dealloc];
}

@end