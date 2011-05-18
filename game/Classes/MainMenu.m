//
//  MainMenu.m
//  deception-client
//
//  Created by Bryce Redd on 1/7/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "MainMenu.h"

#import "GameScene.h"
#import "Create.h"
#import "Settings.h"

@interface MainMenu()
- (void) verifyName;
- (void) startGame;
- (UITextField*) nameField;
@end



@implementation MainMenu

+(id) scene {
	
	CCScene *scene = [CCScene node];
	
	MainMenu *layer = [MainMenu node];
	
	[scene addChild:layer];
	
	return scene;
}


-(id) init {
	
	if((self = [super init])) {
		
		CGSize size = [[CCDirector sharedDirector] winSize];
		

        
		statusLabel = [CCLabelTTF labelWithString:@"Disconnected" fontName:@"Helvetica" fontSize:64];
		statusLabel.position =  ccp(size.width/2, size.height/2);
		[self addChild:statusLabel];
        
        
        [CCMenuItemFont setFontName:@"Helvetica"];
        [CCMenuItemFont setFontSize:22];        
        startButton = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(verifyName)];
        startButton.position = ccp(0,0);
        startButton.anchorPoint = ccp(.5,0);
        startButton.disabledColor = ccc3(.5, .5, .5);
        [startButton setColor:ccc3(255, 255, 255)];
        CCMenu* menu = [CCMenu menuWithItems:startButton, nil];
        menu.position = ccp(size.width/2,size.height*3/5);
        [self addChild:menu];
        
        
        nameField = [self nameField];
        [[[CCDirector sharedDirector] openGLView] addSubview:nameField]; 
		
        
        
		[ServerCommunicator instance].statusChangedCallback = ^(server_status status) {
            if(status == connected) { 
                
                [statusLabel setString:@"Connected"]; 
            }
			if(status == disconnected) { [statusLabel setString:@"Disconnected"]; }
			if(status == sending) { [statusLabel setString:@"Sending"]; }
			if(status == receiving) { [statusLabel setString:@"Receiving"]; }    
		};


		[[ServerCommunicator instance] connect];
		
		
	}
	return self;
}

-(UITextField*) nameField {
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    UITextField* textField = [[[UITextField alloc] initWithFrame:CGRectMake(size.width/2.f - 125.f, size.height*1/6, 250, 35)] autorelease];
    textField.text = [Settings instance].nickname;
    textField.placeholder = @"Your nickname, kiddo";
    textField.backgroundColor = [UIColor blackColor];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:22];
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeNamePhonePad;
    textField.textColor = [UIColor blackColor];
    textField.delegate = self;
    
    return textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
	[nameField resignFirstResponder];
	
	[self verifyName];

	return YES;
}


- (void) verifyName {
	[ServerCommunicator instance].messageReceivedCallback = ^(NSDictionary* message) {
        [Settings instance].playerID = [[message objectForKey:@"data"] objectForKey:@"playerId"];
		
        if([Settings instance].playerID) {
            [Settings instance].nickname = nameField.text;
            [self startGame];
        } else {
            [statusLabel setString:@"Already Taken"];
        }
	};
	
	Create* command = [Create command];
	[command setType:@"player"];
	[command setPlayerNickname:nameField.text];
	[command send];
	
}

- (void) startGame {
	[nameField removeFromSuperview];

	[[CCDirector sharedDirector] replaceScene:[GameScene scene]];
}



- (void) dealloc {

	[super dealloc];
}
@end
