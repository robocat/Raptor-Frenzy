//
//  Player.h
//  Raptor
//
//  Created by Willi Wu on 29/01/11.
//  Copyright 2011 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"


typedef enum {
	PlayerFacingRight,
	PlayerFacingLeft,
} PlayerFacing;


typedef enum {
	PlayerStateMoving,
	PlayerStateRunAttacking,
	PlayerStateJumpAttacking,
	PlayerStateStunned,
	PlayerStateDead,
	
} PlayerState;




@interface Player : CCNode {
	GameLayer		* _theGame;
	CCSprite		*_sprite;
	
	CCAction		*_standAction;
	CCAction		*_standBiteAction;
	
	CCAction		*_runAction;
	CCAction		*_moveAction;
	CCAction		*_attackAction;
	CCAnimation		*_attackAnimation;
	CCAnimation		*_runAttackAnimation;
	
	CCAction		*_jumpAction;
	CCAction		*_jumpAttackAction;
	CCAnimation		*_jumpAnimation;
	CCAnimation		*_jumpAttackAnimation;
	
	CCAction		*_stunnedAction;
	CCAnimation		*_stunnedAnimation;
	
	CCAction		*_deadAction;
	CCAnimation		*_deathAnimation;
	
	CCSprite		*_gore;
	
	
	CGPoint			_position;
	float			_jumpHeight;
	float			_runSpeed;
	float			_attackSpeed;
	
	float			_health;
	
	PlayerFacing	_facing;
	PlayerState		_state;
	
	
	BOOL			isStanding;
	BOOL			isAttacking;
	BOOL			isJumping;
	BOOL			isStunned;
	BOOL			isDead;
	BOOL			isGoring;
	BOOL			canHit;
	
}

@property (nonatomic, assign) BOOL canHit;
@property (nonatomic, retain) CCSprite *gore;
@property (nonatomic, retain) CCAnimation *deathAnimation;
@property (nonatomic, retain) CCAnimation *stunnedAnimation;
@property (nonatomic, retain) CCAnimation *jumpAttackAnimation;
@property (nonatomic, retain) CCAnimation *runAttackAnimation;
@property (nonatomic, retain) CCAnimation *attackAnimation;
@property (nonatomic, retain) CCAnimation *jumpAnimation;
@property (nonatomic, assign) PlayerFacing facing;
@property (nonatomic, assign) float health;
@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, assign) PlayerState state;
@property (nonatomic, retain) GameLayer *theGame;
@property (nonatomic, retain) CCSprite *sprite;
@property (nonatomic, retain) CCAction *standAction;
@property (nonatomic, retain) CCAction *standBiteAction;
@property (nonatomic, retain) CCAction *runAction;
@property (nonatomic, retain) CCAction *attackAction;
@property (nonatomic, retain) CCAction *jumpAction;
@property (nonatomic, retain) CCAction *jumpAttackAction;
@property (nonatomic, retain) CCAction *stunnedAction;
@property (nonatomic, retain) CCAction *deadAction;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) float jumpHeight;
@property (nonatomic, assign) float runSpeed;
@property (nonatomic, assign) float attackSpeed;
@property (nonatomic, assign) BOOL isStunned;
@property (nonatomic, assign) BOOL isDead;


- (id) initWithGame:(GameLayer *)game
	withSpritePlist:(NSString *)plist
	withSpriteImage:(NSString *)image;

- (void)resetPlayer;
- (void)tintPlayer:(ccColor3B)color;
- (void)facingDirection:(PlayerFacing)facing;

- (void)moveTo:(CGPoint)point;
- (void)moveBy:(CGPoint)point;
- (void)attack;
- (void)jump;
- (void)stunned;
- (void)dead;
- (void)stand;
- (void)stopAttack;
- (void)stopStunned;
- (void)stopGore;


- (float)resolveAttackOn:(Player *)foe;

@end
