//
//  SpirteButton.h
//  deception-client
//
//  Created by Bryce Redd on 6/26/11.
//  Copyright 2011 i.TV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SpriteButton;

@protocol SpriteButtonDelegate
- (void) spriteButton:(SpriteButton*)button touchesDidBegin:(NSSet*)touches;
- (void) spriteButton:(SpriteButton*)button touchesDidEnd:(NSSet*)touches;
- (void) spriteButton:(SpriteButton*)button touchesDidCancel:(NSSet*)touches;
@end

@interface SpriteButton : CCLayer 

@property(nonatomic, assign) NSObject<SpriteButtonDelegate>* delegate;

@end
