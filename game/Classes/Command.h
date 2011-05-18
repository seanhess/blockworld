//
//  Command.h
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class World;

@interface Command : NSObject {
	NSMutableDictionary* definition;
	World* world;
}

@property(nonatomic, readonly) NSMutableDictionary* definition;
@property(nonatomic, readonly) NSMutableDictionary* data;
@property(nonatomic, readonly) int positionX;
@property(nonatomic, readonly) int positionY;

+(id) commandWithDefinition:(NSDictionary*)definition world:(World*)world;
+(id) command;
-(id) initWithDefinition:(NSDictionary*)def world:w;

-(void) setType:(NSString *)type;
-(void) setAction:(NSString *)action;
-(void) setPoint:(CGPoint)point;
-(void) setPlayerID:(NSString*)playerID;

-(void) send;
-(void) execute;


@end
