//
//  RaptorAppDelegate.h
//  Raptor
//
//  Created by Willi Wu on 28/01/11.
//  Copyright Robocat 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface RaptorAppDelegate : NSObject <UIApplicationDelegate> {
//	UIWindow			*window;
	RootViewController	*viewController;
	
	BOOL paused;
}

+ (RaptorAppDelegate *)appDelegate;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, readwrite, assign) BOOL paused;

@end
