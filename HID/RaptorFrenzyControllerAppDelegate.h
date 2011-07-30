//
//  RaptorFrenzyControllerAppDelegate.h
//  RaptorFrenzyController
//
//  Created by Mads Hartmann Jensen on 1/28/11.
//  Copyright 2011 Sidewayscoding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RaptorFrenzyControllerViewController;

@interface RaptorFrenzyControllerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RaptorFrenzyControllerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RaptorFrenzyControllerViewController *viewController;

@end

