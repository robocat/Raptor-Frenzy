//
//  Player.m
//  Raptor
//
//  Created by Willi Wu on 29/01/11.
//  Copyright 2011 Robocat. All rights reserved.
//

#import "Player.h"


#define kStandSprites			6
#define kJumpSprites			6

#define kRunSprites				5
#define kAttackSprites			5
#define kRunAttackSprites		5

#define kJumpAttackSprites		2
#define kStunnedSprites			3
#define kDeathSprites			9



#define kJumpTime				0.8



@implementation Player

@synthesize canHit;
@synthesize gore = _gore;
@synthesize deathAnimation = _deathAnimation;
@synthesize stunnedAnimation = _stunnedAnimation;
@synthesize jumpAttackAnimation = _jumpAttackAnimation;
@synthesize runAttackAnimation = _runAttackAnimation;
@synthesize attackAnimation = _attackAnimation;
@synthesize jumpAnimation = _jumpAnimation;
@synthesize facing = _facing;
@synthesize health = _health;
@synthesize moveAction = _moveAction;
@synthesize state = _state;
@synthesize theGame = _theGame;
@synthesize sprite = _sprite;
@synthesize standAction = _standAction;
@synthesize standBiteAction = _standBiteAction;
@synthesize runAction = _runAction;
@synthesize attackAction = _attackAction;
@synthesize jumpAction = _jumpAction;
@synthesize jumpAttackAction = _jumpAttackAction;
@synthesize stunnedAction = _stunnedAction;
@synthesize deadAction = _deadAction;
@synthesize position = _position;
@synthesize jumpHeight = _jumpHeight;
@synthesize runSpeed = _runSpeed;
@synthesize attackSpeed = _attackSpeed;
@synthesize isStunned = _isStunned;
@synthesize isDead = _isDead;

-(void)dealloc
{
	[_deadAction release];
	_deadAction = nil;
	
	[_stunnedAction release];
	_stunnedAction = nil;
	
	[_jumpAttackAction release];
	_jumpAttackAction = nil;
	
	[_jumpAction release];
	_jumpAction = nil;
	
	[_attackAction release];
	_attackAction = nil;
	
	[_runAction release];
	_runAction = nil;
	
	[_standBiteAction release];
	_standBiteAction = nil;
	
	[_standAction release];
	_standAction = nil;
	
	[_sprite release];
	_sprite = nil;
	
	[_theGame release];
	_theGame = nil;


	[_moveAction release];
	_moveAction = nil;



	[_jumpAnimation release];
	_jumpAnimation = nil;

	[_attackAnimation release];
	_attackAnimation = nil;


	[_runAttackAnimation release];
	_runAttackAnimation = nil;

	[_jumpAttackAnimation release];
	_jumpAttackAnimation = nil;

	[_stunnedAnimation release];
	_stunnedAnimation = nil;

	[_deathAnimation release];
	_deathAnimation = nil;

	[_gore release];
	_gore = nil;


	[super dealloc];
}


