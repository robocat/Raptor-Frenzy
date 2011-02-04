//
//  MultiplayerSession.h
//  Raptor
//
//  Created by Willi Wu on 29/01/11.
//  Copyright 2011 Robocat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface MultiplayerSession : NSObject {
	GKSession	*_gameSession;
	
	NSMutableArray *listOfPlayers;
}

@property (nonatomic, retain) NSMutableArray *listOfPlayers;

+ (MultiplayerSession *)sharedMultiplayerSession;

@property (nonatomic, retain) GKSession *gameSession;

@end
