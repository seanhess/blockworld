/*
 *  Player.h
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "cocos2d.h"
#import "Item.h"

@interface Player : Item {
	NSString* playerID;
}

@property(nonatomic, retain) NSString* playerID;

+ (Player*) playerWithPlayerID:(NSString*)playerID;
- (id) initWithPlayerID:(NSString*)p;

@end