- (id) initWithGame:(GameLayer *)game
	withSpritePlist:(NSString *)plist
	withSpriteImage:(NSString *)image
{
	
	self = [super init];
	if (self != nil) {

		self.theGame = game;
		
		[self resetPlayer];
		

		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plist];        

		// Create a sprite sheet with the Happy Bear images
		CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:image];
		[game addChild:spriteSheet];

		
		
		
		
		
		
		// Load up the frames of our animation
		NSMutableArray *standAnimFrames = [NSMutableArray array];
		for(int i = 1; i <= kStandSprites; ++i) {
			[standAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"standing%d.png", i]]];
		}
		CCAnimation *standAnim = [CCAnimation animationWithFrames:standAnimFrames delay:0.1f];
		
		
		NSMutableArray *jumpAnimFrames = [NSMutableArray array];
		for(int i = 1; i <= kJumpSprites; ++i) {
			[jumpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"jump%d.png", i]]];
		}
		for(int i = 1; i <= 3; ++i) {
			[jumpAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"jump%d.png", i]]];
		}
		CCAnimation *jumpAnim = [CCAnimation animationWithFrames:jumpAnimFrames delay:(kJumpTime/[jumpAnimFrames count])];
		self.jumpAnimation = jumpAnim;
		self.jumpAction = [CCAnimate actionWithAnimation:self.jumpAnimation restoreOriginalFrame:NO];
		
		
		NSMutableArray *runAnimFrames = [NSMutableArray array];
		NSMutableArray *attackAnimFrames = [NSMutableArray array];
		NSMutableArray *runAttackAnimFrames = [NSMutableArray array];
		for(int i = 1; i <= kRunSprites; ++i) {
			[runAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"running%d.png", i]]];
			[attackAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"attack%d.png", i]]];
			[runAttackAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"attackrun%d.png", i]]];
		}
		CCAnimation *runAnim = [CCAnimation animationWithFrames:runAnimFrames delay:0.08f];
		CCAnimation *attackAnim = [CCAnimation animationWithFrames:attackAnimFrames delay:0.1f];
		self.attackAnimation = attackAnim;
		CCAnimation *runAttackAnim = [CCAnimation animationWithFrames:runAttackAnimFrames delay:0.1f];
		self.runAttackAnimation = runAttackAnim;
		
		
		
		NSMutableArray *jumpAttackAnimFrames = [NSMutableArray array];
		for(int i = 1; i <= kJumpAttackSprites; ++i) {
			[jumpAttackAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"attackjump%d.png", i]]];
		}
		CCAnimation *jumpAttackAnim = [CCAnimation animationWithFrames:jumpAttackAnimFrames delay:0.1f];
		self.jumpAttackAnimation = jumpAttackAnim;
		
		NSMutableArray *stunnedAnimFrames = [NSMutableArray array];
		for(int i = 1; i <= kStunnedSprites; ++i) {
			[stunnedAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"damage%d.png", i]]];
		}
		CCAnimation *stunnedAnim = [CCAnimation animationWithFrames:stunnedAnimFrames delay:0.1f];
		self.stunnedAnimation = stunnedAnim;
		
		NSMutableArray *deathAnimFrames = [NSMutableArray array];
		for(int i = 1; i <= kDeathSprites; ++i) {
			[deathAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"death%d.png", i]]];
		}
		CCAnimation *deathAnim = [CCAnimation animationWithFrames:deathAnimFrames delay:0.1f];
		self.deathAnimation = deathAnim;
		
		self.runAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO]];
		
		

		// Create a sprite for our bear
		self.sprite = [CCSprite spriteWithSpriteFrameName:@"standing1.png"];
		self.sprite.scale = 4.0;
		[self.sprite.texture setAliasTexParameters];

		self.standAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:standAnim restoreOriginalFrame:NO]];
		[self.sprite runAction:self.standAction];

		
		[spriteSheet addChild:self.sprite];
	}
	
	return self;
}


- (void)resetPlayer
{
	self.health = 80;
	self.runSpeed	= 500.0;
	self.facing		= PlayerFacingRight;

	isStanding	= YES;
	isAttacking = NO;
	isJumping	= NO;
	isStunned	= NO;
	isDead		= NO;
	isGoring	= NO;
	canHit		= YES;
	
	[self stopAllActions];
//	[self moveTo:ccp(self.position.x,self.position.y)];
}

-(void)update
{
	
}


- (void)setPosition:(CGPoint)point
{
	self.sprite.position = point;
}


- (void)tintPlayer:(ccColor3B)color
{
	self.sprite.color = color;
}

- (void)facingDirection:(PlayerFacing)facing
{
	self.facing = facing;
	self.sprite.flipX = (facing == PlayerFacingLeft);
}



- (void)stopMoving
{
	[self.sprite stopAction:self.moveAction];
	[self.sprite stopAction:self.runAction];
}


- (void)moveTo:(CGPoint)point
{
	if (isStunned) {
		return;
	}
	CGPoint moveDifference = ccpSub(point, self.sprite.position);
	float distanceToMove = ccpLength(moveDifference);
	float moveDuration = distanceToMove / self.runSpeed;
	
	if (moveDifference.x > 0) {
		self.sprite.flipX = NO;
		self.facing = PlayerFacingRight;
	} else {
		self.sprite.flipX = YES;
		self.facing = PlayerFacingLeft;
	}    
		
		
	if (!isJumping) {
		[self stopMoving];
		
		
		// restart animations
		[self.sprite runAction:self.runAction];
		
		self.moveAction = [CCSequence actions:
						   [CCMoveTo actionWithDuration:moveDuration position:point],
						   [CCCallFunc actionWithTarget:self selector:@selector(stand)],
						   nil];
		
		//	[[SimpleAudioEngine sharedEngine] playEffect:@"DinoWalkLoop2.caf"];
		[self.sprite runAction:self.moveAction];
	}
	
	isStanding = NO;
}


