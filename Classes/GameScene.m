//
//  GameScene.m
//  Raptor
//
//  Created by Willi Wu on 28/01/11.
//  Copyright 2011 Robocat. All rights reserved.
//

#import "GameScene.h"
#import	"Player.h"
#import "SimpleAudioEngine.h"
//#import "MultiplayerSession.h"


#define KGameLayer 1
#define KHudLayer 2

#define kHealthBarX 110
#define kHealthBarY 650
#define kHealthMax 80.0




@implementation GameScene



- (id) initWithNumOfPlayers:(int)numOfPlayers {
    self = [super init];
    if (self != nil) {
		
		gameLayer = [[GameLayer alloc]initWithNumOfPlayers:numOfPlayers];
        [self addChild:gameLayer z:0 tag:KGameLayer];
//		[self addChild:[HudLayer node] z:1 tag:KHudLayer];
		
		
    }
    return self;
}

-(void)dealloc
{
	[super dealloc];
	[gameLayer release];
}

@end



@implementation GameLayer

@synthesize player1 = _player1;
@synthesize player2 = _player2;
@synthesize emitter = _emitter;
@synthesize blood = _blood;
@synthesize goreAnimation = _goreAnimation;
@synthesize health2Sprite = _health2Sprite;
@synthesize health1Sprite = _health1Sprite;



- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	[_player2 release];
	_player2 = nil;
	
	[_player1 release];
	_player1 = nil;
	
	[_emitter release];
	_emitter = nil;
	
	[_blood release];
	_blood = nil;
	
	[_goreAnimation release];
	_goreAnimation = nil;

	
	[_health1Sprite release];
	_health1Sprite = nil;
	
	[_health2Sprite release];
	_health2Sprite = nil;
	
	
	[super dealloc];
}


// on "init" you need to initialize your instance
-(id) initWithNumOfPlayers:(int)numOfPlayers
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		CGSize winSize = [CCDirector sharedDirector].winSize;
		
		CCSprite* background = [CCSprite spriteWithFile:@"bg.png"];
		background.position = ccp(winSize.width/2, winSize.height/2);
		background.scale = 4.0;
		[background.texture setAliasTexParameters];
		[self addChild:background];
		
		self.player1 = [[Player alloc] initWithGame:self withSpritePlist:@"raptor2.plist" withSpriteImage:@"raptor2.png"];
		self.player1.position = ccp(winSize.width/2 - 300.0, winSize.height - winSize.height + 154);
		[self addChild:self.player1];
		
		
		self.player2 = [[Player alloc] initWithGame:self withSpritePlist:@"raptor.plist" withSpriteImage:@"raptor.png"];
		self.player2.position = ccp(winSize.width/2 + 300.0, winSize.height - winSize.height + 154);
		[self.player2 facingDirection:PlayerFacingLeft];
		[self addChild:self.player2];
		
		self.isTouchEnabled = YES;
		
//		MultiplayerSession *session		= [MultiplayerSession sharedMultiplayerSession];
//		session.gameSession.delegate	= self;
//		[session.gameSession setDataReceiveHandler:self withContext:nil];
		
		
		self.emitter = [CCParticleSystemQuad particleWithFile:@"blood_effect.plist"];
		self.emitter.position = ccp(-1000,0);
		[self addChild:self.emitter z:10];
		
		
		[self schedule:@selector(step:)];
		
//		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"in_game.caf" loop:YES];
		
		
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"effects.plist"];        
		CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"effects.png"];
		[self addChild:spriteSheet];
		
		NSMutableArray *goreAnimFrames = [NSMutableArray array];
		for(int i = 1; i <= 4; ++i) {
			[goreAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"gore%d.png", i]]];
		}
		CCAnimation *goreAnim = [CCAnimation animationWithFrames:goreAnimFrames delay:0.04f];
		self.goreAnimation = goreAnim;
		
		CCSprite *gore1 = [CCSprite spriteWithSpriteFrameName:@"gore1.png"];
		gore1.scale = 4.0;
		[gore1.texture setAliasTexParameters];
		self.player1.gore = gore1;
		[self.player1 stopGore];
		[spriteSheet addChild:gore1];
		
		
		CCSprite *gore2 = [CCSprite spriteWithSpriteFrameName:@"gore1.png"];
		gore2.scale = 4.0;
		[gore2.texture setAliasTexParameters];
		self.player2.gore = gore2;
		self.player2.gore.flipX = YES;
		[self.player2 stopGore];
		[spriteSheet addChild:gore2];
		
		
		// Health bars
		CCSprite *health1_bg = [CCSprite spriteWithSpriteFrameName:@"healthbar_empty.png"];
		health1_bg.scale = 4.0;
		health1_bg.anchorPoint = ccp(0.0,0.0);
		health1_bg.position = ccp(kHealthBarX,kHealthBarY);
		[self addChild:health1_bg];

		self.health1Sprite = [CCSprite spriteWithFile:@"green_health.png"];
		[self.health1Sprite.texture setAliasTexParameters];
		self.health1Sprite.scale = 4.0;
		self.health1Sprite.position = ccp(kHealthBarX+8,kHealthBarY);
		self.health1Sprite.anchorPoint = ccp(0.0,0.0);
		[self addChild:self.health1Sprite];
		
		CCSprite *health2_bg = [CCSprite spriteWithSpriteFrameName:@"healthbar_empty.png"];
		health2_bg.scale = 4.0;
		health2_bg.position = ccp(1024-kHealthBarX,kHealthBarY);
		health2_bg.anchorPoint = ccp(1.0,0.0);
		[self addChild:health2_bg];

		self.health2Sprite = [CCSprite spriteWithSpriteFrameName:@"health.png"];
		self.health2Sprite.scale = 4.0;
		self.health2Sprite.anchorPoint = ccp(1.0,0.0);
		self.health2Sprite.position = ccp(1024-kHealthBarX-8,kHealthBarY);
		[self addChild:self.health2Sprite];
	}
	return self;
}



