//
//  Global.m
//  deception-client
//
//  Created by Bryce Redd on 6/23/11.
//  Copyright 2011 i.TV. All rights reserved.
//

#import "Global.h"
#import "Player.h"
#import "World.h"


@implementation Global

- (id)init
{
    self = [super init];
    if (self) {
        NSAssert(0, @"Bad!  Global commands should never be sent from a client");
    }
    
    return self;
}

-(void) execute {
	for(NSDictionary* tile in [[self.definition objectForKey:@"data"] objectForKey:@"tiles"]) {
		int x = [[tile objectForKey:@"x"] intValue];
		int y = [[tile objectForKey:@"y"] intValue];
		
		if([[tile objectForKey:@"type"] isEqualToString:@"wall"]) {
			[world createWallAtPoint:ccp(x,y)];
		}
		
		if([[tile objectForKey:@"type"] isEqualToString:@"bomb"]) {
			[world createBombAtPoint:ccp(x,y)];
		}
		
		if([[tile objectForKey:@"type"] isEqualToString:@"player"]) {
			NSString* playerID = [tile objectForKey:@"playerId"];
			
			Player* player = [world createPlayerWithID:playerID atPoint:ccp(x,y)];
			if([self.data objectForKey:@"nickname"]) player.nickname = [self.data objectForKey:@"nickname"];
		}	
	}
}


@end