- (void)moveBy:(CGPoint)point
{
//	if (self.state != PlayerStateMoving
//		&& isStanding) {
//		
//		isStanding = NO;
//		
//		if (point.x > 0) {
//			self.sprite.flipX = NO;
//		} else {
//			self.sprite.flipX = YES;
//		}    
//
//		[self.sprite stopAction:self.moveAction];
//
//		if (self.state != PlayerStateMoving) {
//			[self.sprite runAction:self.runAction];
//		}
//
//		self.moveAction = [CCSequence actions:
//						   [CCMoveBy actionWithDuration:0.3 position:point],
//						   [CCCallFunc actionWithTarget:self selector:@selector(stand)],
//						   nil];
//
//
//		[self.sprite runAction:self.moveAction];
//		
//		self.state = PlayerStateMoving;
//	}
}


- (void)jump
{
	if (isStunned) {
		return;
	}
	if (!isJumping) {
		
		isJumping = YES;
		[self stopMoving];
		
		float distance = 0;
		
		if (!isStanding) {
			distance = (self.facing == PlayerFacingLeft) ? -200 : 200;
		}
		
		id action2 = [CCSpawn actions:
					  [CCJumpBy actionWithDuration:kJumpTime position:ccp(distance, 0) height:300 jumps:1],
					  self.jumpAction,
					  nil];
		
		id action = [CCSequence actions:
					 action2,
					 [CCCallFunc actionWithTarget:self selector:@selector(land)],
					 nil];
		[self.sprite runAction:action];
	}
}


- (void)attack
{
	if (isStunned) {
		return;
	}
	if (!isAttacking) {
		
		isAttacking = YES;
		
		if (isJumping) {
			id action = [CCAnimate actionWithAnimation:self.jumpAttackAnimation restoreOriginalFrame:NO];// [CCRepeatForever actionWithAction:];
			[self.sprite runAction:action];
		}
		else if (!isStanding)
		{
			id action = [CCAnimate actionWithAnimation:self.runAttackAnimation restoreOriginalFrame:NO];
			[self.sprite runAction:action];
		}
		else {
			id action = [CCSequence actions:
						 [CCAnimate actionWithAnimation:self.attackAnimation restoreOriginalFrame:NO],
						 [CCCallFunc actionWithTarget:self selector:@selector(stopAttack)],
						 nil];
			[self.sprite runAction:action];
		}
	}
}


- (void)stunned
{
	if (!isStunned) {
		
		isStunned = YES;
		
		float jumpBy = (self.facing == PlayerFacingLeft) ? 25 : -25;
		
		id action2 = [CCSpawn actions:
					  [CCJumpBy actionWithDuration:0.5 position:ccp(jumpBy,-(self.sprite.position.y-154)) height:50 jumps:1],
					  [CCAnimate actionWithAnimation:self.stunnedAnimation restoreOriginalFrame:NO],
					  [CCBlink actionWithDuration:0.5 blinks:10],
					  nil];
		
		
		id action = [CCSequence actions:
					 action2,
					 [CCCallFunc actionWithTarget:self selector:@selector(stopStunned)],
					 nil];
		[self.sprite runAction:action];
		
	}
}

- (void)playDieAnimation {
	[self.sprite stopAllActions];
	id action = [CCSpawn actions:
				 [CCAnimate actionWithAnimation:self.deathAnimation restoreOriginalFrame:NO],
				 [CCMoveTo actionWithDuration:0.3 position:ccp(self.sprite.position.x,154)],
				 nil];

	[self.sprite runAction:action];
}

- (void)dead
{
	if (!isDead) {
		isDead = YES;
		isStunned = YES;
		if (!isJumping) {
			[self playDieAnimation];
		}
	}
}



- (void)stand
{
	if (!isJumping) {
		[self stopMoving];
	}
	
	isStanding = YES;
}



- (void)land
{
	isJumping = NO;
	
	if (isDead) {
		[self playDieAnimation];
	}
	
	if (!isStanding) {
		if (self.facing == PlayerFacingLeft) {
			[self moveTo:CGPointMake(0, 154)];
		}
		else {
			[self moveTo:CGPointMake(1024, 154)];
		}
	}
}


- (void)stopAttack
{
	isAttacking = NO;
	canHit = YES;
}


- (void)stopStunned
{
	isStunned = NO;
}


- (void)stopGore
{
	isGoring	= NO;
	self.gore.position = ccp(-1000, -10);
}





- (BOOL)collide:(CGRect)rect1 withRect:(CGRect)rect2
{
	BOOL collided = NO;
	
	if(CGRectIntersectsRect(rect1, rect2))
	{
		collided = YES;
	}
	
	return collided;
}


