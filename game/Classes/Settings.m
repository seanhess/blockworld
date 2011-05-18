//
//  Settings.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"


@implementation Settings

@synthesize playerID;

static Settings* instance;

+(Settings*) instance {	
	if(!instance) {
		instance = [Settings new];
	}
	
	return instance;
}



@end