- (void)updateHealth:(CCSprite *)health toValue:(float)value
{
//	id action = [CCScaleTo actionWithDuration:0.2 scaleX:value/80.0 scaleY:1.0];
//	[health runAction:action];
	health.scaleX = 4.0*value/kHealthMax;
}


- (void)showExtinct:(NSInteger)player
{
	NSString *extinct = nil;
	
	if (player == 1) {
		extinct = @"green_extinct.png";
	}
	else {
		extinct = @"red_extinct.png";
	}
	
	CGSize winSize = [CCDirector sharedDirector].winSize;

	CCSprite* background = [CCSprite spriteWithFile:extinct];
	background.tag = 111;
	background.position = ccp(2024, 768);
	background.scale = 4.0;
	[background.texture setAliasTexParameters];
	[self addChild:background];
	
	
	id action = [CCMoveTo actionWithDuration:0.3 position:ccp(winSize.width/2, winSize.height/2)];
	[background runAction:action];
	
	
	CCLabelTTF *label = [CCLabelTTF labelWithString:@"Restart" fontName:@"Helvetica" fontSize:64];
	CCMenuItemLabel * newgame = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(restartGame)];
	
	CCMenu * menu = [CCMenu menuWithItems:newgame, nil];
	menu.tag = 222;
	[self addChild:menu];
	[menu setPosition:ccp(480,120)];
	
}

- (void)restartGame
{
	
	[self removeChildByTag:111 cleanup:YES];
	[self removeChildByTag:222 cleanup:YES];
	
	self.health1Sprite.scale = 4.0;
	self.health1Sprite.position = ccp(kHealthBarX+8,kHealthBarY);
	self.health2Sprite.scale = 4.0;
	self.health2Sprite.position = ccp(1024-kHealthBarX-8,kHealthBarY);
	
	CGSize winSize = [CCDirector sharedDirector].winSize;
	
	self.player1.position = ccp(winSize.width/2 - 300.0, winSize.height - winSize.height + 154);
	[self.player1 facingDirection:PlayerFacingRight];
	[self.player1 resetPlayer];
	
	
	self.player2.position = ccp(winSize.width/2 + 300.0, winSize.height - winSize.height + 154);
	[self.player2 facingDirection:PlayerFacingLeft];
	[self.player2 resetPlayer];
}


-(void)step:(ccTime *)dt
{
	float damage1 = [self.player2 resolveAttackOn:self.player1];
	float damage2 = [self.player1 resolveAttackOn:self.player2];
	
	
//	MultiplayerSession *session = [MultiplayerSession sharedMultiplayerSession];
	
	if ((damage1 > 0) && (self.player1.health>0.0)) {
//		
//		if ([session.listOfPlayers count] > 1) {
//			NSData *data = [[NSString stringWithFormat:@"%d", CommandHit] dataUsingEncoding:NSUTF8StringEncoding];
//			[session.gameSession sendData:data toPeers:[NSArray arrayWithObject:[session.listOfPlayers objectAtIndex:1]] withDataMode:GKSendDataReliable error:nil];
//		}
//		
//		NSData *data2 = [[NSString stringWithFormat:@"%d", CommandStun] dataUsingEncoding:NSUTF8StringEncoding];
//		[session.gameSession sendData:data2 toPeers:[NSArray arrayWithObject:[session.listOfPlayers objectAtIndex:0]] withDataMode:GKSendDataReliable error:nil];
				
		[self.player1 stunned];
		self.player1.health -= damage1;
		
		LOG_EXPR(self.player1.health);
		
		[self updateHealth:self.health1Sprite toValue:self.player1.health];
		
		if (self.player1.health <= 10.0) {
//			NSData *data3 = [[NSString stringWithFormat:@"%d", CommandLowHealth] dataUsingEncoding:NSUTF8StringEncoding];
//			[session.gameSession sendData:data3 toPeers:[NSArray arrayWithObject:[session.listOfPlayers objectAtIndex:0]] withDataMode:GKSendDataReliable error:nil];
		}
		
		if (self.player1.health <= 0.0) {
			[self.player1 dead];
			[self showExtinct:1];
		}
	}
	
	if ((damage2 > 0) && (self.player2.health>0.0)) {
		
//		NSData *data = [[NSString stringWithFormat:@"%d", CommandHit] dataUsingEncoding:NSUTF8StringEncoding];
//		[session.gameSession sendData:data toPeers:[NSArray arrayWithObject:[session.listOfPlayers objectAtIndex:0]] withDataMode:GKSendDataReliable error:nil];
//		
//		if ([session.listOfPlayers count] > 1) {
//			NSData *data2 = [[NSString stringWithFormat:@"%d", CommandStun] dataUsingEncoding:NSUTF8StringEncoding];
//			[session.gameSession sendData:data2 toPeers:[NSArray arrayWithObject:[session.listOfPlayers objectAtIndex:1]] withDataMode:GKSendDataReliable error:nil];
//		}
		
		
		[self.player2 stunned];
		self.player2.health -= damage2;
		
		LOG_EXPR(self.player2.health);
		
		[self updateHealth:self.health2Sprite toValue:self.player2.health];
		
		if (self.player2.health <= 10.0) {
//			NSData *data3 = [[NSString stringWithFormat:@"%d", CommandLowHealth] dataUsingEncoding:NSUTF8StringEncoding];
//			[session.gameSession sendData:data3 toPeers:[NSArray arrayWithObject:[session.listOfPlayers objectAtIndex:1]] withDataMode:GKSendDataReliable error:nil];
		}
		
		if (self.player2.health <= 0.0) {
			[self.player2 dead];
			[self showExtinct:2];
		}
	}
}

