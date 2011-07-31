//
//  RaptorFrenzyControllerViewController.m
//  RaptorFrenzyController
//
//  Created by Mads Hartmann Jensen on 1/28/11.
//  Copyright 2011 Sidewayscoding. All rights reserved.
//

#include <stdlib.h>
#import "RaptorFrenzyControllerViewController.h"
#import "RKSystemSound.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GKExtras.h"

typedef enum {
	Hit = 100, 
	Stun, 
	LowHealth,
} Commands;

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

@implementation RaptorFrenzyControllerViewController

@synthesize gameSession, serverId, connectionAlert, peerIdOfThisController, connectingBackgroundImage, connectingAnimation;
@synthesize rootScreen, connectingScreen, disconnectedScreen, gamepadScreen;

//#define kMaxTankPacketSize 1024

#pragma mark -
#pragma mark View Controller Related Methods

- (void)viewDidLoad {
	DLog();
	[super viewDidLoad];
	[self connect];
	self.connectingAnimation.animationImages =	[NSArray arrayWithObjects:   
											[UIImage imageNamed:@"running1.png"],
											[UIImage imageNamed:@"running2.png"],
											[UIImage imageNamed:@"running3.png"],
											[UIImage imageNamed:@"running4.png"],
											[UIImage imageNamed:@"running5.png"], nil];
	self.connectingAnimation.animationDuration	 = 0.5; // repeat the annimation forever
	self.connectingAnimation.animationRepeatCount = 0;	// repeat the annimation forever
	[self.connectingAnimation startAnimating];			// start animating
//	connectingScreen.hidden		= YES;
//	disconnectedScreen.hidden	= NO;
//	gamepadScreen.hidden		= YES;	
}

- (void)connect {
	DLog();
	connectingScreen.hidden		= NO;
	disconnectedScreen.hidden	= YES;
	gamepadScreen.hidden		= YES;
	connectionAttempts			= 0;
	[self.connectingBackgroundImage setImage:[UIImage imageNamed:@"loadscreen_bg.png"]];
	IOLOG_GKSESSION(@"GKSESSION initWithSessionID");
	self.gameSession = [[[GKSession alloc] initWithSessionID:kRaptorFrenzySessionID 
										   displayName:nil 
										   sessionMode:GKSessionModeClient] autorelease];
	self.connectingAnimation.hidden  = NO;
	self.gameSession.delegate		= self;
	[self.gameSession setDataReceiveHandler:self withContext:nil];
	self.gameSession.available		= YES;
	self.peerIdOfThisController		= gameSession.peerID;
}

- (void)disconnected {
	DLog();
	self.gameSession.available		= NO;
	
	[self.connectingBackgroundImage setImage:[UIImage imageNamed:@"loadscreen_bg.png"]];
	self.connectingAnimation.hidden  = NO;
	connectingScreen.hidden		= YES;
	gamepadScreen.hidden		= YES;
	disconnectedScreen.hidden	= NO;
	
	[self.gameSession disconnectFromAllPeers];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{	
	DLog();
	IOLOG_GKSESSION(@"GKSESSION peerID: %@, name: %@, state: %@", peerID,[session displayNameForPeer:peerID],NSStringFromGKPeerConnectionState(state));
	if ([peerID isEqualToString:serverId]) {
		switch (state)
		{	
			// The server disconnected. Display the proper screen. 
			case GKPeerStateDisconnected:
				[self disconnected];
				break;
			default:
				break;
		}
	} else {
		switch (state)
		{
			// The server is available. Display the proper screen. 
			case GKPeerStateAvailable: 
				[self.connectingBackgroundImage setImage:[UIImage imageNamed:@"foundfight_bg.png"]];
				self.connectingAnimation.hidden = YES;
				[session connectToPeer:peerID withTimeout:10];
				break;
			// This controller is now connected to the server. Display the proper screen.
			case GKPeerStateConnected:
				disconnectedScreen.hidden	= YES;
				connectingScreen.hidden		= YES;
				gamepadScreen.hidden		= NO;
				self.gameSession			= session;
				self.serverId				= peerID;
				[[[RKSystemSound alloc] initWithSoundFile:@"begin"] playSound];
				break;
			default:
				break;
		}
	}
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error {
	DLog();
	connectionAttempts++;
	[session connectToPeer:peerID withTimeout:10];
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error {
	NSLog(@"%@", error);
}

- (void)sendMessage:(NSString *)msg {
	DLog();
//	NSLog(msg);
	NSData *data = [[NSString stringWithString:msg] dataUsingEncoding:NSUTF8StringEncoding];
	[self.gameSession sendDataToAllPeers:data withDataMode:GKSendDataReliable error:nil];
}

#pragma mark View Related 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft 
			|| toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
	DLog();
	// Releases the view if it doesn't have a superview.
 //   [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	DLog();
    [super dealloc];
}


#pragma mark MessageHandler 

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context { 
	DLog();
	
	NSString *received = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	int command = [received intValue];
	
	NSLog(@"%d",command);
	
	switch (command) {
		case Hit: {
			int random = 1 + rand() % 2;
			NSString *name = [NSString stringWithFormat:@"hit%d",random];
			[[[RKSystemSound alloc] initWithSoundFile:name] playSound];
			break;
		}
		case Stun: {
			AudioServicesPlaySystemSound (kSystemSoundID_Vibrate); // vibrate iphone
			int random = 1 + rand() % 4;
			NSString *name = [NSString stringWithFormat:@"ouch%d",random];
			[[[RKSystemSound alloc] initWithSoundFile:name] playSound];
			break;
		}
		case LowHealth:
			[[[RKSystemSound alloc] initWithSoundFile:@"heartbeat"] playSound];
			break;
		default:
			break;
	}
}



#pragma mark IBActions

- (IBAction)reconnect:(id)sender {
	DLog();
	[self connect];
}

- (IBAction)upPressed:(id)sender {
	DLog();
	[self sendMessage:[NSString stringWithFormat:@"%d", ButtonUpPressed]];
}

- (IBAction)upReleased:(id)sender {
	DLog();
	[self sendMessage:[NSString stringWithFormat:@"%d", ButtonUpReleased]];
}

- (void)leftPressed:(id)sender {
	DLog();
	[self sendMessage:[NSString stringWithFormat:@"%d", ButtonLeftPressed]];
	[[[RKSystemSound alloc] initWithSoundFile:@"walk"] playSound];
}

- (void)leftReleased:(id)sender {
	DLog();
	[self sendMessage:[NSString stringWithFormat:@"%d", ButtonLeftReleased]];
}

- (void)rightPressed:(id)sender {
	DLog();
	[[[RKSystemSound alloc] initWithSoundFile:@"walk"] playSound];
	[self sendMessage:[NSString stringWithFormat:@"%d", ButtonRightPressed]];
}

- (void)rightReleased:(id)sender {
	DLog();
	[self sendMessage:[NSString stringWithFormat:@"%d", ButtonRightReleased]];
}

- (void)bitePressed:(id)sender {
	DLog();
	[self sendMessage:[NSString stringWithFormat:@"%d", ButtonAttackPressed]];
}

- (void)biteReleased:(id)sender {
	DLog();
	[self sendMessage:[NSString stringWithFormat:@"%d", ButtonAttackReleased]];
}

@end
