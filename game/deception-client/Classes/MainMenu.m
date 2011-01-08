//
//  MainMenu.m
//  deception-client
//
//  Created by Bryce Redd on 1/7/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "MainMenu.h"
#import "ServerCommunicator.h"
#import "CJSONSerializer.h"

@interface MainMenu()
- (void) playGame;
@end

// HelloWorld implementation
@implementation MainMenu

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {
	
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		// create and initialize a Label
		
		CCLabelTTF *statusLabel = [CCLabelTTF labelWithString:@"Disconnected" fontName:@"Helvetica" fontSize:64];
		
		[ServerCommunicator instance].statusChangedCallback = ^(server_status status) {
			if(status == connected) { [statusLabel setString:@"Connected"]; }
			if(status == disconnected) { [statusLabel setString:@"Disconnected"]; }
			if(status == sending) { [statusLabel setString:@"Sending"]; }
			if(status == receiving) { [statusLabel setString:@"Receiving"]; }
		};
		
		// create button
		CCMenuItemFont* startButton = [CCMenuItemFont itemFromString:@"Start" block:^(id sender) {
			[self playGame];
		}];
		
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// position the label on the center of the screen
		statusLabel.position =  ccp(size.width/2, size.height/2);
		startButton.position = ccp(size.width/2, size.height/2 - 100);
		
		[self addChild:statusLabel];
		[self addChild:startButton];
		
		
	}
	return self;
}

- (void) connect {
	
	NSDictionary* helloDict = [NSDictionary dictionaryWithObject:@"hello from client" forKey:@"message"];
	
	[[ServerCommunicator instance] connect];
	[[ServerCommunicator instance] sendMessageToServer:[[CJSONSerializer serializer] serializeDictionary:helloDict]];
	[ServerCommunicator instance].messageReceivedCallback = ^(NSDictionary* message) {
		NSLog(@"message from server: %@", message);
	};
}

- (void) playGame {
	NSLog(@"Enter the world!");
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc {
	
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
