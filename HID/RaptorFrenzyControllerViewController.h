//
//  RaptorFrenzyControllerViewController.h
//  RaptorFrenzyController
//
//  Created by Mads Hartmann Jensen on 1/28/11.
//  Copyright 2011 Sidewayscoding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface RaptorFrenzyControllerViewController : UIViewController <GKSessionDelegate, UIAlertViewDelegate> {
		
	int connectionAttempts;	
	
	NSString				*peerIdOfThisController; 
	
	// IB
	IBOutlet	UIImageView *connectingBackgroundImage;
	IBOutlet	UIImageView *connectingAnimation;
	IBOutlet	UIView		*rootScreen; 
	IBOutlet	UIView		*connectingScreen; 
	IBOutlet	UIView		*disconnectedScreen;
	IBOutlet	UIView		*gamepadScreen; 
	
	// Networking 
	GKSession				*gameSession;
	NSString				*serverId;
	UIAlertView				*connectionAlert;	
}

@property(nonatomic, retain) GKSession	 *gameSession;
@property(nonatomic, copy)	 NSString	 *serverId;
@property(nonatomic, retain) UIAlertView *connectionAlert;

- (void)connect;
- (void)disconnected;
- (void)sendMessage:(NSString *)msg;

- (IBAction)reconnect:(id)sender;

// All of these are used inside ButtonContainer
- (IBAction)upPressed:(id)sender;
- (IBAction)upReleased:(id)sender;
- (void)leftPressed:(id)sender;
- (void)leftReleased:(id)sender;
- (void)rightPressed:(id)sender;
- (void)rightReleased:(id)sender;
- (IBAction)bitePressed:(id)sender;
- (IBAction)biteReleased:(id)sender;


@end