-(void)pauseGame
{
	[self onExit];
}

- (void) onExit
{
	if(![RaptorAppDelegate appDelegate].paused)
	{
		[RaptorAppDelegate appDelegate].paused = YES;
		[super onExit];
	}
}

- (void) resume
{
	if(![RaptorAppDelegate appDelegate].paused)
	{
		return;
	}
	[RaptorAppDelegate appDelegate].paused =NO;
	[self onEnter];
}

- (void) onEnter
{
	if(![RaptorAppDelegate appDelegate].paused )
	{
		[super onEnter];
	}
}







- (CGRect)spriteRect:(CCSprite *)sp
{
	CGRect rect = CGRectMake(sp.position.x - sp.textureRect.size.width * 2.0,
							 sp.position.y - sp.textureRect.size.height * 2.0,
							 sp.textureRect.size.width * 4.0,
							 sp.textureRect.size.height * 4.0);
	return rect;
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

- (BOOL)collide:(Player *)p1 withPlayer:(Player *)p2
{
	CGRect rect1 = [self spriteRect:p1.sprite];
	CGRect rect2 = [self spriteRect:p2.sprite];
	
	return [self collide:rect1 withRect:rect2];
}


- (BOOL)touch:(Player *)p withPoint:(CGPoint)point
{
	BOOL touched = NO;
	
	CGRect rect = [self spriteRect:p.sprite];
	
	if (CGRectContainsPoint(rect, point))
	{
		touched = YES;
	}
	
	return touched;
}




#pragma mark Data Exchange 


- (void)touchedButton:(Button)button forPlayer:(Player *)player
{
	switch (button) {
		case ButtonUpPressed:
			[player jump];
			break;
		case ButtonLeftPressed:
			[player moveTo:CGPointMake(0, 154)];
			break;
		case ButtonLeftReleased:
			[player stand];
			break;
		case ButtonRightPressed:
			[player moveTo:CGPointMake(1024, 154)];
			break;
		case ButtonRightReleased:
			[player stand];
			break;			
		case ButtonAttackPressed:
			[player attack];
			break;
		case ButtonAttackReleased:
			[player stopAttack];
			break;
		default:
			break;
	}
}



/*
 * Getting a data packet. This is the data receive handler method expected by the GKSession. 
 * We set ourselves as the receive data handler in the -peerPickerController:didConnectPeer:toSession: method.
 */
- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {
	NSString *received = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	Button button = [received intValue];
	
	
	LOG_EXPR(button);
	LOG_EXPR(peer);
	LOG_EXPR(data);
	
	
//	NSArray *list = [[MultiplayerSession sharedMultiplayerSession] listOfPlayers];
	
//	if ([peer isEqualToString:[list objectAtIndex:0]]) {
//		[self touchedButton:button forPlayer:self.player1];
//	}
//	else {
//		[self touchedButton:button forPlayer:self.player2];
//	}
}





// Touch
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {    
	CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
//	if ([self collide:self.player1 withPlayer:self.player2]
//		&& [self touch:self.player2 withPoint:touchLocation]) {
	
//	if ([self touch:self.player2 withPoint:touchLocation]) {
//		[self.player1 attack];
//	}
//	else if ([self touch:self.player1 withPoint:touchLocation]) {
//		[self.player1 jump];
//	}
//	else {
//		[self.player1 moveTo:touchLocation];
//	}
	
	
	
	
//	[self.player1 stunned];
}


@end
