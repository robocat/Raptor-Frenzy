//
//  ButtonContainer.h
//  RaptorFrenzyController
//
//  Created by Mads Hartmann Jensen on 1/30/11.
//  Copyright 2011 Sidewayscoding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RaptorFrenzyControllerViewController.h"

@interface ButtonContainer : UIView {
		
	IBOutlet RaptorFrenzyControllerViewController *controller;
	IBOutlet UIButton *left;
	IBOutlet UIButton *right;
}

- (BOOL)isAnyTouches:(NSSet *)touches insideButton:(UIButton *)button;
- (BOOL)wasAnyTouches:(NSSet *)touches insideButton:(UIButton *)button;

@end
