//
//  GameSession.h
//  Raptor
//
//  Created by Martin Bjerregaard Nielsen on 1/8/11.
//  Copyright 2011 Identified Object. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "GameSessionClient.h"
#import "Log.h"

@protocol GameSessionDelegate <NSObject>
-(void)didReceiveNewClient:(NSString*)clientID;
@end



@interface GameSession : NSObject <GKSessionDelegate>
@property (retain) GKSession *session;
@property (assign) id<LogDelegate> log;
@property (retain) NSMutableDictionary *clients;
@property (assign) id<GameSessionDelegate> delegate;

+(GameSession*)sharedGameSession;
@end
