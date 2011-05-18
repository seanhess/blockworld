//
//  MainMenu.h
//  deception-client
//
//  Created by Bryce Redd on 1/7/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CJSONSerializer.h"
#import "ServerCommunicator.h"

// HelloWorld Layer
@interface MainMenu : CCLayer <UITextFieldDelegate> {
	UITextField* nameField;
}

// returns a Scene that contains the MainMenu as the only child
+(id) scene;

@end