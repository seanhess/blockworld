//
//  HUD.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HUD.h"

#import "DirectionPad.h"
#import "ActionPad.h"
#import "CCDirector.h"
#import <UIKit/UIKit.h>

@implementation HUD

- (id) init {
	if((self = [super init])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
		
		directionPad = [DirectionPad node];
		directionPad.position = ccp(80, 130);
		
		actionPad = [ActionPad node];
		actionPad.position = ccp(size.width-60, 140);
		
		[self addChild:directionPad];
		[self addChild:actionPad];
        
        CCSprite* sprite = [CCSprite spriteWithFile:@"bluetile.png"];        
        mapButton = [[[SpriteButton alloc] initWithSprite:sprite] autorelease];
        mapButton.delegate = self;
		mapButton.position = ccp(size.width - 40, size.height - 40);
		[self addChild:mapButton];
		
	} return self;
}

- (void) spriteButton:(SpriteButton *)button touchesDidEnd:(NSSet *)touches {

    UIView * parentView = [[CCDirector sharedDirector] openGLView];

    UIWebView * mapView = [[UIWebView alloc] initWithFrame:parentView.bounds];
    NSURL * url = [NSURL URLWithString:@"http://bb.seanhess.net:3000/map.html"]; // use real host
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [mapView loadRequest:request];

    [parentView addSubview:mapView]; 
}

- (void) spriteButton:(SpriteButton *)button touchesDidBegin:(NSSet *)touches {

}

- (void) spriteButton:(SpriteButton *)button touchesDidCancel:(NSSet *)touches {

}

- (void) setMoveCallback:(void(^)(int, int))move {
	void(^callback)(int, int) = [[move copy] autorelease];
	
	directionPad.move = callback;
}

- (void) setBombCallback:(void(^)(BOOL))callback {	
	actionPad.bomb = callback;
}

- (void) setWallCallback:(void(^)(BOOL))callback {
	actionPad.wall = callback;
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void) cleanup {
    [super cleanup];
    
    mapButton = nil;
    actionPad.wall = nil;
    actionPad.bomb = nil;
    directionPad.move = nil;
}

@end
