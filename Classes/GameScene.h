//
//  GameScene.h
//  Raptor
//
//  Created by Willi Wu on 28/01/11.
//  Copyright 2011 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RaptorAppDelegate.h"
#import <GameKit/GameKit.h>



typedef enum {
	ButtonUpPressed = 1,
	ButtonUpReleased,
	ButtonLeftPressed,
	ButtonLeftReleased,
	ButtonRightPressed,
	ButtonRightReleased,
	ButtonAttackPressed,
	ButtonAttackReleased,
} Button;



typedef enum {
	CommandHit = 100,
	CommandStun,
	CommandLowHealth,
} Command;




@class GameLayer, Player;

@interface GameScene : CCScene {
	
	GameLayer * gameLayer;
}

- (id) initWithNumOfPlayers:(int)numOfPlayers;

@end



@interface GameLayer : CCLayer <GKSessionDelegate> {
	
//	CCSprite*			background;
//	CCSprite*			background_light;
	
	Player				*_player1;
	Player				*_player2;
	
	CCParticleSystem	*_emitter;
	
	CCSprite			*_blood;
	CCSprite			*_health1Sprite;
	CCSprite			*_health2Sprite;
	
	
	
	CCAnimation			*_goreAnimation;
}

@property (nonatomic, retain) CCSprite *health2Sprite;
@property (nonatomic, retain) CCSprite *health1Sprite;
@property (nonatomic, retain) CCAnimation *goreAnimation;
@property (nonatomic, retain) CCSprite *blood;
@property (nonatomic, retain) CCParticleSystem *emitter;
@property (nonatomic, retain) Player *player1;
@property (nonatomic, retain) Player *player2;

- (id) initWithNumOfPlayers:(int)numOfPlayers;

-(CGRect)spriteRect:(CCSprite *)sp;
-(BOOL)collide:(CGRect)rect1 withRect:(CGRect)rect2;
-(BOOL)collide:(Player *)p1 withPlayer:(Player *)p2;


@end
