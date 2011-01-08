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
#import "GameScene.h"
#import "Create.h"

@interface MainMenu()
- (void) verifyName:(NSString*)name;
- (void) startGameWithCommand:(Create*)command;
@end

// HelloWorld implementation
@implementation MainMenu

+(id) scene {
	
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenu *layer = [MainMenu node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {
	
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		// create and initialize a Label		
		CCLabelTTF *statusLabel = [CCLabelTTF labelWithString:@"Disconnected" fontName:@"Helvetica" fontSize:64];
		
		// create button
		//CCMenuItemFont* startButton = [CCMenuItemFont itemFromString:@"Start" block:^(id sender) {
		//	NSLog(@"clicked");
		//	[self playGame];
		//}];
		//startButton.isEnabled = NO;

		[ServerCommunicator instance].statusChangedCallback = ^(server_status status) {
			if(status == connected) { 
				[statusLabel setString:@"Connected"]; 
			}
			if(status == disconnected) { 
				[statusLabel setString:@"Disconnected"]; 
			}
			if(status == sending) { [statusLabel setString:@"Sending"]; }
			if(status == receiving) { [statusLabel setString:@"Receiving"]; }
		};

		[[ServerCommunicator instance] connect];
		
		nameField = [[UITextField alloc] init];
		nameField.placeholder = @"Your nickname, kiddo";
		nameField.backgroundColor = [UIColor whiteColor];
		nameField.borderStyle = UITextBorderStyleRoundedRect;
		nameField.font = [UIFont systemFontOfSize:22];
		nameField.returnKeyType = UIReturnKeyDone;
		nameField.keyboardType = UIKeyboardTypeNamePhonePad;
		nameField.transform = CGAffineTransformTranslate(nameField.transform, size.width/2, size.height/2-200);// (x,y)
		nameField.transform = CGAffineTransformRotate(nameField.transform, CC_DEGREES_TO_RADIANS(90));
		[nameField setDelegate:self];
		[[[CCDirector sharedDirector] openGLView] addSubview: nameField]; 
		
		
		//CCMenu* menu = [CCMenu menuWithItems:startButton, nil];
		
		// position the label on the center of the screen
		statusLabel.position =  ccp(size.width/2, size.height/2);
		//menu.position = ccp(size.width/2, size.height/2 - 100);
		
		[self addChild:statusLabel];
		//[self addChild:menu];
		
		
	}
	return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
	//dismiss keyboard
	[nameField resignFirstResponder];
	
	[self verifyName:textField.text];

	return YES;
}


- (void) verifyName:(NSString*)name {
	
	[ServerCommunicator instance].messageReceivedCallback = ^(NSDictionary* message) {
		
		NSLog(@"message from server: %@", message);
	};
	
	Create* command = [Create command];
	[command setType:@"player"];
	[command setPlayerID:name];
	[command send];
	
}

- (void) startGameWithCommand:(Create*)command {
	[nameField removeFromSuperview];
	[[CCDirector sharedDirector] replaceScene:[GameScene sceneWithCommand:command]];
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
