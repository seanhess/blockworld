/*
 *  Bomb.h
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "Item.h"

@interface Bomb : Item

- (CCParticleSystem*) explotion;
- (CCSprite*) expletive;

@end