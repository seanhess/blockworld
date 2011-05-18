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
	NSString* nickname;
	
	CGRect left;
	CGRect right;
	CGRect up;
	CGRect down;
	
	CCLabelTTF* nicknameLabel;
}

@property(nonatomic, retain) NSString* playerID;
@property(nonatomic, retain) NSString* nickname;

+ (Player*) playerWithPlayerID:(NSString*)playerID;
- (id) initWithPlayerID:(NSString*)p;
- (void) moveInDirection:(CGPoint)direction;

@end