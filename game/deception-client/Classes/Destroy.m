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
	[world destroyAtPoint:ccp(self.positionX, self.positionY)];
}


@end
