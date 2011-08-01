//
//  GameSession.m
//  Raptor
//
//  Created by Martin Bjerregaard Nielsen on 1/8/11.
//  Copyright 2011 Identified Object. All rights reserved.
//

#import "GameSession.h"
#import "SynthesizeSingleton.h"
#import "GKExtras.h"

#define kGameSessionMinNumberOfClients 2
#define kGameSessionMaxNumberOfClients 2

@implementation GameSession
@synthesize delegate, session, clients;
@synthesize log;

SYNTHESIZE_SINGLETON_FOR_CLASS(GameSession)

- (id)init
{
    self = [super init];
    if (self) {
		self.clients = [NSMutableDictionary dictionaryWithCapacity:kGameSessionMaxNumberOfClients];
		self.session = [[[GKSession alloc] initWithSessionID:kRaptorFrenzySessionID displayName:nil sessionMode:GKSessionModeServer] autorelease];
		self.session.delegate = self;
		[self.session setDataReceiveHandler:self withContext:nil];
		self.session.available = YES;
    }
    
    return self;
}


-(GameSessionClient*)newClientWithPeerID:(NSString*)peerID {
	GameSessionClient *client = [[GameSessionClient alloc] init];
	client.name = [self.session displayNameForPeer:peerID];
	client.peerID = peerID;
	return client;
}

-(void)logString:(NSString*)logString {
	[self.log logString:logString];
}

#pragma mark -
#pragma mark <GKSessionDelegate>
- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state {
	[self logString:[NSString stringWithFormat:@"peer:%@ (%@) didChangeState:%@",peerID,[self.session displayNameForPeer:peerID],NSStringFromGKPeerConnectionState(state)]];
	switch (state) {
		case GKPeerStateAvailable :
			break;
		case GKPeerStateUnavailable : 
			break;
		case GKPeerStateConnecting :
			break;
		case GKPeerStateConnected : {
			if ([self.clients count]<kGameSessionMaxNumberOfClients) {
				GameSessionClient *client = [[self newClientWithPeerID:peerID] autorelease];
				[self.clients setObject:client forKey:peerID];
				[self logString:@"Added new client"];
				[self.delegate didReceiveNewClient:peerID];
			} else {
				[self.session disconnectPeerFromAllPeers:peerID];
			}
			break;
		}
		case GKPeerStateDisconnected:
			[self.clients removeObjectForKey:peerID];
			break;
		default:
			break;
	}
	if (([self.clients count]>kGameSessionMaxNumberOfClients) && self.session.available) {
		self.session.available = NO;
	} else if (!([self.clients count]>kGameSessionMaxNumberOfClients) && !self.session.available) {
		self.session.available = YES;
	}
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID {
	if ([self.clients count]<kGameSessionMaxNumberOfClients) {
		NSError *error = nil;
		[self logString:[NSString stringWithFormat:@"Accepting connection from peer %@ (%@)",peerID,[self.session displayNameForPeer:peerID]]];
		[self.session acceptConnectionFromPeer:peerID error:&error];
		if (nil!=error) {
			[self logString:[NSString stringWithFormat:@"Failed to accepting peer: %@",error]];
		}
	} else {
		[self logString:[NSString stringWithFormat:@"Denying peer connection %@. Server is full.",peerID]];
		[self.session denyConnectionFromPeer:peerID];
	}
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	[self logString:[NSString stringWithFormat:@"Connection with peer: %@ (%@) failed with error: %@",peerID,[self.session displayNameForPeer:peerID],error]];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	[self logString:[NSString stringWithFormat:@"Session failed with error: %@",error]];
	[self.clients removeAllObjects];
	[self.session disconnectFromAllPeers];
	self.session = nil;
}

#pragma mark -
#pragma mark GKSession DataReceiveHandler
- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context {
	[self logString:[NSString stringWithFormat:@"Received from peer %@ with data %@",peer,data]];
}
@end
