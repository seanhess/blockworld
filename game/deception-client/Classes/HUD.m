//
//  HUD.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HUD.h"
#import "DirectionPad.h"

@implementation HUD

- (id) init {
	if((self = [super init])) {
		directionPad = [DirectionPad node];
		
		[self addChild:directionPad];
	} return self;
}

@end
