//
//  Settings.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Settings.h"


@implementation Settings

@dynamic nickname;
@synthesize playerID;

static Settings* instance;

+(Settings*) instance {	
	if(!instance) {
		instance = [Settings new];
	}
	
	return instance;
}

- (void) setNickname:(NSString *)nickname {
    NSLog(@"saving %@", nickname);
    [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*) nickname {
    NSLog(@"loading %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"]);
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
}


@end
