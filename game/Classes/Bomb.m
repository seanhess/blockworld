/*
 *  Bomb.m
 *  deception-client
 *
 *  Created by Bryce Redd on 1/7/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "Bomb.h"
#import "Cell.h"
#import "SmokeParticleEmitter.h"

#define TOTAL_NUM_EXPLATIVES 19


@implementation Bomb

- (id) init {
	if((self = [super init])) {
		
		self.cachedSpriteName = @"bomb.png";
        
        self.isOnScreen = YES;
	}
	return self;
}


- (void) drawAllSprites {
    [super drawAllSprites];
    
    [sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCRotateBy actionWithDuration:.3 angle:5] two:[CCRotateBy actionWithDuration:.3 angle:-5]]]]; 
    
    sprite.anchorPoint = ccp(0.5,0);
    sprite.position = ccp(25,20);
    
}

- (void)removeAllSprites {
    [super removeAllSprites];
}


- (CCParticleSystem*) explotion {
    CCParticleSystem* emitter = [SmokeParticleEmitter node];
    emitter.position = ccpAdd(self.cell.position, ccp(10,50));
    return emitter;
}


- (CCSprite*) expletive {
	
	CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addImage:[NSString stringWithFormat:@"explative%02d-hd.png", (arc4random()%20)]];
	CCSprite* expletive = [CCSprite spriteWithTexture:texture];
	
    expletive.scale = .6;
    expletive.position = ccpAdd(self.cell.position, ccp(10,50));
    expletive.anchorPoint = ccp(.5,.5);
    [expletive runAction:[CCScaleTo actionWithDuration:1.5f scale:1.f]];
    [expletive runAction:[CCFadeOut actionWithDuration:1.5f]];

    return expletive;
}


@end