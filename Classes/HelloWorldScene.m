//
//  HelloWorldLayer.m
//  Raptor
//
//  Created by Willi Wu on 28/01/11.
//  Copyright Robocat 2011. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"
#import "GameScene.h"
#import "MultiplayerSession.h"
#import "SimpleAudioEngine.h"
#import "GKExtras.h"




#define	kMinNumOfPlayers		2
#define	kMaxNumOfPlayers		2
#define kRunSprites				5



// HelloWorld implementation
@implementation HelloWorld

@synthesize raptor1 = _raptor1;
@synthesize raptor2 = _raptor2;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
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
		
		CCSprite* titlescreen = [CCSprite spriteWithFile:@"titlescreen.png"];
		titlescreen.position = ccp(winSize.width/2, winSize.height/2);
		titlescreen.scale = 4.0;
		[titlescreen.texture setAliasTexParameters];
		[self addChild:titlescreen];
		
		
		
		
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"raptor.plist"];
		CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"raptor.png"];
		[self addChild:spriteSheet];
//
//		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"raptor2.plist"];
//		CCSpriteBatchNode *spriteSheet2 = [CCSpriteBatchNode batchNodeWithFile:@"raptor2.png"];
//		[self addChild:spriteSheet2];
		
		
		
		
		NSMutableArray *runAnimFrames = [NSMutableArray array];
		for(int i = 1; i <= kRunSprites; ++i) {
			[runAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"running%d.png", i]]];
		}
		CCAnimation *runAnim = [CCAnimation animationWithFrames:runAnimFrames delay:0.08f];
		
		
		id action = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:runAnim restoreOriginalFrame:NO]];
		
		
		// Create sprites for our raptors
		self.raptor1 = [CCSprite spriteWithSpriteFrameName:@"standing1.png"];
		self.raptor1.scale = 4.0;
		[self.raptor1.texture setAliasTexParameters];
		[self.raptor1 runAction:action];
		self.raptor1.position = ccp(-300, 154);
		[self addChild:self.raptor1];

		self.raptor2 = [CCSprite spriteWithSpriteFrameName:@"standing1.png"];
		self.raptor2.scale = 4.0;
		[self.raptor2.texture setAliasTexParameters];
		[self.raptor2 runAction:action];
		self.raptor2.flipX = YES;
		self.raptor2.position = ccp(1024+300, 154);
		[self addChild:self.raptor2];
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"                    " fontName:@"Helvetica" fontSize:64];
		
//		// ask director the the window size
//		CGSize size = [[CCDirector sharedDirector] winSize];
//		
//		// position the label on the center of the screen
//		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		CCMenuItemLabel * newgame = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(newGame:)];
		
		CCMenu * menu = [CCMenu menuWithItems:newgame, nil];
		[self addChild:menu];
		[menu setPosition:ccp(480,120)];
		
		MultiplayerSession *session		= [MultiplayerSession sharedMultiplayerSession];
		session.gameSession.delegate	= self;
		
#ifdef RAPTOR_PLAY_BACKGROUND_MUSIC
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"startscreen.caf" loop:YES];
#endif
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// cocos2d will automatically release all the children (Label)
	[_raptor2 release];
	_raptor2 = nil;

	[_raptor1 release];
	_raptor1 = nil;

	[super dealloc];
}


-(void)newGame:(id)sender
{
	GameScene * gs = [[[GameScene alloc]initWithNumOfPlayers:1]autorelease];
	[[CCDirector sharedDirector]replaceScene:gs];
}


#pragma mark -
#pragma mark <GKSessionDelegate>
- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	IOLOG_GKSESSION(@"GKSESSION didReceiveConnectionRequestFromPeer %@",peerID);
	MultiplayerSession *msession		= [MultiplayerSession sharedMultiplayerSession];
	if ([msession.listOfPlayers count]<kMaxNumOfPlayers) {
		IOLOG_GKSESSION(@"Accepted connection");
		[session acceptConnectionFromPeer:peerID error:nil];
	} else {
		IOLOG_GKSESSION(@"DENIED connection. Max number of players");
		[session denyConnectionFromPeer:peerID];
	}
}


- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
	IOLOG_GKSESSION(@"GKSESSION peer:%@ didChangeState:%@",peerID, NSStringFromGKPeerConnectionState(state));
	MultiplayerSession *msession		= [MultiplayerSession sharedMultiplayerSession];
	
    switch (state)
    {
        case GKPeerStateConnected:
			[msession.listOfPlayers addObject:peerID];
			
			if ([msession.listOfPlayers count] == 1) {
				id action = [CCMoveTo actionWithDuration:3.0 position:ccp(250, 154)];				
				[self.raptor1 runAction:action];
			}
			else {
				id action = [CCSequence actions:
							 [CCMoveTo actionWithDuration:3.0 position:ccp(1024-250, 154)],
							 [CCCallFunc actionWithTarget:self selector:@selector(newGame:)],
							 nil];
				
				[self.raptor2 runAction:action];
			}
			
			break;
        case GKPeerStateDisconnected:
			IOLOG_GKSESSION(@"GKSESSION Peer DISCONNECTED: %@",[session displayNameForPeer:peerID]);
			[msession.listOfPlayers removeObject:peerID];
			break;
		default:
			IOLOG_GKSESSION(@"GKSESSION state change NOT HANDLED: %@", NSStringFromGKPeerConnectionState(state));
			break;
    }
	IOLOG_GKSESSION(@"GKSESSION listOfPlayers %@",msession.listOfPlayers);
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	IOLOG_GKSESSION(@"GKSESSION didFailWithError: %@",error);
	[[UIAlertView alloc] initWithTitle:@"Session failed" message:[NSString stringWithFormat:@"%@",error] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

@end
