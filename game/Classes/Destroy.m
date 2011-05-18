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
    for(int i=-1;i<2;i++) {
        for(int j=-1;j<2;j++) {
            [world destroyAtPoint:ccp(self.positionX+i, self.positionY+j)];
        }
    }
}


@end
