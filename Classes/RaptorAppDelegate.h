//
//  RaptorAppDelegate.h
//  Raptor
//
//  Created by Willi Wu on 28/01/11.
//  Copyright Robocat 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Log.h"
#import "GameSession.h"

@class RootViewController;

@interface RaptorAppDelegate : NSObject <UIApplicationDelegate> {
//	UIWindow			*window;
	RootViewController	*viewController;
	
	BOOL paused;
}

+ (RaptorAppDelegate *)appDelegate;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet id<LogDelegate> log;
@property (nonatomic, readwrite, assign) BOOL paused;
@property (nonatomic, retain) GameSession *gameSession;

@end
