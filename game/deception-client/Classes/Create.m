//
//  Build.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Create.h"

#import "World.h"
#import "Player.h"

@implementation Create

-(id) init {
	if((self = [super init])) {
		[self setAction:@"create"];
	} return self;
}

-(void) execute {
	if([[definition objectForKey:@"type"] isEqualToString:@"player"]) {
		NSLog(@"creating %@ at %d %d", [self.data objectForKey:@"uid"], self.positionX, self.positionY);
		Player* player = [world createPlayerWithID:[self.data objectForKey:@"uid"] atPoint:ccp(self.positionX, self.positionY)];
		if([self.data objectForKey:@"nickname"]) player.nickname = [self.data objectForKey:@"nickname"];
	}
	if([[definition objectForKey:@"type"] isEqualToString:@"bomb"]) {
		[world createBombAtPoint:ccp(self.positionX, self.positionY)];
	}
	if([[definition objectForKey:@"type"] isEqualToString:@"wall"]) {
		[world createWallAtPoint:ccp(self.positionX, self.positionY)];
	}
}

- (void) setPlayerNickname:(NSString*)nickname {
	[self.data setObject:nickname forKey:@"nickname"];
}

@end
