//
//  ActionPad.m
//  deception-client
//
//  Created by Bryce Redd on 1/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionPad.h"

@interface ActionPad()
@property(nonatomic, retain) SpriteButton* wallButton;
@property(nonatomic, retain) SpriteButton* bombButton;
@end

@implementation ActionPad

@synthesize bomb, wall, bombButton, wallButton;

-(id) init {
	if((self = [super init])) {
		
		[self setIsTouchEnabled:YES];
		
		CCTexture2D *bombTexture = [[CCTextureCache sharedTextureCache] addImage:@"bomb button.png"];
		CCSprite* bombSprite = [CCSprite spriteWithTexture:bombTexture];
	
		CCTexture2D *blockTexture = [[CCTextureCache sharedTextureCache] addImage:@"Stone Block button.png"];
		CCSprite* blockSprite = [CCSprite spriteWithTexture:blockTexture];
	
	
		self.bombButton = [[[SpriteButton alloc] initWithSprite:bombSprite] autorelease];
		self.wallButton = [[[SpriteButton alloc] initWithSprite:blockSprite] autorelease];
		
		self.bombButton.delegate = self;
		self.wallButton.delegate = self;
		
		self.bombButton.position = ccp(0, 30);
		self.wallButton.position = ccp(0, -30);
		
		[self addChild:self.bombButton];
		[self addChild:self.wallButton];
	}
	return self;
}

- (void) spriteButton:(SpriteButton*)button touchesDidBegin:(NSSet*)touches {

	if(button == self.wallButton && self.wall) { 
		self.wall(YES); 
	}	
	if(button == self.bombButton && self.bomb) { self.bomb(YES); }
}

- (void) spriteButton:(SpriteButton*)button touchesDidEnd:(NSSet*)touches {

	if(button == self.wallButton && self.wall) { self.wall(NO); }	
	if(button == self.bombButton && self.bomb) { self.bomb(NO); }
}

- (void) spriteButton:(SpriteButton*)button touchesDidCancel:(NSSet*)touches {

	if(button == self.wallButton && self.wall) { self.wall(NO); }
	if(button == self.bombButton && self.bomb) { self.bomb(NO); }
}


- (void) dealloc {
	[wallButton release];
	[wall release];
	[bombButton release];
	[bomb release];
	
	[super dealloc];
}

@end
