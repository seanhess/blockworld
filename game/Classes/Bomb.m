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
		CCTexture2D* texture = [[CCTextureCache sharedTextureCache] addImage:@"bomb.png"];
		
		self.sprite = [CCSprite spriteWithTexture:texture];
		sprite.anchorPoint = ccp(0,0);
        sprite.position = ccp(0,20);
		
		[self addChild:sprite];
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