- (CGRect)spriteRect:(CCSprite *)sp
{
	CGRect rect = CGRectMake(sp.position.x - sp.textureRect.size.width * 2.0,
							 sp.position.y - sp.textureRect.size.height * 2.0,
							 sp.textureRect.size.width * 4.0,
							 sp.textureRect.size.height * 4.0);
	return rect;
}



- (float)resolveAttackOn:(Player *)foe
{
	float damage = 0.0;
	
	// Bottom left

//	if (self.facing == PlayerFacingLeft) {
//		self.theGame.blood.position = ccp(self.sprite.position.x + 45*4 - self.sprite.textureRect.size.width*2.0 - 6*4,
//										  self.sprite.position.y - 24*4 + self.sprite.textureRect.size.height*2.0 - 15*4);
//		
//	} else {
//		self.theGame.blood.position = ccp(self.sprite.position.x + 45*4 - self.sprite.textureRect.size.width*2.0 + 6*4.0,
//										  self.sprite.position.y - 24*4 + self.sprite.textureRect.size.height*2.0 - 15*4.0);
//		
//	}
	
	float goreX, goreY;
	if (isAttacking && canHit) {
		
		if (isJumping) {
			CGRect clawsRect;
			if (self.facing == PlayerFacingLeft) {
				clawsRect = CGRectMake(self.sprite.position.x - 45*4 + self.sprite.textureRect.size.width*2.0 - 6*4,
									   self.sprite.position.y - 24*4 + self.sprite.textureRect.size.height*2.0 - 15*4,
									   6*4, 
									   15*4);
				
			} else {
				clawsRect = CGRectMake(self.sprite.position.x + 45*4 - self.sprite.textureRect.size.width*2.0,
									   self.sprite.position.y - 24*4 + self.sprite.textureRect.size.height*2.0-15*4,
									   6*4, 
									   15*4);
			}
			
			if ([self collide:[self spriteRect:foe.sprite] withRect:clawsRect])
			{
				if (self.facing == PlayerFacingLeft) {
					goreX = self.sprite.position.x - 45*4 + self.sprite.textureRect.size.width*2.0 - 6*2;
					goreY = self.sprite.position.y - 24*4 + self.sprite.textureRect.size.height*2.0 - 15*2;
				} else {
					goreX = self.sprite.position.x + 45*4 - self.sprite.textureRect.size.width*2.0 + 6*2;
					goreY = self.sprite.position.y - 24*4 + self.sprite.textureRect.size.height*2.0-15*4;
		
				}
				damage = 10.0;
			}
		}
		CGRect teethRect;
		if (self.facing == PlayerFacingLeft) {
			teethRect = CGRectMake(self.sprite.position.x - 48*4 + self.sprite.textureRect.size.width*2.0-8*4,
								   self.sprite.position.y - 17*4 + self.sprite.textureRect.size.height*2.0 - 4*4,
								   8*4, 
								   4*4);
		} else {
			teethRect = CGRectMake(self.sprite.position.x + 48*4 - self.sprite.textureRect.size.width*2.0,
								   self.sprite.position.y - 17*4 + self.sprite.textureRect.size.height*2.0 - 4*4,
								   8*4, 
								   4*4);
		}
		if ([self collide:[self spriteRect:foe.sprite] withRect:teethRect])
		{
			if (self.facing == PlayerFacingLeft) {
				goreX = self.sprite.position.x - 48*4 + self.sprite.textureRect.size.width*2.0-8*2;
				goreY = self.sprite.position.y - 17*4 + self.sprite.textureRect.size.height*2.0 - 4*2;
			} else {
				goreX = self.sprite.position.x + 48*4 - self.sprite.textureRect.size.width*2.0+8*2;
				goreY = self.sprite.position.y - 17*4 + self.sprite.textureRect.size.height*2.0 - 4*2;
			}
			damage = 5.0;
		}
	
	}
	if (damage > 0.0) {
		if (!isGoring)
		{
			isGoring = YES;
			id action = [CCSequence actions:
						 [CCAnimate actionWithAnimation:self.theGame.goreAnimation restoreOriginalFrame:NO],
						 [CCCallFunc actionWithTarget:self selector:@selector(stopGore)],
						 nil];
			self.gore.position = ccp(goreX+(arc4random()%800)/10-40, goreY+(arc4random()%800)/10-40);
			[self.gore runAction:action];
			
			self.theGame.emitter.position = self.gore.position;
			[self.theGame.emitter resetSystem];
		}
		canHit = NO;
	}
	return damage;
}


@end