//
//  MultiplayerSession.m
//  Raptor
//
//  Created by Willi Wu on 29/01/11.
//  Copyright 2011 Robocat. All rights reserved.
//

#import "MultiplayerSession.h"
#import "SynthesizeSingleton.h"



#define kRaptorFrenzyMaxPlayers		2


@implementation MultiplayerSession

@synthesize listOfPlayers;

SYNTHESIZE_SINGLETON_FOR_CLASS(MultiplayerSession);


@synthesize gameSession = _gameSession;


- (id) init {
    self = [super init];
    if (self != nil) {
		IOLOG_GKSESSION(@"initWithSessionID");
		self.gameSession = [[GKSession alloc] initWithSessionID:kRaptorFrenzySessionID
													displayName:nil
													sessionMode:GKSessionModeServer];
		self.gameSession.available	= YES;
		self.listOfPlayers = [[NSMutableArray alloc] initWithCapacity:2];
    }
	
    return self;
}


-(void)disconnect {
	[self.gameSession disconnectFromAllPeers];
	self.gameSession.available = NO;
	[self.gameSession setDataReceiveHandler: nil withContext: nil];
	self.gameSession.delegate = nil;
}

- (void)dealloc
{
	[self disconnect];
	[_gameSession release];
	_gameSession = nil;

	[listOfPlayers release];
	listOfPlayers = nil;

	[super dealloc];
}


@end
