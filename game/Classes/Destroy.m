//
//  Destroy.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Destroy.h"
#import "World.h"

@implementation Destroy

// destroy should never be sent to the server //
-(id) init {
	if((self = [super init])) {
		[self setAction:@"destroy"];
	} return self;
}

-(void) execute {
	if([[definition objectForKey:@"type"] isEqualToString:@"player"]) {
		NSString* playerID = [[definition objectForKey:@"data"] objectForKey:@"playerId"];
	
		[world playerDidDie:[world playerWithPlayerID:playerID]];
	}

    [world destroyAtPoint:ccp(self.positionX, self.positionY)];
}


@end
