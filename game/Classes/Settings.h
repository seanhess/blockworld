//
//  Settings.h
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Settings : NSObject {
}

@property(nonatomic, retain) NSString* playerID;
@property(nonatomic, retain) NSString* nickname;

+(Settings*) instance;

@end
