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
		
		self.sprite = [CCSprite spriteWithFile:@"bomb.png"];
		sprite.anchorPoint = ccp(0.5,0);
        sprite.position = ccp(25,20);
        
		[self addChild:sprite];
        
        // make that bomb shake like a bobble head
        [sprite runAction:[CCRepeatForever actionWithAction:[CCSequence actionOne:[CCRotateBy actionWithDuration:.3 angle:5] two:[CCRotateBy actionWithDuration:.3 angle:-5]]]]; 
        
	}
	return self;
}

- (CCParticleSystem*) explotion {
    CCParticleSystem* emitter = [SmokeParticleEmitter node];
    emitter.position = ccpAdd(self.cell.position, ccp(10,50));
    return emitter;
}


+ (void) animateExpletive:(CCSprite*)sprite {
    [sprite runAction:[CCScaleTo actionWithDuration:1.5f scale:1.f]];
    [sprite runAction:[CCFadeOut actionWithDuration:1.5f]];
}

- (CCSprite*) expletive {
    CCSprite* expletive = [CCSprite spriteWithFile:[NSString stringWithFormat:@"explative%02d-hd.png", (arc4random()%20)]];
    expletive.scale = .6;
    expletive.position = ccpAdd(self.cell.position, ccp(10,50));
    expletive.anchorPoint = ccp(.5,.5);
    return expletive;
}


@end