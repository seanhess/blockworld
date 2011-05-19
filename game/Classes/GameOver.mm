//
//  GameOver.m
//  deception-client
//
//  Created by Bryce Redd on 5/18/11.
//  Copyright 2011 i.TV. All rights reserved.
//

#import "GameOver.h"
#import "Create.h"
#import "GameScene.h"
#import "Settings.h"


@implementation GameOver

- (id) init {
    if((self = [super init])) {
        CCSprite* sprite = [CCSprite spriteWithFile:@"gameover.png"];
        sprite.anchorPoint = ccp(0,0);
        sprite.contentSize = CGSizeMake(400, 400);
        [self addChild:sprite];
        
        
        
        CCMenuItemFont* item = [CCMenuItemFont itemFromString:@"respawn" block:^(id sender) {
            
            [[CCDirector sharedDirector] replaceScene:[GameScene scene]];
            
            Create* command = [Create command];
            [command setType:@"player"];
            [command setPlayerNickname:[Settings instance].nickname];
            [command send];
        }];
        
        
        
        CCMenu* menu = [CCMenu menuWithItems:item, nil];
        menu.anchorPoint = ccp(0,0);
        menu.position = ccp(200,200);
        [self addChild:menu];


    }
    return self;
}

@end
