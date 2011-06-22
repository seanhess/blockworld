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
		

        
		statusLabel = [CCLabelTTF labelWithString:@"Unknown" fontName:@"Helvetica" fontSize:24];
		statusLabel.position =  ccp(size.width/2, size.height/4);
		[self addChild:statusLabel];
        
        
        [CCMenuItemFont setFontName:@"Helvetica"];
        [CCMenuItemFont setFontSize:64];
        startButton = [CCMenuItemFont itemFromString:@"Spawn" target:self selector:@selector(verifyName)];
        startButton.position = ccp(0,0);
        startButton.anchorPoint = ccp(.5,.5);
        startButton.disabledColor = ccc3(.5, .5, .5);
        startButton.color = ccc3(255, 255, 255);
        startButton.disabledColor = ccc3(100, 100, 100);
        CCMenu* menu = [CCMenu menuWithItems:startButton, nil];
        menu.position = ccp(size.width/2,size.height/2);
        [self addChild:menu];
        
        
        nameField = [self nameField];
        [[[CCDirector sharedDirector] openGLView] addSubview:nameField]; 
		
        
        
		[ServerCommunicator instance].statusChangedCallback = ^(server_status status) {
            if(status == connected) { 
                startButton.isEnabled = YES;
                [statusLabel setString:@"Connected"]; 
            }
			if(status == disconnected) { 
                startButton.isEnabled = NO;
                [statusLabel setString:@"Disconnected"]; 
            }
		};
        
        [ServerCommunicator instance].statusChangedCallback([ServerCommunicator instance]->status);


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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

	// we have to do this nonsense so if they've pasted something longer than the max
	// length then they can press the backspace key still.
	
	if([string isEqualToString:@""]) return YES;
	
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return !(newLength > MAX_NAME_LENGTH);
}

- (void) verifyName {
	[ServerCommunicator instance].messageReceivedCallback = ^(NSDictionary* message) {
		NSString* nickname = [[message objectForKey:@"data"] objectForKey:@"nickname"];
		NSString* type = [message objectForKey:@"type"];
		NSString* action = [message objectForKey:@"action"];
		
		if(![action isEqualToString:@"you"] || ![type isEqualToString:@"player"] || ![nickname isEqualToString:nameField.text]) { return; }
	
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

@end
