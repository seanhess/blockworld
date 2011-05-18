//
//  LandingParticleEmitter.m
//  DuckRalf
//
//  Created by Bryce Redd on 4/30/11.
//  Copyright 2011 i.TV. All rights reserved.
//


#import "SmokeParticleEmitter.h"


@implementation SmokeParticleEmitter


-(id) init {
	return [self initWithTotalParticles:6];
}

-(id) initWithTotalParticles:(int)p
{
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
	// duration
	duration = 0.01f;
	
	// gravity
	self.gravity = ccp(0, 0);
	
	// angle
	angle = 90;
	angleVar = 360;
	
	// speed of particles
	self.speed = 40;
	self.speedVar = 5;
    
    
	// radial
	self.radialAccel = 0.0;
	self.radialAccelVar = 0;
	
	// tagential
	self.tangentialAccel = 0;
	self.tangentialAccelVar = 0;
	
	// emitter position
    self.posVar = ccp(30,30);
	
	// life of particles
	life = 0.6f;
	lifeVar = 0.2f;
	
    startSpin = 100.f;
    startSpinVar = 50.f;
    endSpin = 20.f;
    endSpinVar = 0.f;
    
	// size, in pixels
	startSize = 20.0f;
	startSizeVar = 5.0f;
    endSize = 75.0f;
	
	
	// emits per second
	emissionRate = totalParticles/duration;
	
	// color of particles
	startColor.r = 1.0f;
	startColor.g = 1.0f;
	startColor.b = 1.0f;
	startColor.a = 0.5f;
	startColorVar.r = 0.0f;
	startColorVar.g = 0.0f;
	startColorVar.b = 0.0f;
	startColorVar.a = 0.0f;
	endColor.r = 1.0f;
	endColor.g = 1.0f;
	endColor.b = 1.0f;
	endColor.a = 0.0f;
	endColorVar.r = 0.0f;
	endColorVar.g = 0.0f;
	endColorVar.b = 0.0f;
	endColorVar.a = 0.0f;
	
	// must have an image or crash
	self.texture = [[CCTextureCache sharedTextureCache] addImage:@"Smoke.png"];
	
	// additive
	self.blendAdditive = NO;
	
	return self;
}


@end
